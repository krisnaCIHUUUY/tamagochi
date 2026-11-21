import 'package:flutter_test/flutter_test.dart';
import 'package:tamagochi/features/pet/domain/simulation/simulate.dart';

import '../../../../helpers/pet_state_fixtures.dart';

void main() {
  // fixtureNow = 2026-01-05 10.00; awakePet() = tahap Anak.
  final from = fixtureNow;

  test('same input same output (7 days)', () {
    final to = from.add(const Duration(days: 7));

    final first = simulate(awakePet(), from: from, to: to);
    final second = simulate(awakePet(), from: from, to: to);

    expect(first, second);
  });

  test('30 days offline finishes in < 50 ms', () {
    final to = from.add(const Duration(days: 30));

    final stopwatch = Stopwatch()..start();
    simulate(awakePet(), from: from, to: to, offline: true);
    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(50));
  });
}
