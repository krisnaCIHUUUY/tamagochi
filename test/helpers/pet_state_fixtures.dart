import 'package:tamagochi/features/pet/domain/entities/life_stage.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';

/// Jam bangun (10.00) dengan jadwal tidur default 21.00–07.00.
final fixtureNow = DateTime(2026, 1, 5, 10);

/// Pet yang sedang bangun di [fixtureNow]; default tahap Anak (laju meter normal).
PetState awakePet({
  double fullness = 80,
  double happiness = 80,
  LifeStage stage = LifeStage.child,
}) {
  return PetState(
    bornAt: fixtureNow.subtract(const Duration(days: 2)),
    lastUpdated: fixtureNow,
    lastCareAt: fixtureNow,
    stageStartedAt: fixtureNow.subtract(const Duration(hours: 1)),
    stage: stage,
    fullness: fullness,
    happiness: happiness,
  );
}
