import 'package:flutter_template_appwrite/models/settings_backup.dart';
import 'package:flutter_template_appwrite/services/cloud_sync/cloud_sync_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_data.dart';

/// In-memory [CloudSyncService] used when demo mode is active.
///
/// Holds one [SettingsBackup] in a field for the lifetime of the app run, seeded
/// from [demoUserSettings]. A push is reflected back by the next pull, so
/// "save, log out, log back in" behaves exactly as it does against a real
/// Appwrite project — the document is simply not persisted across restarts.
///
/// Selected only behind the compile-time `AppConfig.demoModeAllowed` gate (see
/// `cloudSyncServiceProvider`).
class DemoCloudSyncService implements CloudSyncService {
  SettingsBackup _document = const SettingsBackup(userSettings: demoUserSettings);

  @override
  Future<SettingsBackup> pull({required String userId}) async {
    return _document;
  }

  @override
  Future<void> push({
    required String userId,
    required SettingsBackup backup,
  }) async {
    _document = backup;
  }
}
