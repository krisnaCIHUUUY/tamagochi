import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/care_action.dart';
import 'package:tamagochi/features/pet/domain/entities/care_style.dart';
import 'package:tamagochi/features/pet/domain/entities/life_stage.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_character.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/rules/game_rules.dart';
import 'package:tamagochi/features/pet/domain/simulation/apply_action.dart';
import 'package:tamagochi/features/pet/domain/simulation/evolution.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun).
  final now = fixtureNow;
  const minute = Duration(minutes: 1);

  group('chooseCharacter', () {
    test('plays 12, others 5 -> atletis', () {
      const style = CareStyle(plays: 12, snacks: 5, timelyCleans: 5);
      expect(chooseCharacter(style), PetCharacter.atletis);
    });

    test('snacks dominant -> gembul', () {
      const style = CareStyle(plays: 2, snacks: 8, timelyCleans: 2);
      expect(chooseCharacter(style), PetCharacter.gembul);
    });

    test('timelyCleans dominant -> rapi', () {
      const style = CareStyle(plays: 2, snacks: 2, timelyCleans: 8);
      expect(chooseCharacter(style), PetCharacter.rapi);
    });

    test('neglected 600 minutes (= 10 points) vs 5 -> mandiri', () {
      const style = CareStyle(plays: 5, neglectedFor: Duration(minutes: 600));
      expect(chooseCharacter(style), PetCharacter.mandiri);
    });

    test('top 11 vs second 10 (< 20% lead) -> seimbang', () {
      const style = CareStyle(plays: 11, snacks: 10);
      expect(chooseCharacter(style), PetCharacter.seimbang);
    });

    test('D10: exactly 20% lead (12 vs 10) -> seimbang', () {
      const style = CareStyle(plays: 12, snacks: 10);
      expect(chooseCharacter(style), PetCharacter.seimbang);
    });

    test('all zero -> seimbang', () {
      expect(chooseCharacter(const CareStyle()), PetCharacter.seimbang);
    });

    test('neglect under 60 minutes is 0 points', () {
      const style = CareStyle(neglectedFor: Duration(minutes: 59));
      expect(chooseCharacter(style), PetCharacter.seimbang);
    });
  });

  group('evolution in simulate', () {
    /// Pet yang tinggal 1 menit lagi menyelesaikan [stage].
    PetState aboutToGrow(LifeStage stage, Duration stageDuration) =>
        awakePet(stage: stage)
            .copyWith(stageStartedAt: now.subtract(stageDuration).add(minute));

    test('end of child: character chosen, careStyle reset, reveal', () {
      final pet = aboutToGrow(
        LifeStage.child,
        GameRules.childDuration,
      ).copyWith(careStyle: const CareStyle(plays: 10));

      final result = simulate(pet, from: now, to: now.add(minute));

      expect(result.stage, LifeStage.teen);
      expect(result.character, PetCharacter.atletis);
      expect(result.careStyle, const CareStyle());
      expect(result.pendingReveal, true);
    });

    test('end of teen: second evolution may change character', () {
      final pet = aboutToGrow(LifeStage.teen, GameRules.teenDuration).copyWith(
        character: PetCharacter.atletis,
        careStyle: const CareStyle(snacks: 10),
      );

      final result = simulate(pet, from: now, to: now.add(minute));

      expect(result.stage, LifeStage.adult);
      expect(result.character, PetCharacter.gembul);
      expect(result.pendingReveal, true);
    });

    test('baby -> child is not an evolution', () {
      final pet = aboutToGrow(LifeStage.baby, GameRules.babyDuration);

      final result = simulate(pet, from: now, to: now.add(minute));

      expect(result.stage, LifeStage.child);
      expect(result.character, isNull);
      expect(result.pendingReveal, false);
    });
  });

  group('PRD P0-5: all five adults reachable', () {
    /// Membesarkan telur sampai dewasa: tiap jam simulasi, lalu jalankan
    /// [routine] bila pet bangun.
    PetState raise(List<CareAction> Function(PetState pet) routine) {
      var pet = PetState.newEgg(now);
      var t = now;
      while (pet.stage != LifeStage.adult) {
        final next = t.add(const Duration(hours: 1));
        pet = simulate(pet, from: t, to: next, offline: true);
        t = next;
        if (pet.isAsleepAt(t)) continue;
        for (final action in routine(pet)) {
          pet = applyAction(pet, action, t).state;
        }
      }
      return pet;
    }

    List<CareAction> cleanIfDirty(PetState pet) => [
      if (pet.poop > 0) CareAction.clean,
    ];

    test('often played with -> Si Atletis', () {
      final adult = raise(
        (pet) => [
          CareAction.play,
          CareAction.play,
          if (pet.fullness < 50) CareAction.feed,
          ...cleanIfDirty(pet),
        ],
      );
      expect(adult.character, PetCharacter.atletis);
    });

    test('often given snacks -> Si Gembul', () {
      final adult = raise(
        (pet) => [CareAction.snack, CareAction.snack, ...cleanIfDirty(pet)],
      );
      expect(adult.character, PetCharacter.gembul);
    });

    test('always clean -> Si Rapi', () {
      final adult = raise(
        (pet) => [
          CareAction.feed,
          if (pet.happiness < 30) CareAction.play,
          ...cleanIfDirty(pet),
        ],
      );
      expect(adult.character, PetCharacter.rapi);
    });

    test('often left alone -> Si Mandiri', () {
      final adult = raise((pet) => []);
      expect(adult.character, PetCharacter.mandiri);
    });

    test('nothing dominant -> Si Seimbang', () {
      final adult = raise(
        (pet) => [
          CareAction.play,
          CareAction.snack,
          if (pet.fullness < 50) CareAction.feed,
          ...cleanIfDirty(pet),
        ],
      );
      expect(adult.character, PetCharacter.seimbang);
    });
  });
}
