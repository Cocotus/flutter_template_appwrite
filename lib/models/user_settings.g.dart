// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      languageCode: json['languageCode'] as String? ?? 'en',
      sidebarCollapsed: json['sidebarCollapsed'] as bool? ?? false,
      developerMode: json['developerMode'] as bool? ?? false,
      displayName: json['displayName'] as String? ?? '',
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'languageCode': instance.languageCode,
      'sidebarCollapsed': instance.sidebarCollapsed,
      'developerMode': instance.developerMode,
      'displayName': instance.displayName,
    };
