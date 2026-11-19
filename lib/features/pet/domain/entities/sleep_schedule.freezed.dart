// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SleepSchedule {

 int get startHour; int get endHour;
/// Create a copy of SleepSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepScheduleCopyWith<SleepSchedule> get copyWith => _$SleepScheduleCopyWithImpl<SleepSchedule>(this as SleepSchedule, _$identity);

  /// Serializes this SleepSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SleepSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepSchedule&&(identical(other.startHour, _this.startHour) || other.startHour == _this.startHour)&&(identical(other.endHour, _this.endHour) || other.endHour == _this.endHour));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SleepSchedule;
  return Object.hash(runtimeType,_this.startHour,_this.endHour);
}

@override
String toString() {
  final _this = this as SleepSchedule;
  return 'SleepSchedule(startHour: ${_this.startHour}, endHour: ${_this.endHour})';
}


}

/// @nodoc
abstract mixin class $SleepScheduleCopyWith<$Res>  {
  factory $SleepScheduleCopyWith(SleepSchedule value, $Res Function(SleepSchedule) _then) = _$SleepScheduleCopyWithImpl;
@useResult
$Res call({
 int startHour, int endHour
});




}
/// @nodoc
class _$SleepScheduleCopyWithImpl<$Res>
    implements $SleepScheduleCopyWith<$Res> {
  _$SleepScheduleCopyWithImpl(this._self, this._then);

  final SleepSchedule _self;
  final $Res Function(SleepSchedule) _then;

/// Create a copy of SleepSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startHour = null,Object? endHour = null,}) {
  return _then(SleepSchedule(
startHour: null == startHour ? _self.startHour : startHour // ignore: cast_nullable_to_non_nullable
as int,endHour: null == endHour ? _self.endHour : endHour // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepSchedule].
extension SleepSchedulePatterns on SleepSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepSchedule value)  $default,){
final _that = this;
switch (_that) {
case _SleepSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _SleepSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int startHour,  int endHour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepSchedule() when $default != null:
return $default(_that.startHour,_that.endHour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int startHour,  int endHour)  $default,) {final _that = this;
switch (_that) {
case _SleepSchedule():
return $default(_that.startHour,_that.endHour);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int startHour,  int endHour)?  $default,) {final _that = this;
switch (_that) {
case _SleepSchedule() when $default != null:
return $default(_that.startHour,_that.endHour);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SleepSchedule implements SleepSchedule {
  const _SleepSchedule({this.startHour = GameRules.sleepStartHour, this.endHour = GameRules.sleepEndHour});
  factory _SleepSchedule.fromJson(Map<String, dynamic> json) => _$SleepScheduleFromJson(json);

@override@JsonKey() final  int startHour;
@override@JsonKey() final  int endHour;

/// Create a copy of SleepSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepScheduleCopyWith<_SleepSchedule> get copyWith => __$SleepScheduleCopyWithImpl<_SleepSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SleepScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepSchedule&&(identical(other.startHour, startHour) || other.startHour == startHour)&&(identical(other.endHour, endHour) || other.endHour == endHour));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startHour,endHour);
}

@override
String toString() {
    return 'SleepSchedule(startHour: $startHour, endHour: $endHour)';
}


}

/// @nodoc
abstract mixin class _$SleepScheduleCopyWith<$Res> implements $SleepScheduleCopyWith<$Res> {
  factory _$SleepScheduleCopyWith(_SleepSchedule value, $Res Function(_SleepSchedule) _then) = __$SleepScheduleCopyWithImpl;
@override @useResult
$Res call({
 int startHour, int endHour
});




}
/// @nodoc
class __$SleepScheduleCopyWithImpl<$Res>
    implements _$SleepScheduleCopyWith<$Res> {
  __$SleepScheduleCopyWithImpl(this._self, this._then);

  final _SleepSchedule _self;
  final $Res Function(_SleepSchedule) _then;

/// Create a copy of SleepSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startHour = null,Object? endHour = null,}) {
  return _then(_SleepSchedule(
startHour: null == startHour ? _self.startHour : startHour // ignore: cast_nullable_to_non_nullable
as int,endHour: null == endHour ? _self.endHour : endHour // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
