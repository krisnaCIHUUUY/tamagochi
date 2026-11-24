import 'dart:math';

import '../entities/care_style.dart';
import '../entities/life_stage.dart';
import '../entities/pet_state.dart';
import '../entities/sleep_schedule.dart';
import '../rules/game_rules.dart';
import 'evolution.dart';

/// Simulasi per kejadian (D12). Waktu melompat dari satu kejadian ke kejadian
/// berikutnya; di antara dua kejadian semua kondisi tetap, jadi meter turun
/// lurus dan timer bertambah sepanjang segmen.
///
/// Dua jenis kejadian:
/// - **di awal segmen** (tidur/bangun, kotoran muncul): diproses saat segmen
///   dimulai di `t`, jadi kejadian tepat di `to` diproses panggilan berikutnya;
/// - **saat dicapai** (ambang timer, tahap, liburan): diproses begitu `t`
///   mencapainya, termasuk tepat di `to`.
PetState simulate(
  PetState state, {
  required DateTime from,
  required DateTime to,
  bool offline = false,
}) {
  if (to.isBefore(from)) return state;

  var fullness = state.fullness;
  var happiness = state.happiness;
  var stage = state.stage;
  var stageStartedAt = state.stageStartedAt;
  var poop = state.poop;
  // Salin: list dari freezed tidak bisa diubah.
  final poopDueAt = [...state.poopDueAt];
  var firstPoopAt = state.firstPoopAt;
  var lightsOn = state.lightsOn;
  var lightsOnAllSleep = state.lightsOnAllSleep;
  var isSick = state.isSick;
  var zeroNeedFor = state.zeroNeedFor;
  var heavyPoopFor = state.heavyPoopFor;
  var isMoody = state.isMoody;
  var lowBothFor = state.lowBothFor;
  var onVacation = state.onVacation;
  var careStyle = state.careStyle;
  var neglectedFor = careStyle.neglectedFor;
  var character = state.character;
  var pendingReveal = state.pendingReveal;

  // K1: waktu offline tidak menurunkan meter di bawah 10.
  // Meter yang sudah di bawah 10 tidak dinaikkan.
  final fullnessFloor = offline
      ? min(state.fullness, GameRules.offlineFloor)
      : GameRules.minMeter;
  final happinessFloor = offline
      ? min(state.happiness, GameRules.offlineFloor)
      : GameRules.minMeter;

  var t = from;
  // Keadaan sesaat sebelum `from`, agar transisi tepat di `from` ikut terdeteksi.
  var wasAsleep = state.isAsleepAt(
    from.subtract(const Duration(microseconds: 1)),
  );

  while (t.isBefore(to)) {
    final asleep = state.isAsleepAt(t);

    // 1. Kejadian di awal segmen. K10: saat liburan semuanya dibekukan.
    if (!onVacation) {
      if (asleep && !wasAsleep) {
        // Baru tertidur: catat apakah lampu menyala sejak awal tidur.
        lightsOnAllSleep = lightsOn;
      } else if (!asleep && wasAsleep) {
        // Baru bangun (K12).
        if (lightsOnAllSleep) happiness -= GameRules.lightsOnWakePenalty;
        lightsOn = true;
        lightsOnAllSleep = false;
        happiness = happiness
            .clamp(happinessFloor, GameRules.maxMeter)
            .toDouble();
      }

      if (!asleep) {
        // Kotoran yang jatuh tempo saat tidur baru muncul saat bangun (K9).
        final dueCount = poopDueAt.where((due) => !due.isAfter(t)).length;
        if (dueCount > 0) {
          poopDueAt.removeWhere((due) => !due.isAfter(t));
          poop = (poop + dueCount).clamp(0, GameRules.maxPoop);
          firstPoopAt ??= t;
        }
      }
    }
    wasAsleep = asleep;

    // 2. Kondisi segmen ini. Semuanya tetap sampai kejadian berikutnya.
    final careRuns = !onVacation && !asleep;
    final multiplier = switch (stage) {
      LifeStage.egg => 0.0,
      LifeStage.baby => GameRules.babyDecayMultiplier,
      _ => 1.0,
    };
    final fullnessRate = careRuns
        ? GameRules.fullnessDecayPerHour * multiplier
        : 0.0;
    final happinessRate = careRuns
        ? GameRules.happinessDecayPerHour * multiplier
        : 0.0;

    // D5: timer sakit hanya berjalan saat bangun dan belum sakit; saat tidur berhenti.
    final sickTimersRun = careRuns && !isSick;
    final zeroNeed =
        fullness <= GameRules.minMeter || happiness <= GameRules.minMeter;
    final heavyPoop = poop >= GameRules.sickPoopThreshold;
    if (sickTimersRun && !zeroNeed) zeroNeedFor = Duration.zero;
    if (sickTimersRun && !heavyPoop) heavyPoopFor = Duration.zero;

    // D7: timer murung hanya berjalan saat bangun.
    final lowBoth =
        fullness <= GameRules.moodyThreshold &&
        happiness <= GameRules.moodyThreshold;
    if (careRuns && !lowBoth) lowBothFor = Duration.zero;

    // K6: menit terlantar sejak tahap Anak: liburan, atau bangun dengan meter ≤ 20.
    final neglecting =
        stage.index >= LifeStage.child.index &&
        (onVacation ||
            (!asleep &&
                (fullness <= GameRules.neglectThreshold ||
                    happiness <= GameRules.neglectThreshold)));

    // 3. Kejadian berikutnya yang paling dekat.
    var end = to;
    void consider(DateTime? at) {
      if (at != null && at.isAfter(t) && at.isBefore(end)) end = at;
    }

    consider(_nextSleepChange(state.sleepSchedule, t));
    final stageDuration = _stageDuration(stage);
    if (stageDuration != null) consider(stageStartedAt.add(stageDuration));
    if (!onVacation) consider(state.lastCareAt.add(GameRules.vacationAfter));
    if (careRuns) poopDueAt.forEach(consider);
    for (final level in const [
      GameRules.minMeter,
      GameRules.moodyThreshold,
      GameRules.neglectThreshold,
    ]) {
      consider(_reachTime(t, fullness, level, fullnessRate, fullnessFloor));
      consider(_reachTime(t, happiness, level, happinessRate, happinessFloor));
    }
    if (sickTimersRun && zeroNeed) {
      consider(t.add(GameRules.sickZeroNeedAfter - zeroNeedFor));
    }
    if (sickTimersRun && heavyPoop) {
      consider(t.add(GameRules.sickPoopAfter - heavyPoopFor));
    }
    if (careRuns && lowBoth && !isMoody) {
      consider(t.add(GameRules.moodyAfter - lowBothFor));
    }

    // 4. Jalankan segmen sampai `end`.
    final span = end.difference(t);
    final hours = span.inMicroseconds / Duration.microsecondsPerHour;
    fullness = (fullness - fullnessRate * hours)
        .clamp(fullnessFloor, GameRules.maxMeter)
        .toDouble();
    happiness = (happiness - happinessRate * hours)
        .clamp(happinessFloor, GameRules.maxMeter)
        .toDouble();
    if (sickTimersRun && zeroNeed) zeroNeedFor += span;
    if (sickTimersRun && heavyPoop) heavyPoopFor += span;
    if (careRuns && lowBoth) lowBothFor += span;
    if (neglecting) neglectedFor += span;
    t = end;

    // 5. Kejadian saat dicapai.
    // D12: dalam waktu kontinu, sakit tepat saat meter 0 sudah 60 menit.
    if (sickTimersRun &&
        (zeroNeedFor >= GameRules.sickZeroNeedAfter ||
            heavyPoopFor >= GameRules.sickPoopAfter)) {
      isSick = true;
      // D6: reset agar pet tidak langsung sakit lagi setelah sembuh.
      zeroNeedFor = Duration.zero;
      heavyPoopFor = Duration.zero;
    }
    if (careRuns && lowBothFor >= GameRules.moodyAfter) isMoody = true;

    if (stageDuration != null &&
        t.difference(stageStartedAt) >= stageDuration) {
      // Evolusi di akhir tahap Anak (pertama) dan Remaja (kedua), K5.
      if (stage == LifeStage.child || stage == LifeStage.teen) {
        character = chooseCharacter(
          careStyle.copyWith(neglectedFor: neglectedFor),
        );
        careStyle = const CareStyle();
        neglectedFor = Duration.zero;
        pendingReveal = true;
      }
      stage = LifeStage.values[stage.index + 1];
      stageStartedAt = stageStartedAt.add(stageDuration);
    }

    // Jam dinding, termasuk jam tidur.
    if (!onVacation &&
        t.difference(state.lastCareAt) >= GameRules.vacationAfter) {
      onVacation = true;
    }
  }

  return state.copyWith(
    lastUpdated: to,
    fullness: fullness,
    happiness: happiness,
    stage: stage,
    stageStartedAt: stageStartedAt,
    poop: poop,
    poopDueAt: poopDueAt,
    firstPoopAt: firstPoopAt,
    lightsOn: lightsOn,
    lightsOnAllSleep: lightsOnAllSleep,
    isSick: isSick,
    zeroNeedFor: zeroNeedFor,
    heavyPoopFor: heavyPoopFor,
    isMoody: isMoody,
    lowBothFor: lowBothFor,
    onVacation: onVacation,
    careStyle: careStyle.copyWith(neglectedFor: neglectedFor),
    character: character,
    pendingReveal: pendingReveal,
  );
}

Duration? _stageDuration(LifeStage stage) => switch (stage) {
  LifeStage.egg => GameRules.eggDuration,
  LifeStage.baby => GameRules.babyDuration,
  LifeStage.child => GameRules.childDuration,
  LifeStage.teen => GameRules.teenDuration,
  LifeStage.adult => null,
};

/// Jam lokal berikutnya setelah [t] saat pet mulai tidur atau bangun.
DateTime _nextSleepChange(SleepSchedule schedule, DateTime t) {
  final local = t.toLocal();
  DateTime? next;
  for (final day in const [0, 1]) {
    for (final hour in [schedule.startHour, schedule.endHour]) {
      final at = DateTime(local.year, local.month, local.day + day, hour);
      if (at.isAfter(t) && (next == null || at.isBefore(next))) next = at;
    }
  }
  return next!;
}

/// Kapan [meter] yang turun [ratePerHour] mencapai [level]; null bila tidak akan.
DateTime? _reachTime(
  DateTime t,
  double meter,
  double level,
  double ratePerHour,
  double floor,
) {
  if (ratePerHour <= 0 || meter <= level || level < floor) return null;
  final micros = (meter - level) / ratePerHour * Duration.microsecondsPerHour;
  // ceil: segmen pasti mencapai ambang, tidak berhenti sedikit di atasnya.
  return t.add(Duration(microseconds: micros.ceil()));
}
