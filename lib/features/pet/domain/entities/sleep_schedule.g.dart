// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SleepSchedule _$SleepScheduleFromJson(Map<String, dynamic> json) =>
    _SleepSchedule(
      startHour:
          (json['startHour'] as num?)?.toInt() ?? GameRules.sleepStartHour,
      endHour: (json['endHour'] as num?)?.toInt() ?? GameRules.sleepEndHour,
    );

Map<String, dynamic> _$SleepScheduleToJson(_SleepSchedule instance) =>
    <String, dynamic>{
      'startHour': instance.startHour,
      'endHour': instance.endHour,
    };
