// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoteLogEntry {

/// The log level, e.g. `error` or `fatal`.
 String get level;/// The (already redacted) log message.
 String get message;/// The stack trace as text, or an empty string when not available.
 String get stackTrace;/// The moment the event was logged, in UTC ISO-8601 format.
 String get timestamp;/// The Appwrite user ID of the current session, or an empty string
/// when the event happened while nobody was logged in.
 String get userId;
/// Create a copy of RemoteLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteLogEntryCopyWith<RemoteLogEntry> get copyWith => _$RemoteLogEntryCopyWithImpl<RemoteLogEntry>(this as RemoteLogEntry, _$identity);

  /// Serializes this RemoteLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteLogEntry&&(identical(other.level, level) || other.level == level)&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,message,stackTrace,timestamp,userId);

@override
String toString() {
  return 'RemoteLogEntry(level: $level, message: $message, stackTrace: $stackTrace, timestamp: $timestamp, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $RemoteLogEntryCopyWith<$Res>  {
  factory $RemoteLogEntryCopyWith(RemoteLogEntry value, $Res Function(RemoteLogEntry) _then) = _$RemoteLogEntryCopyWithImpl;
@useResult
$Res call({
 String level, String message, String stackTrace, String timestamp, String userId
});




}
/// @nodoc
class _$RemoteLogEntryCopyWithImpl<$Res>
    implements $RemoteLogEntryCopyWith<$Res> {
  _$RemoteLogEntryCopyWithImpl(this._self, this._then);

  final RemoteLogEntry _self;
  final $Res Function(RemoteLogEntry) _then;

/// Create a copy of RemoteLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? message = null,Object? stackTrace = null,Object? timestamp = null,Object? userId = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: null == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteLogEntry].
extension RemoteLogEntryPatterns on RemoteLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _RemoteLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  String message,  String stackTrace,  String timestamp,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteLogEntry() when $default != null:
return $default(_that.level,_that.message,_that.stackTrace,_that.timestamp,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  String message,  String stackTrace,  String timestamp,  String userId)  $default,) {final _that = this;
switch (_that) {
case _RemoteLogEntry():
return $default(_that.level,_that.message,_that.stackTrace,_that.timestamp,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  String message,  String stackTrace,  String timestamp,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _RemoteLogEntry() when $default != null:
return $default(_that.level,_that.message,_that.stackTrace,_that.timestamp,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RemoteLogEntry implements RemoteLogEntry {
  const _RemoteLogEntry({required this.level, required this.message, this.stackTrace = '', required this.timestamp, this.userId = ''});
  factory _RemoteLogEntry.fromJson(Map<String, dynamic> json) => _$RemoteLogEntryFromJson(json);

/// The log level, e.g. `error` or `fatal`.
@override final  String level;
/// The (already redacted) log message.
@override final  String message;
/// The stack trace as text, or an empty string when not available.
@override@JsonKey() final  String stackTrace;
/// The moment the event was logged, in UTC ISO-8601 format.
@override final  String timestamp;
/// The Appwrite user ID of the current session, or an empty string
/// when the event happened while nobody was logged in.
@override@JsonKey() final  String userId;

/// Create a copy of RemoteLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteLogEntryCopyWith<_RemoteLogEntry> get copyWith => __$RemoteLogEntryCopyWithImpl<_RemoteLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RemoteLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteLogEntry&&(identical(other.level, level) || other.level == level)&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,message,stackTrace,timestamp,userId);

@override
String toString() {
  return 'RemoteLogEntry(level: $level, message: $message, stackTrace: $stackTrace, timestamp: $timestamp, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$RemoteLogEntryCopyWith<$Res> implements $RemoteLogEntryCopyWith<$Res> {
  factory _$RemoteLogEntryCopyWith(_RemoteLogEntry value, $Res Function(_RemoteLogEntry) _then) = __$RemoteLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String level, String message, String stackTrace, String timestamp, String userId
});




}
/// @nodoc
class __$RemoteLogEntryCopyWithImpl<$Res>
    implements _$RemoteLogEntryCopyWith<$Res> {
  __$RemoteLogEntryCopyWithImpl(this._self, this._then);

  final _RemoteLogEntry _self;
  final $Res Function(_RemoteLogEntry) _then;

/// Create a copy of RemoteLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? message = null,Object? stackTrace = null,Object? timestamp = null,Object? userId = null,}) {
  return _then(_RemoteLogEntry(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: null == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
