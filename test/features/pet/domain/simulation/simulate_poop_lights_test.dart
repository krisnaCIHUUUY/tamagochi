import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun).
  PetState petAt(DateTime t) => awakePet().copyWith(lastUpdated: t);

  final evening = DateTime(2026, 1, 5, 20);
  final bedtime = DateTime(2026, 1, 5, 21);
  final wake = DateTime(2026, 1, 6, 7);
  const minute = Duration(minutes: 1);

  group('poop', () {
    test('appears 3h after feed', () {
      final due = fixtureNow.add(const Duration(hours: 3));
      final pet = petAt(fixtureNow).copyWith(poopDueAt: [due]);

      final result = simulate(pet, from: fixtureNow, to: due.add(minute));

      expect(result.poop, 1);
      expect(result.firstPoopAt, due);
      expect(result.poopDueAt, isEmpty);
    });

    test('due during sleep appears at wake', () {
      final pet = petAt(evening)
          .copyWith(poopDueAt: [DateTime(2026, 1, 5, 23)]);

      final stillAsleep = simulate(
        pet,
        from: evening,
        to: DateTime(2026, 1, 6, 6),
      );
      final awake = simulate(pet, from: evening, to: wake.add(minute));

      expect(stillAsleep.poop, 0);
      expect(awake.poop, 1);
      expect(awake.firstPoopAt, wake);
    });

    test('caps at 4 and keeps the first poop time', () {
      final firstPoop = fixtureNow.subtract(const Duration(hours: 1));
      final pet = petAt(fixtureNow).copyWith(
        poop: 3,
        firstPoopAt: firstPoop,
        poopDueAt: [fixtureNow.add(minute), fixtureNow.add(minute * 2)],
      );

      final result = simulate(
        pet,
        from: fixtureNow,
        to: fixtureNow.add(const Duration(hours: 1)),
      );

      expect(result.poop, 4);
      expect(result.firstPoopAt, firstPoop);
      expect(result.poopDueAt, isEmpty);
    });
  });

  group('lights', () {
    // 21.00 → 07.01: hanya menit 07.00–07.01 yang bangun (senang −0,1).
    test('left on all night: happiness -10 at wake', () {
      final pet = petAt(bedtime).copyWith(lightsOn: true);

      final result = simulate(pet, from: bedtime, to: wake.add(minute));

      expect(result.happiness, closeTo(69.9, 0.001));
      expect(result.lightsOn, true);
      expect(result.lightsOnAllSleep, false);
    });

    test('off at night: no penalty, lights back on at wake', () {
      final pet = petAt(bedtime).copyWith(lightsOn: false);

      final result = simulate(pet, from: bedtime, to: wake.add(minute));

      expect(result.happiness, closeTo(79.9, 0.001));
      expect(result.lightsOn, true);
      expect(result.lightsOnAllSleep, false);
    });
  });
}
