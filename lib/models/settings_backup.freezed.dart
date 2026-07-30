// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsBackup {

/// Layout version of this document.
 int get schemaVersion;/// When this document was produced, shown to the user on import.
 DateTime? get exportedAt;/// App settings: theme, language, accent, display name.
 UserSettings get userSettings;/// Everything the user created inside the app.
 UserData get userData;
/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsBackupCopyWith<SettingsBackup> get copyWith => _$SettingsBackupCopyWithImpl<SettingsBackup>(this as SettingsBackup, _$identity);

  /// Serializes this SettingsBackup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsBackup&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.userSettings, userSettings) || other.userSettings == userSettings)&&(identical(other.userData, userData) || other.userData == userData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,exportedAt,userSettings,userData);

@override
String toString() {
  return 'SettingsBackup(schemaVersion: $schemaVersion, exportedAt: $exportedAt, userSettings: $userSettings, userData: $userData)';
}


}

/// @nodoc
abstract mixin class $SettingsBackupCopyWith<$Res>  {
  factory $SettingsBackupCopyWith(SettingsBackup value, $Res Function(SettingsBackup) _then) = _$SettingsBackupCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, DateTime? exportedAt, UserSettings userSettings, UserData userData
});


$UserSettingsCopyWith<$Res> get userSettings;$UserDataCopyWith<$Res> get userData;

}
/// @nodoc
class _$SettingsBackupCopyWithImpl<$Res>
    implements $SettingsBackupCopyWith<$Res> {
  _$SettingsBackupCopyWithImpl(this._self, this._then);

  final SettingsBackup _self;
  final $Res Function(SettingsBackup) _then;

/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? exportedAt = freezed,Object? userSettings = null,Object? userData = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userSettings: null == userSettings ? _self.userSettings : userSettings // ignore: cast_nullable_to_non_nullable
as UserSettings,userData: null == userData ? _self.userData : userData // ignore: cast_nullable_to_non_nullable
as UserData,
  ));
}
/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get userSettings {
  
  return $UserSettingsCopyWith<$Res>(_self.userSettings, (value) {
    return _then(_self.copyWith(userSettings: value));
  });
}/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res> get userData {
  
  return $UserDataCopyWith<$Res>(_self.userData, (value) {
    return _then(_self.copyWith(userData: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsBackup].
extension SettingsBackupPatterns on SettingsBackup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsBackup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsBackup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsBackup value)  $default,){
final _that = this;
switch (_that) {
case _SettingsBackup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsBackup value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsBackup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  DateTime? exportedAt,  UserSettings userSettings,  UserData userData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsBackup() when $default != null:
return $default(_that.schemaVersion,_that.exportedAt,_that.userSettings,_that.userData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  DateTime? exportedAt,  UserSettings userSettings,  UserData userData)  $default,) {final _that = this;
switch (_that) {
case _SettingsBackup():
return $default(_that.schemaVersion,_that.exportedAt,_that.userSettings,_that.userData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  DateTime? exportedAt,  UserSettings userSettings,  UserData userData)?  $default,) {final _that = this;
switch (_that) {
case _SettingsBackup() when $default != null:
return $default(_that.schemaVersion,_that.exportedAt,_that.userSettings,_that.userData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsBackup implements SettingsBackup {
  const _SettingsBackup({this.schemaVersion = currentBackupSchemaVersion, this.exportedAt, this.userSettings = const UserSettings(), this.userData = const UserData()});
  factory _SettingsBackup.fromJson(Map<String, dynamic> json) => _$SettingsBackupFromJson(json);

/// Layout version of this document.
@override@JsonKey() final  int schemaVersion;
/// When this document was produced, shown to the user on import.
@override final  DateTime? exportedAt;
/// App settings: theme, language, accent, display name.
@override@JsonKey() final  UserSettings userSettings;
/// Everything the user created inside the app.
@override@JsonKey() final  UserData userData;

/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsBackupCopyWith<_SettingsBackup> get copyWith => __$SettingsBackupCopyWithImpl<_SettingsBackup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsBackupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsBackup&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.userSettings, userSettings) || other.userSettings == userSettings)&&(identical(other.userData, userData) || other.userData == userData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,exportedAt,userSettings,userData);

@override
String toString() {
  return 'SettingsBackup(schemaVersion: $schemaVersion, exportedAt: $exportedAt, userSettings: $userSettings, userData: $userData)';
}


}

/// @nodoc
abstract mixin class _$SettingsBackupCopyWith<$Res> implements $SettingsBackupCopyWith<$Res> {
  factory _$SettingsBackupCopyWith(_SettingsBackup value, $Res Function(_SettingsBackup) _then) = __$SettingsBackupCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, DateTime? exportedAt, UserSettings userSettings, UserData userData
});


@override $UserSettingsCopyWith<$Res> get userSettings;@override $UserDataCopyWith<$Res> get userData;

}
/// @nodoc
class __$SettingsBackupCopyWithImpl<$Res>
    implements _$SettingsBackupCopyWith<$Res> {
  __$SettingsBackupCopyWithImpl(this._self, this._then);

  final _SettingsBackup _self;
  final $Res Function(_SettingsBackup) _then;

/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? exportedAt = freezed,Object? userSettings = null,Object? userData = null,}) {
  return _then(_SettingsBackup(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userSettings: null == userSettings ? _self.userSettings : userSettings // ignore: cast_nullable_to_non_nullable
as UserSettings,userData: null == userData ? _self.userData : userData // ignore: cast_nullable_to_non_nullable
as UserData,
  ));
}

/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get userSettings {
  
  return $UserSettingsCopyWith<$Res>(_self.userSettings, (value) {
    return _then(_self.copyWith(userSettings: value));
  });
}/// Create a copy of SettingsBackup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res> get userData {
  
  return $UserDataCopyWith<$Res>(_self.userData, (value) {
    return _then(_self.copyWith(userData: value));
  });
}
}

// dart format on
