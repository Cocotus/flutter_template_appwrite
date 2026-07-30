import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_template_appwrite/models/user_data.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';

part 'settings_backup.freezed.dart';
part 'settings_backup.g.dart';

/// Everything this app stores about a user, as one document.
///
/// This is deliberately **the single serialization format** for three different
/// jobs:
///
/// * what the user exports and imports from the settings page,
/// * what is copied to / pasted from the clipboard,
/// * what is synced with Appwrite when a build ships with `HAS_LOGIN=true`.
///
/// Keeping them identical is the point. Three formats would mean three
/// serializers, three sets of migration code and three ways to be subtly
/// incompatible; with one, "export, reinstall, import" and "sign in on another
/// machine" exercise the same code path.
///
/// Note that the two halves take **different routes** into Appwrite —
/// [userSettings] into the account-preferences object, [userData] into a
/// Storage file (see `CloudSyncService`) — and are reunited here. The document
/// is the app's view of the data; the split is a storage detail.
///
/// [schemaVersion] is what makes that safe over time: a future version that
/// renames or restructures a field can branch on it in [fromJson] instead of
/// silently dropping data. Bump it whenever the *meaning* of a field changes,
/// not when a field is merely added — every field has a default, so additions
/// are already backward compatible.
@freezed
abstract class SettingsBackup with _$SettingsBackup {
  /// Creates a [SettingsBackup].
  const factory SettingsBackup({
    /// Layout version of this document.
    @Default(currentBackupSchemaVersion) int schemaVersion,

    /// When this document was produced, shown to the user on import.
    DateTime? exportedAt,

    /// App settings: theme, language, accent, display name.
    @Default(UserSettings()) UserSettings userSettings,

    /// Everything the user created inside the app.
    @Default(UserData()) UserData userData,
  }) = _SettingsBackup;

  /// Creates a [SettingsBackup] from a JSON map.
  factory SettingsBackup.fromJson(Map<String, dynamic> json) =>
      _$SettingsBackupFromJson(json);
}

/// The current [SettingsBackup.schemaVersion].
const int currentBackupSchemaVersion = 1;
