// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsBackup _$SettingsBackupFromJson(Map<String, dynamic> json) =>
    _SettingsBackup(
      schemaVersion:
          (json['schemaVersion'] as num?)?.toInt() ??
          currentBackupSchemaVersion,
      exportedAt: json['exportedAt'] == null
          ? null
          : DateTime.parse(json['exportedAt'] as String),
      userSettings: json['userSettings'] == null
          ? const UserSettings()
          : UserSettings.fromJson(json['userSettings'] as Map<String, dynamic>),
      userData: json['userData'] == null
          ? const UserData()
          : UserData.fromJson(json['userData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsBackupToJson(_SettingsBackup instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'exportedAt': instance.exportedAt?.toIso8601String(),
      'userSettings': instance.userSettings,
      'userData': instance.userData,
    };
