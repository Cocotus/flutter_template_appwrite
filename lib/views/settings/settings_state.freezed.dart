// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsDraft {

/// Theme, language, accent, developer mode and display name.
 UserSettings get userSettings;
/// Create a copy of SettingsDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsDraftCopyWith<SettingsDraft> get copyWith => _$SettingsDraftCopyWithImpl<SettingsDraft>(this as SettingsDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsDraft&&(identical(other.userSettings, userSettings) || other.userSettings == userSettings));
}


@override
int get hashCode => Object.hash(runtimeType,userSettings);

@override
String toString() {
  return 'SettingsDraft(userSettings: $userSettings)';
}


}

/// @nodoc
abstract mixin class $SettingsDraftCopyWith<$Res>  {
  factory $SettingsDraftCopyWith(SettingsDraft value, $Res Function(SettingsDraft) _then) = _$SettingsDraftCopyWithImpl;
@useResult
$Res call({
 UserSettings userSettings
});


$UserSettingsCopyWith<$Res> get userSettings;

}
/// @nodoc
class _$SettingsDraftCopyWithImpl<$Res>
    implements $SettingsDraftCopyWith<$Res> {
  _$SettingsDraftCopyWithImpl(this._self, this._then);

  final SettingsDraft _self;
  final $Res Function(SettingsDraft) _then;

/// Create a copy of SettingsDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userSettings = null,}) {
  return _then(_self.copyWith(
userSettings: null == userSettings ? _self.userSettings : userSettings // ignore: cast_nullable_to_non_nullable
as UserSettings,
  ));
}
/// Create a copy of SettingsDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get userSettings {
  
  return $UserSettingsCopyWith<$Res>(_self.userSettings, (value) {
    return _then(_self.copyWith(userSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsDraft].
extension SettingsDraftPatterns on SettingsDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsDraft value)  $default,){
final _that = this;
switch (_that) {
case _SettingsDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsDraft value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserSettings userSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsDraft() when $default != null:
return $default(_that.userSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserSettings userSettings)  $default,) {final _that = this;
switch (_that) {
case _SettingsDraft():
return $default(_that.userSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserSettings userSettings)?  $default,) {final _that = this;
switch (_that) {
case _SettingsDraft() when $default != null:
return $default(_that.userSettings);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsDraft implements SettingsDraft {
  const _SettingsDraft({this.userSettings = const UserSettings()});
  

/// Theme, language, accent, developer mode and display name.
@override@JsonKey() final  UserSettings userSettings;

/// Create a copy of SettingsDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsDraftCopyWith<_SettingsDraft> get copyWith => __$SettingsDraftCopyWithImpl<_SettingsDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsDraft&&(identical(other.userSettings, userSettings) || other.userSettings == userSettings));
}


@override
int get hashCode => Object.hash(runtimeType,userSettings);

@override
String toString() {
  return 'SettingsDraft(userSettings: $userSettings)';
}


}

/// @nodoc
abstract mixin class _$SettingsDraftCopyWith<$Res> implements $SettingsDraftCopyWith<$Res> {
  factory _$SettingsDraftCopyWith(_SettingsDraft value, $Res Function(_SettingsDraft) _then) = __$SettingsDraftCopyWithImpl;
@override @useResult
$Res call({
 UserSettings userSettings
});


@override $UserSettingsCopyWith<$Res> get userSettings;

}
/// @nodoc
class __$SettingsDraftCopyWithImpl<$Res>
    implements _$SettingsDraftCopyWith<$Res> {
  __$SettingsDraftCopyWithImpl(this._self, this._then);

  final _SettingsDraft _self;
  final $Res Function(_SettingsDraft) _then;

/// Create a copy of SettingsDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userSettings = null,}) {
  return _then(_SettingsDraft(
userSettings: null == userSettings ? _self.userSettings : userSettings // ignore: cast_nullable_to_non_nullable
as UserSettings,
  ));
}

/// Create a copy of SettingsDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get userSettings {
  
  return $UserSettingsCopyWith<$Res>(_self.userSettings, (value) {
    return _then(_self.copyWith(userSettings: value));
  });
}
}

// dart format on
