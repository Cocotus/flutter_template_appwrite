// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoteLogEntry _$RemoteLogEntryFromJson(Map<String, dynamic> json) =>
    _RemoteLogEntry(
      level: json['level'] as String,
      message: json['message'] as String,
      stackTrace: json['stackTrace'] as String? ?? '',
      timestamp: json['timestamp'] as String,
      userId: json['userId'] as String? ?? '',
    );

Map<String, dynamic> _$RemoteLogEntryToJson(_RemoteLogEntry instance) =>
    <String, dynamic>{
      'level': instance.level,
      'message': instance.message,
      'stackTrace': instance.stackTrace,
      'timestamp': instance.timestamp,
      'userId': instance.userId,
    };
