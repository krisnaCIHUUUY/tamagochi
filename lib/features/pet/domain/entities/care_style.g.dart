// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareStyle _$CareStyleFromJson(Map<String, dynamic> json) => _CareStyle(
  plays: (json['plays'] as num?)?.toInt() ?? 0,
  snacks: (json['snacks'] as num?)?.toInt() ?? 0,
  timelyCleans: (json['timelyCleans'] as num?)?.toInt() ?? 0,
  neglectedFor: json['neglectedFor'] == null
      ? Duration.zero
      : Duration(microseconds: (json['neglectedFor'] as num).toInt()),
);

Map<String, dynamic> _$CareStyleToJson(_CareStyle instance) =>
    <String, dynamic>{
      'plays': instance.plays,
      'snacks': instance.snacks,
      'timelyCleans': instance.timelyCleans,
      'neglectedFor': instance.neglectedFor.inMicroseconds,
    };
