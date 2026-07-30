import 'dart:async';

import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/models/settings_backup.dart';
import 'package:flutter_template_appwrite/services/auth/current_user.dart';
import 'package:flutter_template_appwrite/services/backup_service.dart';
import 'package:flutter_template_appwrite/services/cloud_sync/cloud_sync_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

part 'cloud_sync_controller.g.dart';

/// Owns the three moments at which this app talks to Appwrite.
///
/// The local `shared_preferences` copy is the app's live, authoritative store:
/// every settings change and every piece of user content is written there
/// immediately and the network is not involved. Appwrite is a sync layer on top,
/// and it is touched at exactly three points, all of them things the user did on
/// purpose:
///
/// 1. **[pull] after login** — the remote copy replaces the local one.
/// 2. **[push] when Save is pressed** in the settings page, or via the explicit
///    "Sync now" button next to it.
/// 3. **[push] on logout** — so the session's work is not left behind on the
///    device.
///
/// Nothing here runs on a timer, a listener or a widget event. That is the whole
/// point: a maintainer reading a bug report about "my data did not sync" has
/// three places to look, not an event graph.
///
/// The state is the timestamp of the last successful sync (`null` when this
/// device never synced), wrapped in an `AsyncValue` so the settings page can
/// show progress and errors with the same handling it uses everywhere else.
///
/// **Conflict model:** last write wins, and [pull] replaces the local copy
/// wholesale. Because a logout always pushes first, the ordinary
/// "work, log out, sign in elsewhere" flow carries everything across. Signing in
/// on a device that has unsynced local changes discards them in favour of the
/// remote copy — the trade for not maintaining a merge algorithm, and the reason
/// [pull] logs what it replaced.
@Riverpod(keepAlive: true)
class CloudSync extends _$CloudSync {
  @override
  FutureOr<DateTime?> build() {
    final PreferencesService preferences = ref.read(preferencesServiceProvider);
    return preferences.readLastSyncedAt();
  }

  /// Whether syncing is possible right now.
  ///
  /// False in a build without login, and false while nobody is signed in —
  /// there is no user to key the remote copy on. The settings page hides its
  /// sync row entirely in that case rather than offering a button that cannot
  /// work.
  bool get isAvailable {
    if (AppConfig.hasLogin == false) {
      return false;
    }
    return _currentUserIdOrNull() != null;
  }

  /// Replaces the local configuration with the one stored in Appwrite.
  ///
  /// Called once right after a successful login. Does nothing when syncing is
  /// unavailable, so callers do not have to guard.
  Future<void> pull() async {
    if (isAvailable == false) {
      return;
    }

    final LoggerService logger = ref.read(loggerServiceProvider);
    state = const AsyncValue<DateTime?>.loading();

    try {
      final String userId = _requireCurrentUserId();
      final CloudSyncService cloudSync = ref.read(cloudSyncServiceProvider);
      final SettingsBackup remote = await cloudSync.pull(userId: userId);

      final BackupService backup = ref.read(backupServiceProvider);
      await backup.apply(remote);

      logger.info('Pulled configuration from Appwrite');
      state = AsyncValue<DateTime?>.data(await _recordSync());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Pulling from Appwrite failed');
      state = AsyncValue<DateTime?>.error(error, stackTrace);
    }
  }

  /// Writes the current local configuration to Appwrite.
  ///
  /// Called by the settings Save button, the "Sync now" button and the logout
  /// path. Does nothing when syncing is unavailable.
  Future<void> push() async {
    if (isAvailable == false) {
      return;
    }

    final LoggerService logger = ref.read(loggerServiceProvider);
    state = const AsyncValue<DateTime?>.loading();

    try {
      final String userId = _requireCurrentUserId();
      final BackupService backup = ref.read(backupServiceProvider);
      final CloudSyncService cloudSync = ref.read(cloudSyncServiceProvider);

      await cloudSync.push(userId: userId, backup: backup.current());

      logger.info('Pushed configuration to Appwrite');
      state = AsyncValue<DateTime?>.data(await _recordSync());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Pushing to Appwrite failed');
      state = AsyncValue<DateTime?>.error(error, stackTrace);
    }
  }

  /// Forgets this device's sync history (used on logout).
  Future<void> forgetLastSync() async {
    final PreferencesService preferences = ref.read(preferencesServiceProvider);
    await preferences.clearLastSyncedAt();
    state = const AsyncValue<DateTime?>.data(null);
  }

  // Stores and returns the moment of a sync that just succeeded.
  Future<DateTime> _recordSync() async {
    final DateTime now = DateTime.now();
    final PreferencesService preferences = ref.read(preferencesServiceProvider);
    await preferences.writeLastSyncedAt(now);
    return now;
  }

  String? _currentUserIdOrNull() {
    final appwrite_models.User? user = ref.read(currentUserProvider).value;
    return user?.$id;
  }

  String _requireCurrentUserId() {
    final String? userId = _currentUserIdOrNull();
    if (userId == null) {
      throw StateError('No user is logged in');
    }
    return userId;
  }
}
