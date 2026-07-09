import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_data.dart';

/// In-memory [DatabaseService] used when demo mode is active.
///
/// Stores everything in fields for the lifetime of the app run, seeded from
/// [demoUserSettings]. Saves succeed and are reflected back on the next read,
/// so settings changes feel real inside a demo session (they are simply not
/// persisted anywhere and reset on restart).
///
/// Selected only behind the compile-time [AppConfig.demoModeAllowed] gate
/// (see `databaseServiceProvider`).
class DemoDatabaseService implements DatabaseService {
  UserSettings _settings = demoUserSettings;

  @override
  Future<UserSettings?> loadUserSettings({required String userId}) async {
    return _settings;
  }

  @override
  Future<void> saveUserSettings({
    required String userId,
    required UserSettings settings,
  }) async {
    _settings = settings;
  }

  @override
  Future<void> writeLogEntry(RemoteLogEntry entry) async {
    // Remote logging is a no-op in demo mode.
  }
}
