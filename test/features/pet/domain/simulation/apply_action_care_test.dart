import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/care_action.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/apply_action.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun).
  final now = fixtureNow;
  final night = DateTime(2026, 1, 5, 22);

  void expectRejected(PetState pet, CareAction action, DateTime at) {
    final result = applyAction(pet, action, at);
    expect(result.accepted, false);
    expect(result.state, same(pet));
  }

  /// State yang membuat [action] diterima (dan dibutuhkan) bila tidak liburan.
  PetState acceptingPet(CareAction action) =>
      awakePet(fullness: 40, happiness: 40).copyWith(
        poop: 1,
        isSick: action == CareAction.medicine,
        lastCareAt: now.subtract(const Duration(hours: 5)),
      );

  group('clean', () {
    test('sets poop 0 and clears firstPoopAt', () {
      final pet = awakePet().copyWith(
        poop: 3,
        firstPoopAt: now.subtract(const Duration(minutes: 30)),
      );

      final (:state, :accepted) = applyAction(pet, CareAction.clean, now);

      expect(accepted, true);
      expect(state.poop, 0);
      expect(state.firstPoopAt, isNull);
    });

    test('rejected when poop is 0', () {
      expectRejected(awakePet(), CareAction.clean, now);
    });
  });

  group('medicine', () {
    test('first dose keeps sick, second cures and resets doses', () {
      final sick = awakePet().copyWith(isSick: true);

      final first = applyAction(sick, CareAction.medicine, now).state;
      final second = applyAction(first, CareAction.medicine, now).state;

      expect(first.isSick, true);
      expect(first.medicineDoses, 1);
      expect(second.isSick, false);
      expect(second.medicineDoses, 0);
    });

    test('rejected when not sick', () {
      expectRejected(awakePet(), CareAction.medicine, now);
    });
  });

  group('lights', () {
    test('toggles on -> off -> on', () {
      final off = applyAction(awakePet(), CareAction.lights, now);
      final on = applyAction(off.state, CareAction.lights, now);

      expect(off.accepted, true);
      expect(off.state.lightsOn, false);
      expect(on.state.lightsOn, true);
    });

    test('is never rejected, even asleep and sick', () {
      final pet = awakePet().copyWith(lastUpdated: night, isSick: true);

      expect(applyAction(pet, CareAction.lights, night).accepted, true);
    });

    test('turning off at night clears lightsOnAllSleep (K12)', () {
      final pet = awakePet().copyWith(
        lastUpdated: night,
        lightsOnAllSleep: true,
      );

      final result = applyAction(pet, CareAction.lights, night);

      expect(result.state.lightsOn, false);
      expect(result.state.lightsOnAllSleep, false);
    });
  });

  group('bond (K7)', () {
    double bondAfter(PetState pet, CareAction action, [DateTime? at]) =>
        applyAction(pet, action, at ?? now).state.bond;

    test('+1 for needed feed (fullness 40), +0 for unneeded (60)', () {
      expect(bondAfter(awakePet(fullness: 40), CareAction.feed), 1);
      expect(bondAfter(awakePet(fullness: 60), CareAction.feed), 0);
    });

    test('+1 for needed play (happiness 40), +0 for unneeded (60)', () {
      expect(bondAfter(awakePet(happiness: 40), CareAction.play), 1);
      expect(bondAfter(awakePet(happiness: 60), CareAction.play), 0);
    });

    test('+1 for clean and medicine', () {
      expect(bondAfter(acceptingPet(CareAction.clean), CareAction.clean), 1);
      expect(
        bondAfter(acceptingPet(CareAction.medicine), CareAction.medicine),
        1,
      );
    });

    test('+1 for lights off at night, +0 for lights while awake', () {
      final asleep = awakePet().copyWith(lastUpdated: night);

      expect(bondAfter(asleep, CareAction.lights, night), 1);
      expect(bondAfter(awakePet(), CareAction.lights), 0);
    });

    test('+0 for snack', () {
      expect(bondAfter(awakePet(fullness: 10), CareAction.snack), 0);
    });
  });

  test('every accepted action sets lastCareAt to now', () {
    for (final action in CareAction.values) {
      final result = applyAction(acceptingPet(action), action, now);

      expect(result.accepted, true, reason: '$action');
      expect(result.state.lastCareAt, now, reason: '$action');
    }
  });

  test('any action rejected while onVacation', () {
    for (final action in CareAction.values) {
      expectRejected(
        acceptingPet(action).copyWith(onVacation: true),
        action,
        now,
      );
    }
  });

  group('pickUp', () {
    test('comes home fresh: meters 50, clean, healthy, lastCareAt now', () {
      final pet = awakePet(fullness: 10, happiness: 10).copyWith(
        onVacation: true,
        poop: 4,
        poopDueAt: [now.add(const Duration(hours: 1))],
        firstPoopAt: now.subtract(const Duration(days: 2)),
        isSick: true,
        medicineDoses: 1,
        isMoody: true,
        lastCareAt: now.subtract(const Duration(days: 3)),
      );

      final home = pickUp(pet, now);

      expect(home.fullness, 50);
      expect(home.happiness, 50);
      expect(home.poop, 0);
      expect(home.poopDueAt, isEmpty);
      expect(home.firstPoopAt, isNull);
      expect(home.isSick, false);
      expect(home.medicineDoses, 0);
      expect(home.isMoody, false);
      expect(home.onVacation, false);
      expect(home.lastCareAt, now);
    });

    test('does nothing when not on vacation', () {
      final pet = awakePet(fullness: 90);

      expect(pickUp(pet, now), same(pet));
    });
  });
}
