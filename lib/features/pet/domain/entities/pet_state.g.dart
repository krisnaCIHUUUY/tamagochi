// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetState _$PetStateFromJson(Map<String, dynamic> json) => _PetState(
  bornAt: DateTime.parse(json['bornAt'] as String),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  lastCareAt: DateTime.parse(json['lastCareAt'] as String),
  stageStartedAt: DateTime.parse(json['stageStartedAt'] as String),
  stage:
      $enumDecodeNullable(_$LifeStageEnumMap, json['stage']) ?? LifeStage.egg,
  character: $enumDecodeNullable(_$PetCharacterEnumMap, json['character']),
  fullness: (json['fullness'] as num?)?.toDouble() ?? GameRules.startFullness,
  happiness:
      (json['happiness'] as num?)?.toDouble() ?? GameRules.startHappiness,
  poop: (json['poop'] as num?)?.toInt() ?? 0,
  poopDueAt:
      (json['poopDueAt'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const <DateTime>[],
  firstPoopAt: json['firstPoopAt'] == null
      ? null
      : DateTime.parse(json['firstPoopAt'] as String),
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
          ?.map((e) => DateTime.parse(e as String))
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
  'bornAt': instance.bornAt.toIso8601String(),
  'lastUpdated': instance.lastUpdated.toIso8601String(),
  'lastCareAt': instance.lastCareAt.toIso8601String(),
  'stageStartedAt': instance.stageStartedAt.toIso8601String(),
  'stage': _$LifeStageEnumMap[instance.stage]!,
  'character': _$PetCharacterEnumMap[instance.character],
  'fullness': instance.fullness,
  'happiness': instance.happiness,
  'poop': instance.poop,
  'poopDueAt': instance.poopDueAt.map((e) => e.toIso8601String()).toList(),
  'firstPoopAt': instance.firstPoopAt?.toIso8601String(),
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
      .map((e) => e.toIso8601String())
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
