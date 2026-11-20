import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/life_stage.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun); awakePet().lastCareAt = fixtureNow.
  DateTime after(Duration d) => fixtureNow.add(d);
  const minute = Duration(minutes: 1);
  const hour = Duration(hours: 1);

  group('moody', () {
    // offline: meter tertahan di 10 sehingga pet tidak ikut sakit.
    PetState lowPet() => awakePet(fullness: 20, happiness: 20);

    test('both <= 20 for 6h makes moody', () {
      final result = simulate(
        lowPet(),
        from: fixtureNow,
        to: after(hour * 6),
        offline: true,
      );

      expect(result.isMoody, true);
    });

    test('both <= 20 for 5h59m does not', () {
      final result = simulate(
        lowPet(),
        from: fixtureNow,
        to: after(hour * 6 - minute),
        offline: true,
      );

      expect(result.isMoody, false);
    });

    test('lowBothFor resets when a meter is above 20', () {
      final result = simulate(
        awakePet(fullness: 50, happiness: 15).copyWith(lowBothFor: hour * 3),
        from: fixtureNow,
        to: after(minute),
      );

      expect(result.lowBothFor, Duration.zero);
    });

    test('D7: lowBothFor pauses while asleep', () {
      final night = DateTime(2026, 1, 5, 22);
      final pet = awakePet(
        fullness: 15,
        happiness: 15,
      ).copyWith(lastUpdated: night, lowBothFor: hour);

      final result = simulate(pet, from: night, to: DateTime(2026, 1, 6, 6));

      expect(result.lowBothFor, hour);
      expect(result.isMoody, false);
    });
  });

  group('vacation', () {
    test('48h without care -> onVacation, 47h59m not yet', () {
      final pet = awakePet();

      final before = simulate(
        pet,
        from: fixtureNow,
        to: after(hour * 48 - minute),
        offline: true,
      );
      final at = simulate(
        pet,
        from: fixtureNow,
        to: after(hour * 48),
        offline: true,
      );

      expect(before.onVacation, false);
      expect(at.onVacation, true);
    });

    test('vacation freezes meters, poop and sickness (K10)', () {
      final pet = awakePet().copyWith(
        onVacation: true,
        poop: 3,
        poopDueAt: [after(minute)],
      );
      final to = after(hour * 3);

      final result = simulate(pet, from: fixtureNow, to: to);

      expect(result.fullness, 80);
      expect(result.happiness, 80);
      expect(result.poop, 3);
      expect(result.poopDueAt, hasLength(1));
      expect(result.isSick, false);
      expect(result.lastUpdated, to);
    });

    test('stage still advances on vacation (K10)', () {
      final egg = PetState.newEgg(fixtureNow).copyWith(onVacation: true);

      final result = simulate(egg, from: fixtureNow, to: after(minute * 5));

      expect(result.stage, LifeStage.baby);
    });
  });

  group('offline floor (K1)', () {
    test('offline never drops fullness/happiness below 10', () {
      final result = simulate(
        awakePet(),
        from: fixtureNow,
        to: after(const Duration(days: 3)),
        offline: true,
      );

      expect(result.fullness, 10);
      expect(result.happiness, 10);
    });

    test('offline keeps a meter already below 10 as is', () {
      final result = simulate(
        awakePet(fullness: 5),
        from: fixtureNow,
        to: after(hour * 2),
        offline: true,
      );

      expect(result.fullness, 5);
      expect(result.happiness, closeTo(68, 0.001));
    });

    test('online can reach 0', () {
      final result = simulate(
        awakePet(),
        from: fixtureNow,
        to: after(hour * 12),
      );

      expect(result.fullness, 0);
    });

    test('PRD P0-6: 30 days offline -> on vacation, meters >= 10', () {
      final result = simulate(
        awakePet(),
        from: fixtureNow,
        to: after(const Duration(days: 30)),
        offline: true,
      );

      expect(result.onVacation, true);
      expect(result.fullness, greaterThanOrEqualTo(10));
      expect(result.happiness, greaterThanOrEqualTo(10));
    });
  });
}
