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

    if (!state.isAsleepAt(t)) {
      fullness -= GameRules.fullnessDecayPerHour * hours * multiplier;
      happiness -= GameRules.happinessDecayPerHour * hours * multiplier;
    }

    fullness = fullness
        .clamp(GameRules.minMeter, GameRules.maxMeter)
        .toDouble();

    happiness = happiness
        .clamp(GameRules.minMeter, GameRules.maxMeter)
        .toDouble();

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
  );
}
