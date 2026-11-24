import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/care_action.dart';
import 'package:tamagochi/features/pet/domain/entities/mood.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/mood_resolver.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun).
  final now = fixtureNow;
  final night = DateTime(2026, 1, 5, 22);

  group('resolveMood (K11)', () {
    Mood moodOf(PetState pet, [DateTime? at]) => resolveMood(pet, at ?? now);

    test('asleep beats sick', () {
      expect(moodOf(awakePet().copyWith(isSick: true), night), Mood.asleep);
    });

    test('sick beats moody', () {
      final pet = awakePet().copyWith(isSick: true, isMoody: true);
      expect(moodOf(pet), Mood.sick);
    });

    test('moody beats hungry', () {
      final pet = awakePet(fullness: 20).copyWith(isMoody: true);
      expect(moodOf(pet), Mood.moody);
    });

    test('fullness 30 -> hungry, 31 -> not', () {
      expect(moodOf(awakePet(fullness: 30, happiness: 50)), Mood.hungry);
      expect(moodOf(awakePet(fullness: 31, happiness: 50)), Mood.neutral);
    });

    test('hungry beats happy', () {
      expect(moodOf(awakePet(fullness: 30, happiness: 90)), Mood.hungry);
    });

    test('happiness 70 -> happy, 69 -> neutral', () {
      expect(moodOf(awakePet(happiness: 70)), Mood.happy);
      expect(moodOf(awakePet(happiness: 69)), Mood.neutral);
    });

    test('egg -> neutral, day and night', () {
      final egg = PetState.newEgg(now);
      expect(moodOf(egg), Mood.neutral);
      expect(moodOf(egg, night), Mood.neutral);
    });
  });

  group('neededActions (D11)', () {
    test('sick -> medicine first; feed is not suggested while sick', () {
      final pet = awakePet(fullness: 40).copyWith(isSick: true, poop: 1);
      expect(neededActions(pet, now), [CareAction.medicine, CareAction.clean]);
    });

    test('poop and fullness < 50 -> [clean, feed]', () {
      final pet = awakePet(fullness: 40).copyWith(poop: 1);
      expect(neededActions(pet, now), [CareAction.clean, CareAction.feed]);
    });

    test('at most 2 even when play is also needed', () {
      final pet = awakePet(fullness: 40, happiness: 40).copyWith(poop: 1);
      expect(neededActions(pet, now), hasLength(2));
    });

    test('happiness < 50 -> [play]', () {
      expect(neededActions(awakePet(happiness: 40), now), [CareAction.play]);
    });

    test('asleep with lights on -> [lights]', () {
      expect(neededActions(awakePet(), night), [CareAction.lights]);
    });

    test('healthy and happy -> []', () {
      expect(neededActions(awakePet(), now), isEmpty);
    });

    test('onVacation -> []', () {
      final pet = awakePet(fullness: 10)
          .copyWith(onVacation: true, isSick: true, poop: 3);
      expect(neededActions(pet, now), isEmpty);
    });
  });
}
