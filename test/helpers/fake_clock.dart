import 'package:tamagochi/core/clock/clock.dart';

/// Jam untuk test: waktu hanya bergerak saat [advance] atau [set] dipanggil.
class FakeClock implements Clock {
  FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration duration) => _now = _now.add(duration);

  void set(DateTime time) => _now = time;
}
