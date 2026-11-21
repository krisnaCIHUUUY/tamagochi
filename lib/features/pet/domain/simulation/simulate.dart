import 'dart:math';

import '../entities/care_style.dart';
import '../entities/life_stage.dart';
import '../entities/pet_state.dart';
import '../rules/game_rules.dart';
import 'evolution.dart';

PetState simulate(
  PetState state, {
  required DateTime from,
  required DateTime to,
  bool offline = false,
}) {
  if (to.isBefore(from)) return state;

  var t = from;
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
  // Keadaan sesaat sebelum `from`, agar transisi tepat di `from` ikut terdeteksi.
  var wasAsleep = state.isAsleepAt(
    from.subtract(const Duration(microseconds: 1)),
  );

  // K1: waktu offline tidak menurunkan meter di bawah 10.
  // Meter yang sudah di bawah 10 tidak dinaikkan.
  final fullnessFloor = offline
      ? min(state.fullness, GameRules.offlineFloor)
      : GameRules.minMeter;
  final happinessFloor = offline
      ? min(state.happiness, GameRules.offlineFloor)
      : GameRules.minMeter;

  const oneMinute = Duration(minutes: 1);

  var careStyle = state.careStyle;
  var neglectMinutes = careStyle.neglectMinutes;
  var character = state.character;
  var pendingReveal = state.pendingReveal;

  while (t.isBefore(to)) {
    final remaining = to.difference(t);
    final step = remaining < oneMinute ? remaining : oneMinute;
    final asleep = state.isAsleepAt(t);

    // K10: saat liburan meter, kotoran, sakit, dan murung dibekukan.
    // Waktu dan tahap tetap berjalan.
    if (!onVacation) {
      final hours = step.inMicroseconds / Duration.microsecondsPerHour;

      final multiplier = switch (stage) {
        LifeStage.egg => 0.0,
        LifeStage.baby => GameRules.babyDecayMultiplier,
        _ => 1.0,
      };

      if (asleep && !wasAsleep) {
        // Baru tertidur: catat apakah lampu menyala sejak awal tidur.
        lightsOnAllSleep = lightsOn;
      } else if (!asleep && wasAsleep) {
        // Baru bangun (K12).
        if (lightsOnAllSleep) happiness -= GameRules.lightsOnWakePenalty;
        lightsOn = true;
        lightsOnAllSleep = false;
      }

      if (!asleep) {
        // Kotoran yang jatuh tempo saat tidur baru muncul di menit bangun ini (K9).
        final dueCount = poopDueAt.where((due) => !due.isAfter(t)).length;
        if (dueCount > 0) {
          poopDueAt.removeWhere((due) => !due.isAfter(t));
          poop = (poop + dueCount).clamp(0, GameRules.maxPoop);
          firstPoopAt ??= t;
        }

        fullness -= GameRules.fullnessDecayPerHour * hours * multiplier;
        happiness -= GameRules.happinessDecayPerHour * hours * multiplier;
      }

      fullness = fullness.clamp(fullnessFloor, GameRules.maxMeter).toDouble();
      happiness = happiness
          .clamp(happinessFloor, GameRules.maxMeter)
          .toDouble();

      // D5: timer sakit hanya berjalan saat bangun. Saat tidur berhenti, tidak direset.
      if (!asleep && !isSick) {
        final zeroNeed =
            fullness <= GameRules.minMeter || happiness <= GameRules.minMeter;
        zeroNeedFor = zeroNeed ? zeroNeedFor + step : Duration.zero;
        heavyPoopFor = poop >= GameRules.sickPoopThreshold
            ? heavyPoopFor + step
            : Duration.zero;

        if (zeroNeedFor > GameRules.sickZeroNeedAfter ||
            heavyPoopFor >= GameRules.sickPoopAfter) {
          isSick = true;
          // D6: reset agar pet tidak langsung sakit lagi setelah sembuh.
          zeroNeedFor = Duration.zero;
          heavyPoopFor = Duration.zero;
        }
      }

      // D7: timer murung juga hanya berjalan saat bangun.
      if (!asleep) {
        final lowBoth =
            fullness <= GameRules.moodyThreshold &&
            happiness <= GameRules.moodyThreshold;
        lowBothFor = lowBoth ? lowBothFor + step : Duration.zero;
        if (lowBothFor >= GameRules.moodyAfter) isMoody = true;
      }
    }
    wasAsleep = asleep;

    // K6: menit terlantar dihitung sejak tahap Anak.
    // shortcut: langkah < 1 menit tidak dihitung; ganti ke Duration bila selisihnya terasa.
    if (stage.index >= LifeStage.child.index && step == oneMinute) {
      final neglected =
          onVacation ||
          (!asleep &&
              (fullness <= GameRules.neglectThreshold ||
                  happiness <= GameRules.neglectThreshold));
      if (neglected) neglectMinutes++;
    }

    t = t.add(step);

    final stageDuration = switch (stage) {
      LifeStage.egg => GameRules.eggDuration,
      LifeStage.baby => GameRules.babyDuration,
      LifeStage.child => GameRules.childDuration,
      LifeStage.teen => GameRules.teenDuration,
      LifeStage.adult => null,
    };

    if (stageDuration != null &&
        t.difference(stageStartedAt) >= stageDuration) {
      // Evolusi di akhir tahap Anak (pertama) dan Remaja (kedua), K5.
      if (stage == LifeStage.child || stage == LifeStage.teen) {
        character = chooseCharacter(
          careStyle.copyWith(neglectMinutes: neglectMinutes),
        );
        careStyle = const CareStyle();
        neglectMinutes = 0;
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
    careStyle: careStyle.copyWith(neglectMinutes: neglectMinutes),
    character: character,
    pendingReveal: pendingReveal,
  );
}
