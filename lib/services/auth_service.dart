import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/services/appwrite_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_auth_service.dart';
import 'package:flutter_template_appwrite/services/demo_mode_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';

part 'auth_service.g.dart';

/// Wraps the Appwrite Account API for authentication.
///
/// Controllers depend on this service — never on the raw Appwrite client —
/// so it can be replaced with a fake in tests (see `test/fakes/`).
///
/// Errors: all methods let [AppwriteException] bubble up to the calling
/// controller, which logs it once with context and surfaces it to the UI as
/// an `AsyncValue.error`. Notable status codes:
/// - `409` on [register]: a user with this email already exists.
/// - `401` on [login]: invalid credentials.
class AuthService {
  /// Creates an [AuthService] that talks to the given Appwrite account API
  /// (callers pass it as `account:`).
  AuthService({required this._account});

  final Account _account;

  /// Creates a new Appwrite user.
  ///
  /// Do NOT pre-check whether the email exists: Appwrite enforces
  /// uniqueness server-side and throws an [AppwriteException] with code 409
  /// for duplicates, which the login controller maps to a localized message.
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  /// Creates an email/password session for the given credentials.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  /// Returns the currently logged-in user.
  ///
  /// Throws an [AppwriteException] with code 401 when no session exists;
  /// the startup guard treats that as "not logged in".
  Future<appwrite_models.User> currentUser() async {
    return _account.get();
  }

  /// Deletes the current session (logout).
  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  /// Sends a password recovery email to [email].
  ///
  /// The recovery link points to [AppConfig.passwordRecoveryUrl]; its origin
  /// must be registered as a Web platform in the Appwrite console.
  /// Completing the reset (`account.updateRecovery`) is a documented TODO —
  /// see the README's Appwrite setup section.
  Future<void> sendPasswordReset(String email) async {
    await _account.createRecovery(
      email: email,
      url: AppConfig.passwordRecoveryUrl,
    );
  }
}

/// Provides the app-wide [AuthService] instance.
///
/// Kept alive because authentication is used across the whole app. Tests
/// override this provider with a fake, e.g.
/// `authServiceProvider.overrideWithValue(FakeAuthService())`.
///
/// When demo mode is active it returns a [DemoAuthService] instead, so the
/// app runs with a fake account and never touches Appwrite. Because this
/// watches [demoModeProvider], toggling the demo switch rebuilds this
/// provider — and, transitively, [CurrentUser] and the router guard.
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  if (ref.watch(demoModeProvider)) {
    return DemoAuthService();
  }
  final AppwriteService appwrite = ref.watch(appwriteServiceProvider);
  return AuthService(account: appwrite.account);
}

/// Holds the currently logged-in Appwrite user, or `null` when logged out.
///
/// This is the single source of truth for the router's auth guard. Call
/// [CurrentUser.refresh] after every login/logout so the guard re-evaluates.
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<appwrite_models.User?> build() async {
    final AuthService authService = ref.watch(authServiceProvider);
    final LoggerService logger = ref.read(loggerServiceProvider);

    try {
      final appwrite_models.User user = await authService.currentUser();
      logger.info('Startup auth check: existing session found');
      return user;
    } on AppwriteException catch (error) {
      // 401 simply means "no session" — that is a normal state at startup,
      // not an error worth an error-level log entry.
      if (error.code == 401) {
        logger.info('Startup auth check: no active session');
        return null;
      }
      rethrow;
    }
  }

  /// Re-runs the session check (used right after login/logout).
  Future<void> refresh() async {
    // Invalidate and wait for the rebuilt value so callers can await
    // a consistent auth state before navigating.
    ref.invalidateSelf();
    await future;
  }
}
