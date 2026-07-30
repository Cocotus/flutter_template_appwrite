import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/models/settings_backup.dart';
import 'package:flutter_template_appwrite/models/user_data.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/appwrite_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_cloud_sync_service.dart';
import 'package:flutter_template_appwrite/services/demo_mode.dart';

part 'cloud_sync_service.g.dart';

/// Reads and writes the user's whole configuration in Appwrite.
///
/// This is the ONLY place in the app that stores user content remotely, and it
/// has exactly two methods: [pull] and [push]. There is no partial update, no
/// per-field write and no query anywhere — the document is small, the client is
/// its only writer, and nothing ever searches across users.
///
/// ## Two stores, chosen by size
///
/// Appwrite offers two mechanisms that fit an app like this, and the split
/// between them is purely about how big the data can get:
///
/// * **Account preferences** (`account.getPrefs` / `account.updatePrefs`) hold
///   [UserSettings]. Preferences are a per-user JSON object that Appwrite
///   attaches to the account itself: no table to create, no columns to declare,
///   no permissions to configure, and it is exactly what the Appwrite docs
///   recommend for "theme choice, language selection" and the like. The limit
///   is **64 kB per user**, and an oversized write throws — see
///   [prefsSizeLimitBytes].
/// * **Storage** holds [UserData] — everything the user creates. That document
///   grows with use and would eventually blow the preferences limit. It is
///   written as ONE file per user whose **file ID equals the Appwrite user
///   ID**, so reading it back is a direct fetch rather than a query.
///
/// ## Why not a table
///
/// Earlier versions of this template mapped `UserSettings` field-per-column
/// into a `user_settings` table. That makes every new setting a console change
/// that has to land *before* the client ships — Appwrite rejects a write
/// containing an undeclared attribute outright, so a forgotten column is not a
/// missing value but a failed save. Preferences have no schema to forget, and a
/// bucket has no size ceiling to design around. Neither half of the data is ever
/// queried across users, which is the only thing a table would have bought.
///
/// ## When this runs
///
/// Never automatically. [CloudSync] calls [pull] once after login and [push]
/// when the user presses Save in the settings page or logs out. Every ordinary
/// change is written only to `shared_preferences` and never touches the network.
class CloudSyncService {
  /// Creates a [CloudSyncService] on top of the Appwrite Account and Storage
  /// APIs (callers pass them as `account:` and `storage:`).
  CloudSyncService({required this._account, required this._storage});

  final Account _account;
  final Storage _storage;

  /// Preferences key holding the serialized [UserSettings].
  static const String settingsPrefsKey = 'userSettings';

  /// File name used for the user-data document inside the bucket.
  ///
  /// Cosmetic only — the file is addressed by its ID (the user ID), never by
  /// name. It exists so the file is recognizable in the Appwrite console.
  static const String userDataFileName = 'userdata.json';

  /// Appwrite's hard limit on the size of the preferences object.
  ///
  /// Exceeding it makes `updatePrefs` fail, so [push] checks first and reports a
  /// precise error instead of a generic Appwrite failure. If your settings model
  /// ever approaches this, that is the signal that the field which grew belongs
  /// in [UserData] instead.
  static const int prefsSizeLimitBytes = 64 * 1024;

  /// Loads the stored configuration of the user with the given [userId].
  ///
  /// Every part degrades independently: a missing or unreadable preferences
  /// entry yields default settings, and a missing user-data file yields an empty
  /// [UserData]. A first login after registration therefore returns a
  /// fully-default document rather than throwing.
  Future<SettingsBackup> pull({required String userId}) async {
    final appwrite_models.Preferences preferences = await _account.getPrefs();

    final UserSettings userSettings = _decodeSettings(
      preferences.data[settingsPrefsKey],
    );
    final UserData userData = await _readUserDataFile(userId: userId);

    return SettingsBackup(
      exportedAt: DateTime.now(),
      userSettings: userSettings,
      userData: userData,
    );
  }

  /// Writes [backup] back for the user with the given [userId].
  ///
  /// Preferences are replaced wholesale (that is how `updatePrefs` works), and
  /// the user-data file is replaced by deleting and re-creating it: Appwrite's
  /// `updateFile` changes only a file's name and permissions, never its
  /// contents.
  Future<void> push({
    required String userId,
    required SettingsBackup backup,
  }) async {
    final Map<String, String> preferences = <String, String>{
      settingsPrefsKey: jsonEncode(backup.userSettings.toJson()),
    };

    final int preferencesSize = utf8.encode(jsonEncode(preferences)).length;
    if (preferencesSize > prefsSizeLimitBytes) {
      throw StateError(
        'Settings are $preferencesSize bytes, over the Appwrite preferences '
        'limit of $prefsSizeLimitBytes bytes',
      );
    }

    await _account.updatePrefs(prefs: preferences);
    await _writeUserDataFile(userId: userId, data: backup.userData);
  }

  // Reads the user-data file, or returns an empty document when there is none
  // yet (the normal state for a user who has never synced).
  Future<UserData> _readUserDataFile({required String userId}) async {
    try {
      final Uint8List bytes = await _storage.getFileDownload(
        bucketId: AppConfig.appwriteUserDataBucketId,
        fileId: userId,
      );

      final String jsonText = utf8.decode(bytes);
      if (jsonText.trim().isEmpty) {
        return const UserData();
      }

      final Object? decoded = jsonDecode(jsonText);
      if (decoded is! Map<String, dynamic>) {
        return const UserData();
      }
      return UserData.fromJson(decoded);
    } on AppwriteException catch (error) {
      // 404 means "nothing synced yet" — a normal state, not a failure.
      if (error.code == 404) {
        return const UserData();
      }
      rethrow;
    } on FormatException {
      // A corrupt remote file must not make signing in fail; the local copy is
      // still there and the next push overwrites the bad one.
      return const UserData();
    }
  }

  // Replaces the user-data file. Appwrite files are content-immutable, so the
  // old one is deleted first.
  Future<void> _writeUserDataFile({
    required String userId,
    required UserData data,
  }) async {
    await _deleteUserDataFile(userId: userId);

    final Uint8List bytes = Uint8List.fromList(
      utf8.encode(jsonEncode(data.toJson())),
    );

    await _storage.createFile(
      bucketId: AppConfig.appwriteUserDataBucketId,
      fileId: userId,
      file: InputFile.fromBytes(bytes: bytes, filename: userDataFileName),
      permissions: <String>[
        Permission.read(Role.user(userId)),
        Permission.update(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }

  Future<void> _deleteUserDataFile({required String userId}) async {
    try {
      await _storage.deleteFile(
        bucketId: AppConfig.appwriteUserDataBucketId,
        fileId: userId,
      );
    } on AppwriteException catch (error) {
      // 404 means there was nothing to replace — the first push of a new user.
      if (error.code == 404) {
        return;
      }
      rethrow;
    }
  }

  // Preferences values are stored as JSON strings, so that a nested object can
  // never be reshaped by the SDK's own serialization on the way in or out.
  // Anything unreadable is treated as absent.
  UserSettings _decodeSettings(Object? stored) {
    if (stored is! String || stored.trim().isEmpty) {
      return const UserSettings();
    }

    try {
      final Object? decoded = jsonDecode(stored);
      if (decoded is! Map<String, dynamic>) {
        return const UserSettings();
      }
      return UserSettings.fromJson(decoded);
    } on FormatException {
      return const UserSettings();
    }
  }
}

/// Provides the app-wide [CloudSyncService].
///
/// Only ever read while a user is logged in (see [CloudSync]); in a build with
/// `HAS_LOGIN=false` reading it throws through `appwriteServiceProvider`.
///
/// When demo mode is active it returns a [DemoCloudSyncService] keeping the
/// document in memory, so the whole sync path works without Appwrite.
@Riverpod(keepAlive: true)
CloudSyncService cloudSyncService(Ref ref) {
  if (ref.watch(demoModeProvider)) {
    return DemoCloudSyncService();
  }

  final AppwriteService appwrite = ref.watch(appwriteServiceProvider);
  return CloudSyncService(
    account: appwrite.account,
    storage: appwrite.storage,
  );
}
