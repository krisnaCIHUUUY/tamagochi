import 'package:freezed_annotation/freezed_annotation.dart';

import '../rules/game_rules.dart';

part 'sleep_schedule.freezed.dart';
part 'sleep_schedule.g.dart';

/// Jam tidur pet dalam jam lokal; boleh melewati tengah malam (21 → 7).
@freezed
abstract class SleepSchedule with _$SleepSchedule {
  // Konstruktor privat kosong: syarat freezed agar kelas boleh punya method.
  const SleepSchedule._();

  const factory SleepSchedule({
    @Default(GameRules.sleepStartHour) int startHour,
    @Default(GameRules.sleepEndHour) int endHour,
  }) = _SleepSchedule;

  /// Jam tidur dihitung dari jam lokal ponsel, walau [t] dalam UTC.
  bool isAsleepAt(DateTime t) {
    final hour = t.toLocal().hour;
    return startHour <= endHour
        ? hour >= startHour && hour < endHour
        : hour >= startHour || hour < endHour;
  }

  factory SleepSchedule.fromJson(Map<String, Object?> json) =>
      _$SleepScheduleFromJson(json);
}
