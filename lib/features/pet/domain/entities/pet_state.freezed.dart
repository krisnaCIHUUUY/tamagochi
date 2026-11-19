// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetState {

 DateTime get bornAt; DateTime get lastUpdated; DateTime get lastCareAt; DateTime get stageStartedAt; LifeStage get stage; PetCharacter? get character; double get fullness; double get happiness; int get poop; List<DateTime> get poopDueAt; DateTime? get firstPoopAt; bool get isSick; int get medicineDoses; int get weight; double get bond; bool get lightsOn; bool get lightsOnAllSleep; bool get isMoody; bool get onVacation; Duration get zeroNeedFor; Duration get heavyPoopFor; Duration get lowBothFor; List<DateTime> get recentSnacks; CareStyle get careStyle; SleepSchedule get sleepSchedule; bool get pendingReveal;
/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetStateCopyWith<PetState> get copyWith => _$PetStateCopyWithImpl<PetState>(this as PetState, _$identity);

  /// Serializes this PetState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PetState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetState&&(identical(other.bornAt, _this.bornAt) || other.bornAt == _this.bornAt)&&(identical(other.lastUpdated, _this.lastUpdated) || other.lastUpdated == _this.lastUpdated)&&(identical(other.lastCareAt, _this.lastCareAt) || other.lastCareAt == _this.lastCareAt)&&(identical(other.stageStartedAt, _this.stageStartedAt) || other.stageStartedAt == _this.stageStartedAt)&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.character, _this.character) || other.character == _this.character)&&(identical(other.fullness, _this.fullness) || other.fullness == _this.fullness)&&(identical(other.happiness, _this.happiness) || other.happiness == _this.happiness)&&(identical(other.poop, _this.poop) || other.poop == _this.poop)&&const DeepCollectionEquality().equals(other.poopDueAt, _this.poopDueAt)&&(identical(other.firstPoopAt, _this.firstPoopAt) || other.firstPoopAt == _this.firstPoopAt)&&(identical(other.isSick, _this.isSick) || other.isSick == _this.isSick)&&(identical(other.medicineDoses, _this.medicineDoses) || other.medicineDoses == _this.medicineDoses)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.bond, _this.bond) || other.bond == _this.bond)&&(identical(other.lightsOn, _this.lightsOn) || other.lightsOn == _this.lightsOn)&&(identical(other.lightsOnAllSleep, _this.lightsOnAllSleep) || other.lightsOnAllSleep == _this.lightsOnAllSleep)&&(identical(other.isMoody, _this.isMoody) || other.isMoody == _this.isMoody)&&(identical(other.onVacation, _this.onVacation) || other.onVacation == _this.onVacation)&&(identical(other.zeroNeedFor, _this.zeroNeedFor) || other.zeroNeedFor == _this.zeroNeedFor)&&(identical(other.heavyPoopFor, _this.heavyPoopFor) || other.heavyPoopFor == _this.heavyPoopFor)&&(identical(other.lowBothFor, _this.lowBothFor) || other.lowBothFor == _this.lowBothFor)&&const DeepCollectionEquality().equals(other.recentSnacks, _this.recentSnacks)&&(identical(other.careStyle, _this.careStyle) || other.careStyle == _this.careStyle)&&(identical(other.sleepSchedule, _this.sleepSchedule) || other.sleepSchedule == _this.sleepSchedule)&&(identical(other.pendingReveal, _this.pendingReveal) || other.pendingReveal == _this.pendingReveal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PetState;
  return Object.hashAll([runtimeType,_this.bornAt,_this.lastUpdated,_this.lastCareAt,_this.stageStartedAt,_this.stage,_this.character,_this.fullness,_this.happiness,_this.poop,const DeepCollectionEquality().hash(_this.poopDueAt),_this.firstPoopAt,_this.isSick,_this.medicineDoses,_this.weight,_this.bond,_this.lightsOn,_this.lightsOnAllSleep,_this.isMoody,_this.onVacation,_this.zeroNeedFor,_this.heavyPoopFor,_this.lowBothFor,const DeepCollectionEquality().hash(_this.recentSnacks),_this.careStyle,_this.sleepSchedule,_this.pendingReveal]);
}

@override
String toString() {
  final _this = this as PetState;
  return 'PetState(bornAt: ${_this.bornAt}, lastUpdated: ${_this.lastUpdated}, lastCareAt: ${_this.lastCareAt}, stageStartedAt: ${_this.stageStartedAt}, stage: ${_this.stage}, character: ${_this.character}, fullness: ${_this.fullness}, happiness: ${_this.happiness}, poop: ${_this.poop}, poopDueAt: ${_this.poopDueAt}, firstPoopAt: ${_this.firstPoopAt}, isSick: ${_this.isSick}, medicineDoses: ${_this.medicineDoses}, weight: ${_this.weight}, bond: ${_this.bond}, lightsOn: ${_this.lightsOn}, lightsOnAllSleep: ${_this.lightsOnAllSleep}, isMoody: ${_this.isMoody}, onVacation: ${_this.onVacation}, zeroNeedFor: ${_this.zeroNeedFor}, heavyPoopFor: ${_this.heavyPoopFor}, lowBothFor: ${_this.lowBothFor}, recentSnacks: ${_this.recentSnacks}, careStyle: ${_this.careStyle}, sleepSchedule: ${_this.sleepSchedule}, pendingReveal: ${_this.pendingReveal})';
}


}

/// @nodoc
abstract mixin class $PetStateCopyWith<$Res>  {
  factory $PetStateCopyWith(PetState value, $Res Function(PetState) _then) = _$PetStateCopyWithImpl;
@useResult
$Res call({
 DateTime bornAt, DateTime lastUpdated, DateTime lastCareAt, DateTime stageStartedAt, LifeStage stage, PetCharacter? character, double fullness, double happiness, int poop, List<DateTime> poopDueAt, DateTime? firstPoopAt, bool isSick, int medicineDoses, int weight, double bond, bool lightsOn, bool lightsOnAllSleep, bool isMoody, bool onVacation, Duration zeroNeedFor, Duration heavyPoopFor, Duration lowBothFor, List<DateTime> recentSnacks, CareStyle careStyle, SleepSchedule sleepSchedule, bool pendingReveal
});


$CareStyleCopyWith<$Res> get careStyle;$SleepScheduleCopyWith<$Res> get sleepSchedule;

}
/// @nodoc
class _$PetStateCopyWithImpl<$Res>
    implements $PetStateCopyWith<$Res> {
  _$PetStateCopyWithImpl(this._self, this._then);

  final PetState _self;
  final $Res Function(PetState) _then;

/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bornAt = null,Object? lastUpdated = null,Object? lastCareAt = null,Object? stageStartedAt = null,Object? stage = null,Object? character = freezed,Object? fullness = null,Object? happiness = null,Object? poop = null,Object? poopDueAt = null,Object? firstPoopAt = freezed,Object? isSick = null,Object? medicineDoses = null,Object? weight = null,Object? bond = null,Object? lightsOn = null,Object? lightsOnAllSleep = null,Object? isMoody = null,Object? onVacation = null,Object? zeroNeedFor = null,Object? heavyPoopFor = null,Object? lowBothFor = null,Object? recentSnacks = null,Object? careStyle = null,Object? sleepSchedule = null,Object? pendingReveal = null,}) {
  return _then(PetState(
bornAt: null == bornAt ? _self.bornAt : bornAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,lastCareAt: null == lastCareAt ? _self.lastCareAt : lastCareAt // ignore: cast_nullable_to_non_nullable
as DateTime,stageStartedAt: null == stageStartedAt ? _self.stageStartedAt : stageStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as LifeStage,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as PetCharacter?,fullness: null == fullness ? _self.fullness : fullness // ignore: cast_nullable_to_non_nullable
as double,happiness: null == happiness ? _self.happiness : happiness // ignore: cast_nullable_to_non_nullable
as double,poop: null == poop ? _self.poop : poop // ignore: cast_nullable_to_non_nullable
as int,poopDueAt: null == poopDueAt ? _self.poopDueAt : poopDueAt // ignore: cast_nullable_to_non_nullable
as List<DateTime>,firstPoopAt: freezed == firstPoopAt ? _self.firstPoopAt : firstPoopAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isSick: null == isSick ? _self.isSick : isSick // ignore: cast_nullable_to_non_nullable
as bool,medicineDoses: null == medicineDoses ? _self.medicineDoses : medicineDoses // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,bond: null == bond ? _self.bond : bond // ignore: cast_nullable_to_non_nullable
as double,lightsOn: null == lightsOn ? _self.lightsOn : lightsOn // ignore: cast_nullable_to_non_nullable
as bool,lightsOnAllSleep: null == lightsOnAllSleep ? _self.lightsOnAllSleep : lightsOnAllSleep // ignore: cast_nullable_to_non_nullable
as bool,isMoody: null == isMoody ? _self.isMoody : isMoody // ignore: cast_nullable_to_non_nullable
as bool,onVacation: null == onVacation ? _self.onVacation : onVacation // ignore: cast_nullable_to_non_nullable
as bool,zeroNeedFor: null == zeroNeedFor ? _self.zeroNeedFor : zeroNeedFor // ignore: cast_nullable_to_non_nullable
as Duration,heavyPoopFor: null == heavyPoopFor ? _self.heavyPoopFor : heavyPoopFor // ignore: cast_nullable_to_non_nullable
as Duration,lowBothFor: null == lowBothFor ? _self.lowBothFor : lowBothFor // ignore: cast_nullable_to_non_nullable
as Duration,recentSnacks: null == recentSnacks ? _self.recentSnacks : recentSnacks // ignore: cast_nullable_to_non_nullable
as List<DateTime>,careStyle: null == careStyle ? _self.careStyle : careStyle // ignore: cast_nullable_to_non_nullable
as CareStyle,sleepSchedule: null == sleepSchedule ? _self.sleepSchedule : sleepSchedule // ignore: cast_nullable_to_non_nullable
as SleepSchedule,pendingReveal: null == pendingReveal ? _self.pendingReveal : pendingReveal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareStyleCopyWith<$Res> get careStyle {
  
  return $CareStyleCopyWith<$Res>(_self.careStyle, (value) {
    return _then(_self.copyWith(careStyle: value));
  });
}/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SleepScheduleCopyWith<$Res> get sleepSchedule {
  
  return $SleepScheduleCopyWith<$Res>(_self.sleepSchedule, (value) {
    return _then(_self.copyWith(sleepSchedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [PetState].
extension PetStatePatterns on PetState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetState value)  $default,){
final _that = this;
switch (_that) {
case _PetState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetState value)?  $default,){
final _that = this;
switch (_that) {
case _PetState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime bornAt,  DateTime lastUpdated,  DateTime lastCareAt,  DateTime stageStartedAt,  LifeStage stage,  PetCharacter? character,  double fullness,  double happiness,  int poop,  List<DateTime> poopDueAt,  DateTime? firstPoopAt,  bool isSick,  int medicineDoses,  int weight,  double bond,  bool lightsOn,  bool lightsOnAllSleep,  bool isMoody,  bool onVacation,  Duration zeroNeedFor,  Duration heavyPoopFor,  Duration lowBothFor,  List<DateTime> recentSnacks,  CareStyle careStyle,  SleepSchedule sleepSchedule,  bool pendingReveal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetState() when $default != null:
return $default(_that.bornAt,_that.lastUpdated,_that.lastCareAt,_that.stageStartedAt,_that.stage,_that.character,_that.fullness,_that.happiness,_that.poop,_that.poopDueAt,_that.firstPoopAt,_that.isSick,_that.medicineDoses,_that.weight,_that.bond,_that.lightsOn,_that.lightsOnAllSleep,_that.isMoody,_that.onVacation,_that.zeroNeedFor,_that.heavyPoopFor,_that.lowBothFor,_that.recentSnacks,_that.careStyle,_that.sleepSchedule,_that.pendingReveal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime bornAt,  DateTime lastUpdated,  DateTime lastCareAt,  DateTime stageStartedAt,  LifeStage stage,  PetCharacter? character,  double fullness,  double happiness,  int poop,  List<DateTime> poopDueAt,  DateTime? firstPoopAt,  bool isSick,  int medicineDoses,  int weight,  double bond,  bool lightsOn,  bool lightsOnAllSleep,  bool isMoody,  bool onVacation,  Duration zeroNeedFor,  Duration heavyPoopFor,  Duration lowBothFor,  List<DateTime> recentSnacks,  CareStyle careStyle,  SleepSchedule sleepSchedule,  bool pendingReveal)  $default,) {final _that = this;
switch (_that) {
case _PetState():
return $default(_that.bornAt,_that.lastUpdated,_that.lastCareAt,_that.stageStartedAt,_that.stage,_that.character,_that.fullness,_that.happiness,_that.poop,_that.poopDueAt,_that.firstPoopAt,_that.isSick,_that.medicineDoses,_that.weight,_that.bond,_that.lightsOn,_that.lightsOnAllSleep,_that.isMoody,_that.onVacation,_that.zeroNeedFor,_that.heavyPoopFor,_that.lowBothFor,_that.recentSnacks,_that.careStyle,_that.sleepSchedule,_that.pendingReveal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime bornAt,  DateTime lastUpdated,  DateTime lastCareAt,  DateTime stageStartedAt,  LifeStage stage,  PetCharacter? character,  double fullness,  double happiness,  int poop,  List<DateTime> poopDueAt,  DateTime? firstPoopAt,  bool isSick,  int medicineDoses,  int weight,  double bond,  bool lightsOn,  bool lightsOnAllSleep,  bool isMoody,  bool onVacation,  Duration zeroNeedFor,  Duration heavyPoopFor,  Duration lowBothFor,  List<DateTime> recentSnacks,  CareStyle careStyle,  SleepSchedule sleepSchedule,  bool pendingReveal)?  $default,) {final _that = this;
switch (_that) {
case _PetState() when $default != null:
return $default(_that.bornAt,_that.lastUpdated,_that.lastCareAt,_that.stageStartedAt,_that.stage,_that.character,_that.fullness,_that.happiness,_that.poop,_that.poopDueAt,_that.firstPoopAt,_that.isSick,_that.medicineDoses,_that.weight,_that.bond,_that.lightsOn,_that.lightsOnAllSleep,_that.isMoody,_that.onVacation,_that.zeroNeedFor,_that.heavyPoopFor,_that.lowBothFor,_that.recentSnacks,_that.careStyle,_that.sleepSchedule,_that.pendingReveal);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PetState implements PetState {
  const _PetState({required this.bornAt, required this.lastUpdated, required this.lastCareAt, required this.stageStartedAt, this.stage = LifeStage.egg, this.character, this.fullness = GameRules.startFullness, this.happiness = GameRules.startHappiness, this.poop = 0,  List<DateTime> poopDueAt = const <DateTime>[], this.firstPoopAt, this.isSick = false, this.medicineDoses = 0, this.weight = GameRules.startWeight, this.bond = 0, this.lightsOn = true, this.lightsOnAllSleep = false, this.isMoody = false, this.onVacation = false, this.zeroNeedFor = Duration.zero, this.heavyPoopFor = Duration.zero, this.lowBothFor = Duration.zero,  List<DateTime> recentSnacks = const <DateTime>[], this.careStyle = const CareStyle(), this.sleepSchedule = const SleepSchedule(), this.pendingReveal = false}): _poopDueAt = poopDueAt,_recentSnacks = recentSnacks;
  factory _PetState.fromJson(Map<String, dynamic> json) => _$PetStateFromJson(json);

@override final  DateTime bornAt;
@override final  DateTime lastUpdated;
@override final  DateTime lastCareAt;
@override final  DateTime stageStartedAt;
@override@JsonKey() final  LifeStage stage;
@override final  PetCharacter? character;
@override@JsonKey() final  double fullness;
@override@JsonKey() final  double happiness;
@override@JsonKey() final  int poop;
 final  List<DateTime> _poopDueAt;
@override@JsonKey() List<DateTime> get poopDueAt {
  if (_poopDueAt is EqualUnmodifiableListView) return _poopDueAt;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_poopDueAt);
}

@override final  DateTime? firstPoopAt;
@override@JsonKey() final  bool isSick;
@override@JsonKey() final  int medicineDoses;
@override@JsonKey() final  int weight;
@override@JsonKey() final  double bond;
@override@JsonKey() final  bool lightsOn;
@override@JsonKey() final  bool lightsOnAllSleep;
@override@JsonKey() final  bool isMoody;
@override@JsonKey() final  bool onVacation;
@override@JsonKey() final  Duration zeroNeedFor;
@override@JsonKey() final  Duration heavyPoopFor;
@override@JsonKey() final  Duration lowBothFor;
 final  List<DateTime> _recentSnacks;
@override@JsonKey() List<DateTime> get recentSnacks {
  if (_recentSnacks is EqualUnmodifiableListView) return _recentSnacks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSnacks);
}

@override@JsonKey() final  CareStyle careStyle;
@override@JsonKey() final  SleepSchedule sleepSchedule;
@override@JsonKey() final  bool pendingReveal;

/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetStateCopyWith<_PetState> get copyWith => __$PetStateCopyWithImpl<_PetState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetState&&(identical(other.bornAt, bornAt) || other.bornAt == bornAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.lastCareAt, lastCareAt) || other.lastCareAt == lastCareAt)&&(identical(other.stageStartedAt, stageStartedAt) || other.stageStartedAt == stageStartedAt)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.character, character) || other.character == character)&&(identical(other.fullness, fullness) || other.fullness == fullness)&&(identical(other.happiness, happiness) || other.happiness == happiness)&&(identical(other.poop, poop) || other.poop == poop)&&const DeepCollectionEquality().equals(other.poopDueAt, _poopDueAt)&&(identical(other.firstPoopAt, firstPoopAt) || other.firstPoopAt == firstPoopAt)&&(identical(other.isSick, isSick) || other.isSick == isSick)&&(identical(other.medicineDoses, medicineDoses) || other.medicineDoses == medicineDoses)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.bond, bond) || other.bond == bond)&&(identical(other.lightsOn, lightsOn) || other.lightsOn == lightsOn)&&(identical(other.lightsOnAllSleep, lightsOnAllSleep) || other.lightsOnAllSleep == lightsOnAllSleep)&&(identical(other.isMoody, isMoody) || other.isMoody == isMoody)&&(identical(other.onVacation, onVacation) || other.onVacation == onVacation)&&(identical(other.zeroNeedFor, zeroNeedFor) || other.zeroNeedFor == zeroNeedFor)&&(identical(other.heavyPoopFor, heavyPoopFor) || other.heavyPoopFor == heavyPoopFor)&&(identical(other.lowBothFor, lowBothFor) || other.lowBothFor == lowBothFor)&&const DeepCollectionEquality().equals(other.recentSnacks, _recentSnacks)&&(identical(other.careStyle, careStyle) || other.careStyle == careStyle)&&(identical(other.sleepSchedule, sleepSchedule) || other.sleepSchedule == sleepSchedule)&&(identical(other.pendingReveal, pendingReveal) || other.pendingReveal == pendingReveal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,bornAt,lastUpdated,lastCareAt,stageStartedAt,stage,character,fullness,happiness,poop,const DeepCollectionEquality().hash(_poopDueAt),firstPoopAt,isSick,medicineDoses,weight,bond,lightsOn,lightsOnAllSleep,isMoody,onVacation,zeroNeedFor,heavyPoopFor,lowBothFor,const DeepCollectionEquality().hash(_recentSnacks),careStyle,sleepSchedule,pendingReveal]);
}

@override
String toString() {
    return 'PetState(bornAt: $bornAt, lastUpdated: $lastUpdated, lastCareAt: $lastCareAt, stageStartedAt: $stageStartedAt, stage: $stage, character: $character, fullness: $fullness, happiness: $happiness, poop: $poop, poopDueAt: $poopDueAt, firstPoopAt: $firstPoopAt, isSick: $isSick, medicineDoses: $medicineDoses, weight: $weight, bond: $bond, lightsOn: $lightsOn, lightsOnAllSleep: $lightsOnAllSleep, isMoody: $isMoody, onVacation: $onVacation, zeroNeedFor: $zeroNeedFor, heavyPoopFor: $heavyPoopFor, lowBothFor: $lowBothFor, recentSnacks: $recentSnacks, careStyle: $careStyle, sleepSchedule: $sleepSchedule, pendingReveal: $pendingReveal)';
}


}

/// @nodoc
abstract mixin class _$PetStateCopyWith<$Res> implements $PetStateCopyWith<$Res> {
  factory _$PetStateCopyWith(_PetState value, $Res Function(_PetState) _then) = __$PetStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime bornAt, DateTime lastUpdated, DateTime lastCareAt, DateTime stageStartedAt, LifeStage stage, PetCharacter? character, double fullness, double happiness, int poop, List<DateTime> poopDueAt, DateTime? firstPoopAt, bool isSick, int medicineDoses, int weight, double bond, bool lightsOn, bool lightsOnAllSleep, bool isMoody, bool onVacation, Duration zeroNeedFor, Duration heavyPoopFor, Duration lowBothFor, List<DateTime> recentSnacks, CareStyle careStyle, SleepSchedule sleepSchedule, bool pendingReveal
});


@override $CareStyleCopyWith<$Res> get careStyle;@override $SleepScheduleCopyWith<$Res> get sleepSchedule;

}
/// @nodoc
class __$PetStateCopyWithImpl<$Res>
    implements _$PetStateCopyWith<$Res> {
  __$PetStateCopyWithImpl(this._self, this._then);

  final _PetState _self;
  final $Res Function(_PetState) _then;

/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bornAt = null,Object? lastUpdated = null,Object? lastCareAt = null,Object? stageStartedAt = null,Object? stage = null,Object? character = freezed,Object? fullness = null,Object? happiness = null,Object? poop = null,Object? poopDueAt = null,Object? firstPoopAt = freezed,Object? isSick = null,Object? medicineDoses = null,Object? weight = null,Object? bond = null,Object? lightsOn = null,Object? lightsOnAllSleep = null,Object? isMoody = null,Object? onVacation = null,Object? zeroNeedFor = null,Object? heavyPoopFor = null,Object? lowBothFor = null,Object? recentSnacks = null,Object? careStyle = null,Object? sleepSchedule = null,Object? pendingReveal = null,}) {
  return _then(_PetState(
bornAt: null == bornAt ? _self.bornAt : bornAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,lastCareAt: null == lastCareAt ? _self.lastCareAt : lastCareAt // ignore: cast_nullable_to_non_nullable
as DateTime,stageStartedAt: null == stageStartedAt ? _self.stageStartedAt : stageStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as LifeStage,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as PetCharacter?,fullness: null == fullness ? _self.fullness : fullness // ignore: cast_nullable_to_non_nullable
as double,happiness: null == happiness ? _self.happiness : happiness // ignore: cast_nullable_to_non_nullable
as double,poop: null == poop ? _self.poop : poop // ignore: cast_nullable_to_non_nullable
as int,poopDueAt: null == poopDueAt ? _self._poopDueAt : poopDueAt // ignore: cast_nullable_to_non_nullable
as List<DateTime>,firstPoopAt: freezed == firstPoopAt ? _self.firstPoopAt : firstPoopAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isSick: null == isSick ? _self.isSick : isSick // ignore: cast_nullable_to_non_nullable
as bool,medicineDoses: null == medicineDoses ? _self.medicineDoses : medicineDoses // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,bond: null == bond ? _self.bond : bond // ignore: cast_nullable_to_non_nullable
as double,lightsOn: null == lightsOn ? _self.lightsOn : lightsOn // ignore: cast_nullable_to_non_nullable
as bool,lightsOnAllSleep: null == lightsOnAllSleep ? _self.lightsOnAllSleep : lightsOnAllSleep // ignore: cast_nullable_to_non_nullable
as bool,isMoody: null == isMoody ? _self.isMoody : isMoody // ignore: cast_nullable_to_non_nullable
as bool,onVacation: null == onVacation ? _self.onVacation : onVacation // ignore: cast_nullable_to_non_nullable
as bool,zeroNeedFor: null == zeroNeedFor ? _self.zeroNeedFor : zeroNeedFor // ignore: cast_nullable_to_non_nullable
as Duration,heavyPoopFor: null == heavyPoopFor ? _self.heavyPoopFor : heavyPoopFor // ignore: cast_nullable_to_non_nullable
as Duration,lowBothFor: null == lowBothFor ? _self.lowBothFor : lowBothFor // ignore: cast_nullable_to_non_nullable
as Duration,recentSnacks: null == recentSnacks ? _self._recentSnacks : recentSnacks // ignore: cast_nullable_to_non_nullable
as List<DateTime>,careStyle: null == careStyle ? _self.careStyle : careStyle // ignore: cast_nullable_to_non_nullable
as CareStyle,sleepSchedule: null == sleepSchedule ? _self.sleepSchedule : sleepSchedule // ignore: cast_nullable_to_non_nullable
as SleepSchedule,pendingReveal: null == pendingReveal ? _self.pendingReveal : pendingReveal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareStyleCopyWith<$Res> get careStyle {
  
  return $CareStyleCopyWith<$Res>(_self.careStyle, (value) {
    return _then(_self.copyWith(careStyle: value));
  });
}/// Create a copy of PetState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SleepScheduleCopyWith<$Res> get sleepSchedule {
  
  return $SleepScheduleCopyWith<$Res>(_self.sleepSchedule, (value) {
    return _then(_self.copyWith(sleepSchedule: value));
  });
}
}

// dart format on
