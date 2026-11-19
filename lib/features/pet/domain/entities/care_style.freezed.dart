// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_style.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareStyle {

 int get plays; int get snacks; int get timelyCleans; int get neglectMinutes; int get balancedActions;
/// Create a copy of CareStyle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareStyleCopyWith<CareStyle> get copyWith => _$CareStyleCopyWithImpl<CareStyle>(this as CareStyle, _$identity);

  /// Serializes this CareStyle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CareStyle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareStyle&&(identical(other.plays, _this.plays) || other.plays == _this.plays)&&(identical(other.snacks, _this.snacks) || other.snacks == _this.snacks)&&(identical(other.timelyCleans, _this.timelyCleans) || other.timelyCleans == _this.timelyCleans)&&(identical(other.neglectMinutes, _this.neglectMinutes) || other.neglectMinutes == _this.neglectMinutes)&&(identical(other.balancedActions, _this.balancedActions) || other.balancedActions == _this.balancedActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CareStyle;
  return Object.hash(runtimeType,_this.plays,_this.snacks,_this.timelyCleans,_this.neglectMinutes,_this.balancedActions);
}

@override
String toString() {
  final _this = this as CareStyle;
  return 'CareStyle(plays: ${_this.plays}, snacks: ${_this.snacks}, timelyCleans: ${_this.timelyCleans}, neglectMinutes: ${_this.neglectMinutes}, balancedActions: ${_this.balancedActions})';
}


}

/// @nodoc
abstract mixin class $CareStyleCopyWith<$Res>  {
  factory $CareStyleCopyWith(CareStyle value, $Res Function(CareStyle) _then) = _$CareStyleCopyWithImpl;
@useResult
$Res call({
 int plays, int snacks, int timelyCleans, int neglectMinutes, int balancedActions
});




}
/// @nodoc
class _$CareStyleCopyWithImpl<$Res>
    implements $CareStyleCopyWith<$Res> {
  _$CareStyleCopyWithImpl(this._self, this._then);

  final CareStyle _self;
  final $Res Function(CareStyle) _then;

/// Create a copy of CareStyle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plays = null,Object? snacks = null,Object? timelyCleans = null,Object? neglectMinutes = null,Object? balancedActions = null,}) {
  return _then(CareStyle(
plays: null == plays ? _self.plays : plays // ignore: cast_nullable_to_non_nullable
as int,snacks: null == snacks ? _self.snacks : snacks // ignore: cast_nullable_to_non_nullable
as int,timelyCleans: null == timelyCleans ? _self.timelyCleans : timelyCleans // ignore: cast_nullable_to_non_nullable
as int,neglectMinutes: null == neglectMinutes ? _self.neglectMinutes : neglectMinutes // ignore: cast_nullable_to_non_nullable
as int,balancedActions: null == balancedActions ? _self.balancedActions : balancedActions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CareStyle].
extension CareStylePatterns on CareStyle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareStyle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareStyle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareStyle value)  $default,){
final _that = this;
switch (_that) {
case _CareStyle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareStyle value)?  $default,){
final _that = this;
switch (_that) {
case _CareStyle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int plays,  int snacks,  int timelyCleans,  int neglectMinutes,  int balancedActions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareStyle() when $default != null:
return $default(_that.plays,_that.snacks,_that.timelyCleans,_that.neglectMinutes,_that.balancedActions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int plays,  int snacks,  int timelyCleans,  int neglectMinutes,  int balancedActions)  $default,) {final _that = this;
switch (_that) {
case _CareStyle():
return $default(_that.plays,_that.snacks,_that.timelyCleans,_that.neglectMinutes,_that.balancedActions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int plays,  int snacks,  int timelyCleans,  int neglectMinutes,  int balancedActions)?  $default,) {final _that = this;
switch (_that) {
case _CareStyle() when $default != null:
return $default(_that.plays,_that.snacks,_that.timelyCleans,_that.neglectMinutes,_that.balancedActions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareStyle implements CareStyle {
  const _CareStyle({this.plays = 0, this.snacks = 0, this.timelyCleans = 0, this.neglectMinutes = 0, this.balancedActions = 0});
  factory _CareStyle.fromJson(Map<String, dynamic> json) => _$CareStyleFromJson(json);

@override@JsonKey() final  int plays;
@override@JsonKey() final  int snacks;
@override@JsonKey() final  int timelyCleans;
@override@JsonKey() final  int neglectMinutes;
@override@JsonKey() final  int balancedActions;

/// Create a copy of CareStyle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareStyleCopyWith<_CareStyle> get copyWith => __$CareStyleCopyWithImpl<_CareStyle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareStyleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareStyle&&(identical(other.plays, plays) || other.plays == plays)&&(identical(other.snacks, snacks) || other.snacks == snacks)&&(identical(other.timelyCleans, timelyCleans) || other.timelyCleans == timelyCleans)&&(identical(other.neglectMinutes, neglectMinutes) || other.neglectMinutes == neglectMinutes)&&(identical(other.balancedActions, balancedActions) || other.balancedActions == balancedActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,plays,snacks,timelyCleans,neglectMinutes,balancedActions);
}

@override
String toString() {
    return 'CareStyle(plays: $plays, snacks: $snacks, timelyCleans: $timelyCleans, neglectMinutes: $neglectMinutes, balancedActions: $balancedActions)';
}


}

/// @nodoc
abstract mixin class _$CareStyleCopyWith<$Res> implements $CareStyleCopyWith<$Res> {
  factory _$CareStyleCopyWith(_CareStyle value, $Res Function(_CareStyle) _then) = __$CareStyleCopyWithImpl;
@override @useResult
$Res call({
 int plays, int snacks, int timelyCleans, int neglectMinutes, int balancedActions
});




}
/// @nodoc
class __$CareStyleCopyWithImpl<$Res>
    implements _$CareStyleCopyWith<$Res> {
  __$CareStyleCopyWithImpl(this._self, this._then);

  final _CareStyle _self;
  final $Res Function(_CareStyle) _then;

/// Create a copy of CareStyle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plays = null,Object? snacks = null,Object? timelyCleans = null,Object? neglectMinutes = null,Object? balancedActions = null,}) {
  return _then(_CareStyle(
plays: null == plays ? _self.plays : plays // ignore: cast_nullable_to_non_nullable
as int,snacks: null == snacks ? _self.snacks : snacks // ignore: cast_nullable_to_non_nullable
as int,timelyCleans: null == timelyCleans ? _self.timelyCleans : timelyCleans // ignore: cast_nullable_to_non_nullable
as int,neglectMinutes: null == neglectMinutes ? _self.neglectMinutes : neglectMinutes // ignore: cast_nullable_to_non_nullable
as int,balancedActions: null == balancedActions ? _self.balancedActions : balancedActions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
