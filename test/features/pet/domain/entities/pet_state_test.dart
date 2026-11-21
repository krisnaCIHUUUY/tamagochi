import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/care_style.dart';
import 'package:tamagochi/features/pet/domain/entities/life_stage.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_character.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/entities/sleep_schedule.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  final t = DateTime(2026, 1, 5, 10);

  test('newEgg has defaults', () {
    final egg = PetState.newEgg(t);

    expect(egg.stage, LifeStage.egg);
    expect(egg.fullness, 80);
    expect(egg.happiness, 80);
    expect(egg.weight, 100);
    expect(egg.bornAt, t);
    expect(egg.lastUpdated, t);
    expect(egg.lastCareAt, t);
    expect(egg.stageStartedAt, t);
  });

  test('json round-trip keeps every field', () {
    final full = awakePet().copyWith(
      character: PetCharacter.gembul,
      poop: 2,
      poopDueAt: [t.add(const Duration(hours: 3))],
      firstPoopAt: t.subtract(const Duration(minutes: 30)),
      isSick: true,
      medicineDoses: 1,
      bond: 12,
      lightsOn: false,
      lightsOnAllSleep: true,
      isMoody: true,
      onVacation: true,
      zeroNeedFor: const Duration(minutes: 5),
      heavyPoopFor: const Duration(minutes: 7),
      lowBothFor: const Duration(hours: 1),
      recentSnacks: [t, t.add(const Duration(minutes: 1))],
      careStyle: const CareStyle(
        plays: 1,
        snacks: 2,
        timelyCleans: 3,
        neglectMinutes: 4,
      ),
      sleepSchedule: const SleepSchedule(startHour: 22, endHour: 6),
      pendingReveal: true,
    );

    expect(PetState.fromJson(full.toJson()), full);
  });

  test('ageYears counts whole real days since birth', () {
    final egg = PetState.newEgg(t);

    expect(egg.ageYears(t.add(const Duration(days: 3, hours: 1))), 3);
  });
}
