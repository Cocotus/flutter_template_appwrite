import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';
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
    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Logout requested');

    state = const AsyncValue<void>.loading();
    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.logout();

      // Remove the previous user's cached settings so the next user on
      // this machine starts from defaults, then reset the in-memory state.
      final PreferencesService preferences =
          ref.read(preferencesServiceProvider);
      await preferences.clearCachedUserSettings();
      ref.invalidate(userSettingsControllerProvider);

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
