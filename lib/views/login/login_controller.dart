import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/utils/redact_email.dart';

part 'login_controller.g.dart';

/// Controller for the login/register screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext`.
/// It only receives plain [String] values from the view and exposes its
/// progress as an `AsyncValue<void>`: loading while a request runs, data on
/// success, error on failure. The view reacts via `ref.listen`.
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    // No initial work needed; the screen starts in an idle data state.
  }

  /// Logs the user in with the given [email] and [password].
  ///
  /// On success the auth state is refreshed (which makes the router leave
  /// the login page) and the user's settings are loaded from Appwrite.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    // Never log the full email address (PII) — redact it first.
    logger.info('Login attempt (${redactEmail(email)})');

    // Show the loading spinner while the request is running.
    state = const AsyncValue<void>.loading();

    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.login(email: email, password: password);

      logger.info('Login success, session created');

      // Let the router guard know that a session now exists.
      await ref.read(currentUserProvider.notifier).refresh();

      // Load this user's settings (theme, language, ...) from Appwrite.
      final UserSettingsController settingsController =
          ref.read(userSettingsControllerProvider.notifier);
      await settingsController.loadForCurrentUser();

      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Login failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }

  /// Registers a new user, then logs them in and creates their default
  /// settings row in Appwrite.
  ///
  /// Duplicate emails are NOT pre-checked: Appwrite enforces uniqueness
  /// server-side and answers with an `AppwriteException` (code 409), which
  /// the view maps to a localized message.
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Register attempt (${redactEmail(email)})');

    state = const AsyncValue<void>.loading();

    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.register(
        email: email,
        password: password,
        name: name,
      );
      await authService.login(email: email, password: password);

      // Let the router guard know that a session now exists.
      await ref.read(currentUserProvider.notifier).refresh();

      // A brand-new user has no settings row yet — create the defaults.
      final UserSettingsController settingsController =
          ref.read(userSettingsControllerProvider.notifier);
      await settingsController.createDefaultsForCurrentUser();

      logger.info('Register success (${redactEmail(email)})');
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Register failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }

  /// Sends a password recovery email to [email].
  ///
  /// This only triggers the email (`account.createRecovery`); building the
  /// page that completes the reset via `account.updateRecovery` is a
  /// documented TODO — see the README.
  Future<void> sendPasswordReset(String email) async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Password reset requested (${redactEmail(email)})');

    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.sendPasswordReset(email);

      logger.info('Password reset email sent');
    } catch (error, stackTrace) {
      // Deliberately not surfaced as a screen-level error: the view shows a
      // neutral "reset link sent" message either way, so the form cannot be
      // used to probe which emails are registered.
      logger.handle(error, stackTrace, 'Password reset failed');
    }
  }
}
