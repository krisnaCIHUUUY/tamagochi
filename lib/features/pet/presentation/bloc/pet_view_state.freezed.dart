// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PetViewState {

/// `null` selama simpanan belum dimuat.
 PetState? get pet; Mood get mood; List<CareAction> get needed; PetReaction? get reaction;
/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetViewStateCopyWith<PetViewState> get copyWith => _$PetViewStateCopyWithImpl<PetViewState>(this as PetViewState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PetViewState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetViewState&&(identical(other.pet, _this.pet) || other.pet == _this.pet)&&(identical(other.mood, _this.mood) || other.mood == _this.mood)&&const DeepCollectionEquality().equals(other.needed, _this.needed)&&(identical(other.reaction, _this.reaction) || other.reaction == _this.reaction));
}


@override
int get hashCode {
  final _this = this as PetViewState;
  return Object.hash(runtimeType,_this.pet,_this.mood,const DeepCollectionEquality().hash(_this.needed),_this.reaction);
}

@override
String toString() {
  final _this = this as PetViewState;
  return 'PetViewState(pet: ${_this.pet}, mood: ${_this.mood}, needed: ${_this.needed}, reaction: ${_this.reaction})';
}


}

/// @nodoc
abstract mixin class $PetViewStateCopyWith<$Res>  {
  factory $PetViewStateCopyWith(PetViewState value, $Res Function(PetViewState) _then) = _$PetViewStateCopyWithImpl;
@useResult
$Res call({
 PetState? pet, Mood mood, List<CareAction> needed, PetReaction? reaction
});


$PetStateCopyWith<$Res>? get pet;$PetReactionCopyWith<$Res>? get reaction;

}
/// @nodoc
class _$PetViewStateCopyWithImpl<$Res>
    implements $PetViewStateCopyWith<$Res> {
  _$PetViewStateCopyWithImpl(this._self, this._then);

  final PetViewState _self;
  final $Res Function(PetViewState) _then;

/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pet = freezed,Object? mood = null,Object? needed = null,Object? reaction = freezed,}) {
  return _then(PetViewState(
pet: freezed == pet ? _self.pet : pet // ignore: cast_nullable_to_non_nullable
as PetState?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as Mood,needed: null == needed ? _self.needed : needed // ignore: cast_nullable_to_non_nullable
as List<CareAction>,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as PetReaction?,
  ));
}
/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetStateCopyWith<$Res>? get pet {
    if (_self.pet == null) {
    return null;
  }

  return $PetStateCopyWith<$Res>(_self.pet!, (value) {
    return _then(_self.copyWith(pet: value));
  });
}/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetReactionCopyWith<$Res>? get reaction {
    if (_self.reaction == null) {
    return null;
  }

  return $PetReactionCopyWith<$Res>(_self.reaction!, (value) {
    return _then(_self.copyWith(reaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [PetViewState].
extension PetViewStatePatterns on PetViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetViewState value)  $default,){
final _that = this;
switch (_that) {
case _PetViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetViewState value)?  $default,){
final _that = this;
switch (_that) {
case _PetViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PetState? pet,  Mood mood,  List<CareAction> needed,  PetReaction? reaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetViewState() when $default != null:
return $default(_that.pet,_that.mood,_that.needed,_that.reaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PetState? pet,  Mood mood,  List<CareAction> needed,  PetReaction? reaction)  $default,) {final _that = this;
switch (_that) {
case _PetViewState():
return $default(_that.pet,_that.mood,_that.needed,_that.reaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PetState? pet,  Mood mood,  List<CareAction> needed,  PetReaction? reaction)?  $default,) {final _that = this;
switch (_that) {
case _PetViewState() when $default != null:
return $default(_that.pet,_that.mood,_that.needed,_that.reaction);case _:
  return null;

}
}

}

/// @nodoc


class _PetViewState implements PetViewState {
  const _PetViewState({this.pet, this.mood = Mood.neutral,  List<CareAction> needed = const <CareAction>[], this.reaction}): _needed = needed;
  

/// `null` selama simpanan belum dimuat.
@override final  PetState? pet;
@override@JsonKey() final  Mood mood;
 final  List<CareAction> _needed;
@override@JsonKey() List<CareAction> get needed {
  if (_needed is EqualUnmodifiableListView) return _needed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needed);
}

@override final  PetReaction? reaction;

/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetViewStateCopyWith<_PetViewState> get copyWith => __$PetViewStateCopyWithImpl<_PetViewState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetViewState&&(identical(other.pet, pet) || other.pet == pet)&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other.needed, _needed)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pet,mood,const DeepCollectionEquality().hash(_needed),reaction);
}

@override
String toString() {
    return 'PetViewState(pet: $pet, mood: $mood, needed: $needed, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class _$PetViewStateCopyWith<$Res> implements $PetViewStateCopyWith<$Res> {
  factory _$PetViewStateCopyWith(_PetViewState value, $Res Function(_PetViewState) _then) = __$PetViewStateCopyWithImpl;
@override @useResult
$Res call({
 PetState? pet, Mood mood, List<CareAction> needed, PetReaction? reaction
});


@override $PetStateCopyWith<$Res>? get pet;@override $PetReactionCopyWith<$Res>? get reaction;

}
/// @nodoc
class __$PetViewStateCopyWithImpl<$Res>
    implements _$PetViewStateCopyWith<$Res> {
  __$PetViewStateCopyWithImpl(this._self, this._then);

  final _PetViewState _self;
  final $Res Function(_PetViewState) _then;

/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pet = freezed,Object? mood = null,Object? needed = null,Object? reaction = freezed,}) {
  return _then(_PetViewState(
pet: freezed == pet ? _self.pet : pet // ignore: cast_nullable_to_non_nullable
as PetState?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as Mood,needed: null == needed ? _self._needed : needed // ignore: cast_nullable_to_non_nullable
as List<CareAction>,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as PetReaction?,
  ));
}

/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetStateCopyWith<$Res>? get pet {
    if (_self.pet == null) {
    return null;
  }

  return $PetStateCopyWith<$Res>(_self.pet!, (value) {
    return _then(_self.copyWith(pet: value));
  });
}/// Create a copy of PetViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetReactionCopyWith<$Res>? get reaction {
    if (_self.reaction == null) {
    return null;
  }

  return $PetReactionCopyWith<$Res>(_self.reaction!, (value) {
    return _then(_self.copyWith(reaction: value));
  });
}
}

/// @nodoc
mixin _$PetReaction {

 CareAction get action; bool get accepted; int get seq;
/// Create a copy of PetReaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetReactionCopyWith<PetReaction> get copyWith => _$PetReactionCopyWithImpl<PetReaction>(this as PetReaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PetReaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetReaction&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.accepted, _this.accepted) || other.accepted == _this.accepted)&&(identical(other.seq, _this.seq) || other.seq == _this.seq));
}


@override
int get hashCode {
  final _this = this as PetReaction;
  return Object.hash(runtimeType,_this.action,_this.accepted,_this.seq);
}

@override
String toString() {
  final _this = this as PetReaction;
  return 'PetReaction(action: ${_this.action}, accepted: ${_this.accepted}, seq: ${_this.seq})';
}


}

/// @nodoc
abstract mixin class $PetReactionCopyWith<$Res>  {
  factory $PetReactionCopyWith(PetReaction value, $Res Function(PetReaction) _then) = _$PetReactionCopyWithImpl;
@useResult
$Res call({
 CareAction action, bool accepted, int seq
});




}
/// @nodoc
class _$PetReactionCopyWithImpl<$Res>
    implements $PetReactionCopyWith<$Res> {
  _$PetReactionCopyWithImpl(this._self, this._then);

  final PetReaction _self;
  final $Res Function(PetReaction) _then;

/// Create a copy of PetReaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? accepted = null,Object? seq = null,}) {
  return _then(PetReaction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CareAction,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PetReaction].
extension PetReactionPatterns on PetReaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetReaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetReaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetReaction value)  $default,){
final _that = this;
switch (_that) {
case _PetReaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetReaction value)?  $default,){
final _that = this;
switch (_that) {
case _PetReaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareAction action,  bool accepted,  int seq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetReaction() when $default != null:
return $default(_that.action,_that.accepted,_that.seq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareAction action,  bool accepted,  int seq)  $default,) {final _that = this;
switch (_that) {
case _PetReaction():
return $default(_that.action,_that.accepted,_that.seq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareAction action,  bool accepted,  int seq)?  $default,) {final _that = this;
switch (_that) {
case _PetReaction() when $default != null:
return $default(_that.action,_that.accepted,_that.seq);case _:
  return null;

}
}

}

/// @nodoc


class _PetReaction implements PetReaction {
  const _PetReaction({required this.action, required this.accepted, required this.seq});
  

@override final  CareAction action;
@override final  bool accepted;
@override final  int seq;

/// Create a copy of PetReaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetReactionCopyWith<_PetReaction> get copyWith => __$PetReactionCopyWithImpl<_PetReaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetReaction&&(identical(other.action, action) || other.action == action)&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.seq, seq) || other.seq == seq));
}


@override
int get hashCode {
    return Object.hash(runtimeType,action,accepted,seq);
}

@override
String toString() {
    return 'PetReaction(action: $action, accepted: $accepted, seq: $seq)';
}


}

/// @nodoc
abstract mixin class _$PetReactionCopyWith<$Res> implements $PetReactionCopyWith<$Res> {
  factory _$PetReactionCopyWith(_PetReaction value, $Res Function(_PetReaction) _then) = __$PetReactionCopyWithImpl;
@override @useResult
$Res call({
 CareAction action, bool accepted, int seq
});




}
/// @nodoc
class __$PetReactionCopyWithImpl<$Res>
    implements _$PetReactionCopyWith<$Res> {
  __$PetReactionCopyWithImpl(this._self, this._then);

  final _PetReaction _self;
  final $Res Function(_PetReaction) _then;

/// Create a copy of PetReaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? accepted = null,Object? seq = null,}) {
  return _then(_PetReaction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CareAction,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
