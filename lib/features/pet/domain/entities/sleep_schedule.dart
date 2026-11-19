import 'package:freezed_annotation/freezed_annotation.dart';

import '../rules/game_rules.dart';

part 'sleep_schedule.freezed.dart';
part 'sleep_schedule.g.dart';

/// Jam tidur pet dalam jam lokal; boleh melewati tengah malam (21 → 7).
@freezed
abstract class SleepSchedule with _$SleepSchedule {
  const factory SleepSchedule({
    @Default(GameRules.sleepStartHour) int startHour,
    @Default(GameRules.sleepEndHour) int endHour,
  }) = _SleepSchedule;

  factory SleepSchedule.fromJson(Map<String, Object?> json) =>
      _$SleepScheduleFromJson(json);
}
