import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/care_action.dart';
import 'package:tamagochi/features/pet/domain/entities/life_stage.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/simulation/apply_action.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun). awakePet() = tahap Anak.
  final now = fixtureNow;
  const minute = Duration(minutes: 1);
  const hour = Duration(hours: 1);

  group('stages', () {
    final egg = PetState.newEgg(now);
    LifeStage stageAt(Duration age) =>
        simulate(egg, from: now, to: now.add(age), offline: true).stage;

    // Batas kumulatif: telur 5 mnt, bayi 1 hari, anak 3 hari, remaja 4 hari.
    const toBaby = Duration(minutes: 5);
    const toChild = Duration(days: 1, minutes: 5);
    const toTeen = Duration(days: 4, minutes: 5);
    const toAdult = Duration(days: 8, minutes: 5);

    test('egg -> baby at 5 minutes', () {
      expect(stageAt(toBaby - minute), LifeStage.egg);
      expect(stageAt(toBaby), LifeStage.baby);
    });

    test('baby -> child after 1 day', () {
      expect(stageAt(toChild - minute), LifeStage.baby);
      expect(stageAt(toChild), LifeStage.child);
    });

    test('child -> teen after 3 days', () {
      expect(stageAt(toTeen - minute), LifeStage.child);
      expect(stageAt(toTeen), LifeStage.teen);
    });

    test('teen -> adult after 4 days, then stays adult', () {
      expect(stageAt(toAdult - minute), LifeStage.teen);
      expect(stageAt(toAdult), LifeStage.adult);
      expect(stageAt(toAdult + const Duration(days: 5)), LifeStage.adult);
    });

    test('stageStartedAt moves exactly by each stage duration', () {
      final teen = simulate(egg, from: now, to: now.add(toTeen), offline: true);

      expect(teen.stageStartedAt, now.add(toTeen));
    });
  });

  group('care style from actions', () {
    test('not counted before child (play while baby)', () {
      final baby = awakePet(stage: LifeStage.baby, happiness: 50);

      final result = applyAction(baby, CareAction.play, now).state;

      expect(result.careStyle.plays, 0);
    });

    test('child: play, snack, feed count plays, snacks, balancedActions', () {
      var pet = awakePet(fullness: 50, happiness: 50);
      for (final action in [
        CareAction.play,
        CareAction.snack,
        CareAction.feed,
      ]) {
        pet = applyAction(pet, action, now).state;
      }

      expect(pet.careStyle.plays, 1);
      expect(pet.careStyle.snacks, 1);
      expect(pet.careStyle.balancedActions, 1);
    });

    test('clean within 1h of first poop counts timelyCleans (K6)', () {
      PetState dirty(Duration ago) =>
          awakePet().copyWith(poop: 1, firstPoopAt: now.subtract(ago));

      final onTime = applyAction(dirty(hour), CareAction.clean, now).state;
      final late = applyAction(
        dirty(hour + minute),
        CareAction.clean,
        now,
      ).state;

      expect(onTime.careStyle.timelyCleans, 1);
      expect(late.careStyle.timelyCleans, 0);
    });
  });

  group('neglectMinutes (K6)', () {
    int neglectAfter(PetState pet, DateTime from, Duration span) => simulate(
      pet.copyWith(lastUpdated: from),
      from: from,
      to: from.add(span),
    ).careStyle.neglectMinutes;

    test('counts awake minutes with a meter <= 20', () {
      expect(neglectAfter(awakePet(fullness: 20), now, hour * 2), 120);
    });

    test('does not count while both meters are above 20', () {
      expect(neglectAfter(awakePet(), now, hour), 0);
    });

    test('does not count asleep minutes', () {
      final night = DateTime(2026, 1, 5, 22);
      expect(neglectAfter(awakePet(fullness: 10), night, hour * 8), 0);
    });

    test('counts every vacation minute, even at night', () {
      final night = DateTime(2026, 1, 5, 22);
      final away = awakePet().copyWith(onVacation: true);
      expect(neglectAfter(away, night, hour), 60);
    });

    test('not counted before child', () {
      final baby = awakePet(stage: LifeStage.baby, fullness: 10);
      expect(neglectAfter(baby, now, hour), 0);
    });
  });
}
