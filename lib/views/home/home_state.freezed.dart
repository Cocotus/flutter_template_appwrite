// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeDemoState {

/// Value of the demo text field.
 String get displayName;/// Value of the demo switch.
 bool get notificationsEnabled;/// Value of the demo dropdown.
 String get role;
/// Create a copy of HomeDemoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDemoStateCopyWith<HomeDemoState> get copyWith => _$HomeDemoStateCopyWithImpl<HomeDemoState>(this as HomeDemoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDemoState&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,notificationsEnabled,role);

@override
String toString() {
  return 'HomeDemoState(displayName: $displayName, notificationsEnabled: $notificationsEnabled, role: $role)';
}


}

/// @nodoc
abstract mixin class $HomeDemoStateCopyWith<$Res>  {
  factory $HomeDemoStateCopyWith(HomeDemoState value, $Res Function(HomeDemoState) _then) = _$HomeDemoStateCopyWithImpl;
@useResult
$Res call({
 String displayName, bool notificationsEnabled, String role
});




}
/// @nodoc
class _$HomeDemoStateCopyWithImpl<$Res>
    implements $HomeDemoStateCopyWith<$Res> {
  _$HomeDemoStateCopyWithImpl(this._self, this._then);

  final HomeDemoState _self;
  final $Res Function(HomeDemoState) _then;

/// Create a copy of HomeDemoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? notificationsEnabled = null,Object? role = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDemoState].
extension HomeDemoStatePatterns on HomeDemoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDemoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDemoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDemoState value)  $default,){
final _that = this;
switch (_that) {
case _HomeDemoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDemoState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDemoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  bool notificationsEnabled,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDemoState() when $default != null:
return $default(_that.displayName,_that.notificationsEnabled,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  bool notificationsEnabled,  String role)  $default,) {final _that = this;
switch (_that) {
case _HomeDemoState():
return $default(_that.displayName,_that.notificationsEnabled,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  bool notificationsEnabled,  String role)?  $default,) {final _that = this;
switch (_that) {
case _HomeDemoState() when $default != null:
return $default(_that.displayName,_that.notificationsEnabled,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _HomeDemoState implements HomeDemoState {
  const _HomeDemoState({this.displayName = '', this.notificationsEnabled = true, this.role = 'user'});
  

/// Value of the demo text field.
@override@JsonKey() final  String displayName;
/// Value of the demo switch.
@override@JsonKey() final  bool notificationsEnabled;
/// Value of the demo dropdown.
@override@JsonKey() final  String role;

/// Create a copy of HomeDemoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDemoStateCopyWith<_HomeDemoState> get copyWith => __$HomeDemoStateCopyWithImpl<_HomeDemoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDemoState&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,notificationsEnabled,role);

@override
String toString() {
  return 'HomeDemoState(displayName: $displayName, notificationsEnabled: $notificationsEnabled, role: $role)';
}


}

/// @nodoc
abstract mixin class _$HomeDemoStateCopyWith<$Res> implements $HomeDemoStateCopyWith<$Res> {
  factory _$HomeDemoStateCopyWith(_HomeDemoState value, $Res Function(_HomeDemoState) _then) = __$HomeDemoStateCopyWithImpl;
@override @useResult
$Res call({
 String displayName, bool notificationsEnabled, String role
});




}
/// @nodoc
class __$HomeDemoStateCopyWithImpl<$Res>
    implements _$HomeDemoStateCopyWith<$Res> {
  __$HomeDemoStateCopyWithImpl(this._self, this._then);

  final _HomeDemoState _self;
  final $Res Function(_HomeDemoState) _then;

/// Create a copy of HomeDemoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? notificationsEnabled = null,Object? role = null,}) {
  return _then(_HomeDemoState(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
