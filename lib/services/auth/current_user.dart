import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/services/auth/auth_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';

part 'current_user.g.dart';

/// Holds the currently logged-in Appwrite user, or `null` when logged out.
///
/// This is the single source of truth for the router's auth guard. Call
/// [CurrentUser.refresh] after every login/logout so the guard re-evaluates.
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<appwrite_models.User?> build() async {
    if (!AppConfig.hasLogin) {
      // Public/freeware mode: no auth flow and no Appwrite account checks.
      return null;
    }

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
