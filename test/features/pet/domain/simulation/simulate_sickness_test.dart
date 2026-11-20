import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00 (jam bangun). Semua test online (offline: false).
  DateTime after(Duration d) => fixtureNow.add(d);
  const minutes = Duration(minutes: 1);

  test('zero fullness for 61 min makes sick', () {
    final result = simulate(
      awakePet(fullness: 0),
      from: fixtureNow,
      to: after(minutes * 61),
    );

    expect(result.isSick, true);
  });

  test('zero fullness for 59 min does not make sick', () {
    final result = simulate(
      awakePet(fullness: 0),
      from: fixtureNow,
      to: after(minutes * 59),
    );

    expect(result.isSick, false);
    expect(result.zeroNeedFor, minutes * 59);
  });

  test('zero happiness for 61 min makes sick', () {
    final result = simulate(
      awakePet(happiness: 0),
      from: fixtureNow,
      to: after(minutes * 61),
    );

    expect(result.isSick, true);
  });

  test('3 poop for 2h makes sick', () {
    final result = simulate(
      awakePet().copyWith(poop: 3),
      from: fixtureNow,
      to: after(const Duration(hours: 2)),
    );

    expect(result.isSick, true);
  });

  test('2 poop for 10h does not make sick', () {
    final result = simulate(
      awakePet().copyWith(poop: 2),
      from: fixtureNow,
      to: after(const Duration(hours: 10)),
    );

    expect(result.isSick, false);
  });

  test('zeroNeedFor resets when meter is above 0', () {
    final result = simulate(
      awakePet(fullness: 50).copyWith(zeroNeedFor: minutes * 30),
      from: fixtureNow,
      to: after(minutes),
    );

    expect(result.zeroNeedFor, Duration.zero);
  });

  test('D5: sickness timers pause while asleep', () {
    final night = DateTime(2026, 1, 5, 22);
    final pet = awakePet(fullness: 0).copyWith(
      lastUpdated: night,
      poop: 3,
      zeroNeedFor: minutes * 30,
      heavyPoopFor: minutes * 30,
    );

    final result = simulate(pet, from: night, to: DateTime(2026, 1, 6, 6));

    expect(result.isSick, false);
    expect(result.zeroNeedFor, minutes * 30);
    expect(result.heavyPoopFor, minutes * 30);
  });

  test('D6: becoming sick resets timers and they stay 0 while sick', () {
    final sick = simulate(
      awakePet(fullness: 0).copyWith(poop: 3),
      from: fixtureNow,
      to: after(minutes * 61),
    );
    final later = simulate(
      sick,
      from: sick.lastUpdated,
      to: sick.lastUpdated.add(const Duration(hours: 2)),
    );

    expect(sick.isSick, true);
    expect(sick.zeroNeedFor, Duration.zero);
    expect(sick.heavyPoopFor, Duration.zero);
    expect(later.zeroNeedFor, Duration.zero);
    expect(later.heavyPoopFor, Duration.zero);
  });
}
