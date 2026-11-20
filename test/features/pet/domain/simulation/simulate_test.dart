import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/life_stage.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun).
  PetState petAt(DateTime t, {LifeStage stage = LifeStage.child}) =>
      awakePet(stage: stage).copyWith(lastUpdated: t);

  test('awake 2h: fullness 80 -> 64, happiness 80 -> 68', () {
    final to = fixtureNow.add(const Duration(hours: 2));

    final result = simulate(petAt(fixtureNow), from: fixtureNow, to: to);

    expect(result.fullness, closeTo(64, 0.001));
    expect(result.happiness, closeTo(68, 0.001));
    expect(result.lastUpdated, to);
  });

  test('fully asleep range leaves meters unchanged', () {
    final night = DateTime(2026, 1, 5, 22);
    final morning = DateTime(2026, 1, 6, 6);

    final result = simulate(petAt(night), from: night, to: morning);

    expect(result.fullness, 80);
    expect(result.happiness, 80);
    expect(result.lastUpdated, morning);
  });

  test('to before from returns identical state', () {
    final pet = petAt(fixtureNow);

    final result = simulate(
      pet,
      from: fixtureNow,
      to: fixtureNow.subtract(const Duration(hours: 1)),
    );

    expect(result, same(pet));
  });

  test('range crossing bedtime only decays awake part', () {
    final evening = DateTime(2026, 1, 5, 20);

    final result = simulate(
      petAt(evening),
      from: evening,
      to: DateTime(2026, 1, 5, 22),
    );

    // Hanya 20.00–21.00 yang bangun: kenyang −8, senang −6.
    expect(result.fullness, closeTo(72, 0.001));
    expect(result.happiness, closeTo(74, 0.001));
  });

  test('baby decays twice as fast', () {
    final result = simulate(
      petAt(fixtureNow, stage: LifeStage.baby),
      from: fixtureNow,
      to: fixtureNow.add(const Duration(hours: 1)),
    );

    expect(result.fullness, closeTo(64, 0.001));
    expect(result.happiness, closeTo(68, 0.001));
  });

  test('egg does not decay and hatches after 5 minutes', () {
    final egg = PetState.newEgg(fixtureNow);
    final hatchAt = fixtureNow.add(const Duration(minutes: 5));

    final before = simulate(
      egg,
      from: fixtureNow,
      to: fixtureNow.add(const Duration(minutes: 4)),
    );
    final after = simulate(egg, from: fixtureNow, to: hatchAt);

    expect(before.stage, LifeStage.egg);
    expect(after.stage, LifeStage.baby);
    expect(after.stageStartedAt, hatchAt);
    expect(after.fullness, 80);
    expect(after.happiness, 80);
  });

  test('lastUpdated equals to after partial minute', () {
    final to = fixtureNow.add(const Duration(seconds: 90));

    final result = simulate(petAt(fixtureNow), from: fixtureNow, to: to);

    expect(result.lastUpdated, to);
    // 1,5 menit × 8/jam = 0,2
    expect(result.fullness, closeTo(79.8, 0.001));
  });

  test('meters clamp at 0', () {
    final pet = awakePet(fullness: 5, happiness: 5);

    final result = simulate(
      pet,
      from: fixtureNow,
      to: fixtureNow.add(const Duration(hours: 2)),
    );

    expect(result.fullness, 0);
    expect(result.happiness, 0);
  });
}
