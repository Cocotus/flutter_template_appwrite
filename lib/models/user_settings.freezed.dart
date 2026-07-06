// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {

/// Whether the app uses the dark Material 3 color scheme.
 bool get isDarkMode;/// The active UI language code, e.g. `en` or `de`.
 String get languageCode;/// Whether the user manually collapsed the navigation sidebar.
 bool get sidebarCollapsed;/// Whether developer mode is enabled.
///
/// Developer mode reveals the "Logs" entry in the sidebar so the user
/// can inspect live Talker logs inside the app (always visible in
/// debug builds regardless of this flag).
 bool get developerMode;/// Optional display name shown in the profile and sidebar avatar.
 String get displayName;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.sidebarCollapsed, sidebarCollapsed) || other.sidebarCollapsed == sidebarCollapsed)&&(identical(other.developerMode, developerMode) || other.developerMode == developerMode)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDarkMode,languageCode,sidebarCollapsed,developerMode,displayName);

@override
String toString() {
  return 'UserSettings(isDarkMode: $isDarkMode, languageCode: $languageCode, sidebarCollapsed: $sidebarCollapsed, developerMode: $developerMode, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 bool isDarkMode, String languageCode, bool sidebarCollapsed, bool developerMode, String displayName
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDarkMode = null,Object? languageCode = null,Object? sidebarCollapsed = null,Object? developerMode = null,Object? displayName = null,}) {
  return _then(_self.copyWith(
isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,sidebarCollapsed: null == sidebarCollapsed ? _self.sidebarCollapsed : sidebarCollapsed // ignore: cast_nullable_to_non_nullable
as bool,developerMode: null == developerMode ? _self.developerMode : developerMode // ignore: cast_nullable_to_non_nullable
as bool,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isDarkMode,  String languageCode,  bool sidebarCollapsed,  bool developerMode,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.isDarkMode,_that.languageCode,_that.sidebarCollapsed,_that.developerMode,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isDarkMode,  String languageCode,  bool sidebarCollapsed,  bool developerMode,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.isDarkMode,_that.languageCode,_that.sidebarCollapsed,_that.developerMode,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isDarkMode,  String languageCode,  bool sidebarCollapsed,  bool developerMode,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.isDarkMode,_that.languageCode,_that.sidebarCollapsed,_that.developerMode,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettings implements UserSettings {
  const _UserSettings({this.isDarkMode = false, this.languageCode = 'en', this.sidebarCollapsed = false, this.developerMode = false, this.displayName = ''});
  factory _UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

/// Whether the app uses the dark Material 3 color scheme.
@override@JsonKey() final  bool isDarkMode;
/// The active UI language code, e.g. `en` or `de`.
@override@JsonKey() final  String languageCode;
/// Whether the user manually collapsed the navigation sidebar.
@override@JsonKey() final  bool sidebarCollapsed;
/// Whether developer mode is enabled.
///
/// Developer mode reveals the "Logs" entry in the sidebar so the user
/// can inspect live Talker logs inside the app (always visible in
/// debug builds regardless of this flag).
@override@JsonKey() final  bool developerMode;
/// Optional display name shown in the profile and sidebar avatar.
@override@JsonKey() final  String displayName;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.sidebarCollapsed, sidebarCollapsed) || other.sidebarCollapsed == sidebarCollapsed)&&(identical(other.developerMode, developerMode) || other.developerMode == developerMode)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDarkMode,languageCode,sidebarCollapsed,developerMode,displayName);

@override
String toString() {
  return 'UserSettings(isDarkMode: $isDarkMode, languageCode: $languageCode, sidebarCollapsed: $sidebarCollapsed, developerMode: $developerMode, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isDarkMode, String languageCode, bool sidebarCollapsed, bool developerMode, String displayName
});




}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDarkMode = null,Object? languageCode = null,Object? sidebarCollapsed = null,Object? developerMode = null,Object? displayName = null,}) {
  return _then(_UserSettings(
isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,sidebarCollapsed: null == sidebarCollapsed ? _self.sidebarCollapsed : sidebarCollapsed // ignore: cast_nullable_to_non_nullable
as bool,developerMode: null == developerMode ? _self.developerMode : developerMode // ignore: cast_nullable_to_non_nullable
as bool,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
