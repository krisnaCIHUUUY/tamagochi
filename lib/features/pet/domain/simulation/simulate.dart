import '../entities/life_stage.dart';
import '../entities/pet_state.dart';
import '../rules/game_rules.dart';

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
  // Keadaan sesaat sebelum `from`, agar transisi tepat di `from` ikut terdeteksi.
  var wasAsleep = state.isAsleepAt(
    from.subtract(const Duration(microseconds: 1)),
  );

  const oneMinute = Duration(minutes: 1);

  while (t.isBefore(to)) {
    final remaining = to.difference(t);
    final step = remaining < oneMinute ? remaining : oneMinute;

    final hours = step.inMicroseconds / Duration.microsecondsPerHour;

    final multiplier = switch (stage) {
      LifeStage.egg => 0.0,
      LifeStage.baby => GameRules.babyDecayMultiplier,
      _ => 1.0,
    };

    final asleep = state.isAsleepAt(t);

    if (asleep && !wasAsleep) {
      // Baru tertidur: catat apakah lampu menyala sejak awal tidur.
      lightsOnAllSleep = lightsOn;
    } else if (!asleep && wasAsleep) {
      // Baru bangun (K12).
      if (lightsOnAllSleep) happiness -= GameRules.lightsOnWakePenalty;
      lightsOn = true;
      lightsOnAllSleep = false;
    }
    wasAsleep = asleep;

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

    fullness = fullness
        .clamp(GameRules.minMeter, GameRules.maxMeter)
        .toDouble();

    happiness = happiness
        .clamp(GameRules.minMeter, GameRules.maxMeter)
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

    t = t.add(step);

    if (stage == LifeStage.egg &&
        t.difference(stageStartedAt) >= GameRules.eggDuration) {
      stage = LifeStage.baby;
      stageStartedAt = stageStartedAt.add(GameRules.eggDuration);
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
  );
}
