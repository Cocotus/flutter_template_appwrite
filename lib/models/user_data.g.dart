// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserData _$UserDataFromJson(Map<String, dynamic> json) => _UserData(
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  notes:
      (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$UserDataToJson(_UserData instance) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'notes': instance.notes,
};
