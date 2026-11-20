import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/care_action.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/apply_action.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun). State dianggap sudah disimulasikan ke `now`.
  final now = fixtureNow;
  const minute = Duration(minutes: 1);

  void expectRejected(PetState pet, CareAction action, DateTime at) {
    final result = applyAction(pet, action, at);
    expect(result.accepted, false);
    expect(result.state, same(pet));
  }

  group('feed', () {
    test('+30 fullness, +5 weight, poop at now+3h, lastCareAt now', () {
      final pet = awakePet(fullness: 40)
          .copyWith(lastCareAt: now.subtract(const Duration(hours: 5)));

      final (:state, :accepted) = applyAction(pet, CareAction.feed, now);

      expect(accepted, true);
      expect(state.fullness, 70);
      expect(state.weight, 105);
      expect(state.poopDueAt, [now.add(const Duration(hours: 3))]);
      expect(state.lastCareAt, now);
    });

    test('clears moody and its timer', () {
      final pet = awakePet(
        fullness: 15,
        happiness: 15,
      ).copyWith(isMoody: true, lowBothFor: const Duration(hours: 6));

      final (:state, :accepted) = applyAction(pet, CareAction.feed, now);

      expect(accepted, true);
      expect(state.isMoody, false);
      expect(state.lowBothFor, Duration.zero);
    });

    test('clamps at 100', () {
      final result = applyAction(awakePet(fullness: 90), CareAction.feed, now);

      expect(result.state.fullness, 100);
    });

    test('rejected when fullness is 100', () {
      expectRejected(awakePet(fullness: 100), CareAction.feed, now);
    });

    test('rejected when sick', () {
      expectRejected(awakePet().copyWith(isSick: true), CareAction.feed, now);
    });
  });

  group('snack', () {
    test('+15 happiness, +10 fullness, +10 weight', () {
      final (:state, :accepted) = applyAction(
        awakePet(fullness: 50, happiness: 50),
        CareAction.snack,
        now,
      );

      expect(accepted, true);
      expect(state.happiness, 65);
      expect(state.fullness, 60);
      expect(state.weight, 110);
      expect(state.recentSnacks, [now]);
      expect(state.lastCareAt, now);
    });

    PetState snacks(int count) {
      var pet = awakePet(
        fullness: 10,
        happiness: 10,
      ).copyWith(heavyPoopFor: const Duration(hours: 1));
      for (var i = 0; i < count; i++) {
        pet = applyAction(pet, CareAction.snack, now.add(minute * i)).state;
      }
      return pet;
    }

    test('5th snack within an hour does not make sick', () {
      expect(snacks(5).isSick, false);
    });

    test('6th snack within an hour makes sick and resets timers (D6)', () {
      final pet = snacks(6);

      expect(pet.isSick, true);
      expect(pet.heavyPoopFor, Duration.zero);
    });

    test('snacks older than an hour are forgotten', () {
      final old = List.generate(
        5,
        (i) => now.subtract(const Duration(hours: 2)).add(minute * i),
      );
      final pet = awakePet().copyWith(recentSnacks: old);

      final state = applyAction(pet, CareAction.snack, now).state;

      expect(state.isSick, false);
      expect(state.recentSnacks, [now]);
    });
  });

  group('play', () {
    test('+20 happiness, -5 weight', () {
      final (:state, :accepted) = applyAction(
        awakePet(happiness: 50),
        CareAction.play,
        now,
      );

      expect(accepted, true);
      expect(state.happiness, 70);
      expect(state.weight, 95);
      expect(state.lastCareAt, now);
    });

    test('rejected when asleep', () {
      final night = DateTime(2026, 1, 5, 22);
      expectRejected(
        awakePet().copyWith(lastUpdated: night),
        CareAction.play,
        night,
      );
    });

    test('rejected when sick', () {
      expectRejected(awakePet().copyWith(isSick: true), CareAction.play, now);
    });

    test('rejected when moody', () {
      expectRejected(awakePet().copyWith(isMoody: true), CareAction.play, now);
    });

    test('weight never below 10', () {
      final result = applyAction(
        awakePet().copyWith(weight: 12),
        CareAction.play,
        now,
      );

      expect(result.state.weight, 10);
    });
  });
}
