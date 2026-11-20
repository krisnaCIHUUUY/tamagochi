import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/entities/pet_state.dart';
import 'package:tamagochi/features/pet/domain/entities/sleep_schedule.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  DateTime at(int hour, [int minute = 0]) => DateTime(2026, 1, 1, hour, minute);

  group('default schedule 21 -> 7 (crosses midnight)', () {
    const schedule = SleepSchedule();

    test('21:00 is asleep', () => expect(schedule.isAsleepAt(at(21)), true));
    test(
      '23:59 is asleep',
      () => expect(schedule.isAsleepAt(at(23, 59)), true),
    );
    test('06:59 is asleep', () => expect(schedule.isAsleepAt(at(6, 59)), true));
    test('07:00 is awake', () => expect(schedule.isAsleepAt(at(7)), false));
    test(
      '20:59 is awake',
      () => expect(schedule.isAsleepAt(at(20, 59)), false),
    );
  });

  group('schedule 13 -> 15 (same day)', () {
    const schedule = SleepSchedule(startHour: 13, endHour: 15);

    test('14:00 is asleep', () => expect(schedule.isAsleepAt(at(14)), true));
    test('15:00 is awake', () => expect(schedule.isAsleepAt(at(15)), false));
  });

  test('isAsleepAt uses local time', () {
    expect(const SleepSchedule().isAsleepAt(at(22).toUtc()), true);
  });

  test('PetState.isAsleepAt follows its sleepSchedule', () {
    expect(awakePet().isAsleepAt(at(22)), true);
    expect(awakePet().isAsleepAt(at(10)), false);
  });
}
