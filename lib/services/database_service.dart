import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/appwrite_service.dart';

part 'database_service.g.dart';

/// Wraps the Appwrite TablesDB API for this app's data access.
///
/// Data model (see README for the console setup):
/// - Table `user_settings`: exactly one row per user, and the ROW ID EQUALS
///   THE APPWRITE USER ID. That makes lookups a direct `getRow` without any
///   query, and guarantees a single settings row per user.
/// - Each row carries owner-only permissions (read/update/delete for
///   `Role.user(userId)`), so users can only ever touch their own settings.
/// - Table `logs` (optional): receives error/fatal log entries when remote
///   logging is enabled.
///
/// Controllers depend on this service — never on the raw Appwrite client —
/// so it can be replaced with a fake in tests (see `test/fakes/`).
class DatabaseService {
  /// Creates a [DatabaseService] that talks to the given TablesDB API
  /// (callers pass it as `tablesDB:`).
  DatabaseService({required this._tablesDB});

  final TablesDB _tablesDB;

  /// Loads the settings row of the user with the given [userId].
  ///
  /// Returns `null` when no row exists yet (Appwrite responds with 404),
  /// which happens on the first login of a freshly registered user before
  /// defaults were created.
  Future<UserSettings?> loadUserSettings({required String userId}) async {
    try {
      final appwrite_models.Row row = await _tablesDB.getRow(
        databaseId: AppConfig.appwriteDatabaseId,
        tableId: AppConfig.userSettingsTableId,
        rowId: userId,
      );

      // `row.data` contains the plain column values of the row.
      final UserSettings settings = UserSettings.fromJson(row.data);
      return settings;
    } on AppwriteException catch (error) {
      // 404 means "no settings row yet" — a normal state, not a failure.
      if (error.code == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// Creates or updates the settings row of the user with the given
  /// [userId].
  ///
  /// Uses `upsertRow` so the very first save (right after registration) and
  /// every later settings change share one code path. The permissions list
  /// restricts the row to its owner.
  Future<void> saveUserSettings({
    required String userId,
    required UserSettings settings,
  }) async {
    await _tablesDB.upsertRow(
      databaseId: AppConfig.appwriteDatabaseId,
      tableId: AppConfig.userSettingsTableId,
      rowId: userId,
      data: settings.toJson(),
      permissions: <String>[
        Permission.read(Role.user(userId)),
        Permission.update(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }

  /// Writes one log [entry] into the `logs` table.
  ///
  /// Only used by `AppwriteLogSink` when remote logging is enabled.
  Future<void> writeLogEntry(RemoteLogEntry entry) async {
    await _tablesDB.createRow(
      databaseId: AppConfig.appwriteDatabaseId,
      tableId: AppConfig.logsTableId,
      rowId: ID.unique(),
      data: entry.toJson(),
    );
  }
}

/// Provides the app-wide [DatabaseService] instance.
///
/// Kept alive because data access is used across the whole app. Tests
/// override this provider with a fake, e.g.
/// `databaseServiceProvider.overrideWithValue(FakeDatabaseService())`.
@Riverpod(keepAlive: true)
DatabaseService databaseService(Ref ref) {
  final AppwriteService appwrite = ref.watch(appwriteServiceProvider);
  return DatabaseService(tablesDB: appwrite.tablesDB);
}
