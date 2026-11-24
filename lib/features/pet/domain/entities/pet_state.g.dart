// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetState _$PetStateFromJson(Map<String, dynamic> json) => _PetState(
  bornAt: const UtcDateTimeConverter().fromJson(json['bornAt'] as String),
  lastUpdated: const UtcDateTimeConverter().fromJson(
    json['lastUpdated'] as String,
  ),
  lastCareAt: const UtcDateTimeConverter().fromJson(
    json['lastCareAt'] as String,
  ),
  stageStartedAt: const UtcDateTimeConverter().fromJson(
    json['stageStartedAt'] as String,
  ),
  stage:
      $enumDecodeNullable(_$LifeStageEnumMap, json['stage']) ?? LifeStage.egg,
  character: $enumDecodeNullable(_$PetCharacterEnumMap, json['character']),
  fullness: (json['fullness'] as num?)?.toDouble() ?? GameRules.startFullness,
  happiness:
      (json['happiness'] as num?)?.toDouble() ?? GameRules.startHappiness,
  poop: (json['poop'] as num?)?.toInt() ?? 0,
  poopDueAt:
      (json['poopDueAt'] as List<dynamic>?)
          ?.map((e) => const UtcDateTimeConverter().fromJson(e as String))
          .toList() ??
      const <DateTime>[],
  firstPoopAt: _$JsonConverterFromJson<String, DateTime>(
    json['firstPoopAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  isSick: json['isSick'] as bool? ?? false,
  medicineDoses: (json['medicineDoses'] as num?)?.toInt() ?? 0,
  weight: (json['weight'] as num?)?.toInt() ?? GameRules.startWeight,
  bond: (json['bond'] as num?)?.toDouble() ?? 0,
  lightsOn: json['lightsOn'] as bool? ?? true,
  lightsOnAllSleep: json['lightsOnAllSleep'] as bool? ?? false,
  isMoody: json['isMoody'] as bool? ?? false,
  onVacation: json['onVacation'] as bool? ?? false,
  zeroNeedFor: json['zeroNeedFor'] == null
      ? Duration.zero
      : Duration(microseconds: (json['zeroNeedFor'] as num).toInt()),
  heavyPoopFor: json['heavyPoopFor'] == null
      ? Duration.zero
      : Duration(microseconds: (json['heavyPoopFor'] as num).toInt()),
  lowBothFor: json['lowBothFor'] == null
      ? Duration.zero
      : Duration(microseconds: (json['lowBothFor'] as num).toInt()),
  recentSnacks:
      (json['recentSnacks'] as List<dynamic>?)
          ?.map((e) => const UtcDateTimeConverter().fromJson(e as String))
          .toList() ??
      const <DateTime>[],
  careStyle: json['careStyle'] == null
      ? const CareStyle()
      : CareStyle.fromJson(json['careStyle'] as Map<String, dynamic>),
  sleepSchedule: json['sleepSchedule'] == null
      ? const SleepSchedule()
      : SleepSchedule.fromJson(json['sleepSchedule'] as Map<String, dynamic>),
  pendingReveal: json['pendingReveal'] as bool? ?? false,
);

Map<String, dynamic> _$PetStateToJson(_PetState instance) => <String, dynamic>{
  'bornAt': const UtcDateTimeConverter().toJson(instance.bornAt),
  'lastUpdated': const UtcDateTimeConverter().toJson(instance.lastUpdated),
  'lastCareAt': const UtcDateTimeConverter().toJson(instance.lastCareAt),
  'stageStartedAt': const UtcDateTimeConverter().toJson(
    instance.stageStartedAt,
  ),
  'stage': _$LifeStageEnumMap[instance.stage]!,
  'character': _$PetCharacterEnumMap[instance.character],
  'fullness': instance.fullness,
  'happiness': instance.happiness,
  'poop': instance.poop,
  'poopDueAt': instance.poopDueAt
      .map(const UtcDateTimeConverter().toJson)
      .toList(),
  'firstPoopAt': _$JsonConverterToJson<String, DateTime>(
    instance.firstPoopAt,
    const UtcDateTimeConverter().toJson,
  ),
  'isSick': instance.isSick,
  'medicineDoses': instance.medicineDoses,
  'weight': instance.weight,
  'bond': instance.bond,
  'lightsOn': instance.lightsOn,
  'lightsOnAllSleep': instance.lightsOnAllSleep,
  'isMoody': instance.isMoody,
  'onVacation': instance.onVacation,
  'zeroNeedFor': instance.zeroNeedFor.inMicroseconds,
  'heavyPoopFor': instance.heavyPoopFor.inMicroseconds,
  'lowBothFor': instance.lowBothFor.inMicroseconds,
  'recentSnacks': instance.recentSnacks
      .map(const UtcDateTimeConverter().toJson)
      .toList(),
  'careStyle': instance.careStyle.toJson(),
  'sleepSchedule': instance.sleepSchedule.toJson(),
  'pendingReveal': instance.pendingReveal,
};

const _$LifeStageEnumMap = {
  LifeStage.egg: 'egg',
  LifeStage.baby: 'baby',
  LifeStage.child: 'child',
  LifeStage.teen: 'teen',
  LifeStage.adult: 'adult',
};

const _$PetCharacterEnumMap = {
  PetCharacter.atletis: 'atletis',
  PetCharacter.gembul: 'gembul',
  PetCharacter.rapi: 'rapi',
  PetCharacter.mandiri: 'mandiri',
  PetCharacter.seimbang: 'seimbang',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
