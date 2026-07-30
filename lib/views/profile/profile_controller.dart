import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/services/auth/auth_service.dart';
import 'package:flutter_template_appwrite/services/auth/current_user.dart';
import 'package:flutter_template_appwrite/services/cloud_sync/cloud_sync_controller.dart';
import 'package:flutter_template_appwrite/services/demo_mode.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';
import 'package:flutter_template_appwrite/services/user_data_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'profile_controller.g.dart';

/// Controller for the profile view.
///
/// The profile data itself comes straight from `currentUserProvider`; this
/// controller only owns the logout action and its progress state.
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {
    // No initial work needed; the screen starts in an idle data state.
  }

  /// Logs the current user out and clears the local settings cache.
  ///
  /// After the session is gone the auth state refresh makes the router
  /// guard navigate back to the login screen automatically.
  Future<void> logout() async {
    if (!AppConfig.hasLogin) {
      // Public/freeware mode has no authenticated session to terminate.
      state = const AsyncValue<void>.data(null);
      return;
    }

    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Logout requested');

    state = const AsyncValue<void>.loading();
    try {
      // Capture this before switching services: logging out of a demo
      // session must NOT hit Appwrite.
      final bool wasDemoMode = ref.read(demoModeProvider);

      // Last chance to save this session's work remotely. A failure here is
      // logged by CloudSync itself and must not block the logout — being
      // unable to reach the server should never trap someone in a session.
      final CloudSync cloudSync = ref.read(cloudSyncProvider.notifier);
      await cloudSync.push();

      final AuthService authService = ref.read(authServiceProvider);
      await authService.logout();

      // Leaving a demo session returns the app to the real login screen:
      // turning demo mode off rebuilds the service layer back to Appwrite.
      if (wasDemoMode) {
        await ref.read(demoModeProvider.notifier).set(enabled: false);
      }

      // Remove the previous user's data so the next user on this machine
      // starts from defaults, then reset the in-memory state.
      final PreferencesService preferences =
          ref.read(preferencesServiceProvider);
      await preferences.clearCachedUserSettings();
      await preferences.clearUserData();
      ref.invalidate(userSettingsServiceProvider);
      ref.invalidate(userDataServiceProvider);
      await cloudSync.forgetLastSync();

      logger.info('Logout success, session deleted');

      // The router guard reacts to this and shows the login screen.
      await ref.read(currentUserProvider.notifier).refresh();

      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Logout failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}
