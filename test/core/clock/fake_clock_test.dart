import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_clock.dart';

void main() {
  test('advance moves now forward', () {
    final clock = FakeClock(DateTime(2026, 1, 1, 8))
      ..advance(const Duration(hours: 2));

    expect(clock.now(), DateTime(2026, 1, 1, 10));
  });
}
