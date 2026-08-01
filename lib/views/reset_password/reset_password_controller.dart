import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/services/auth/auth_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';

part 'reset_password_controller.g.dart';

/// Controller for the password-reset completion screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext` —
/// same shape as [LoginController], just for the other half of the recovery
/// flow (see `AuthService.completePasswordReset`).
@riverpod
class ResetPasswordController extends _$ResetPasswordController {
  @override
  FutureOr<void> build() {
    // No initial work needed; the screen starts in an idle data state.
  }

  /// Completes the password reset identified by [userId]/[secret] (the query
  /// parameters of the emailed recovery link — see `ResetPasswordView`),
  /// setting the account's password to [password].
  Future<void> submit({
    required String userId,
    required String secret,
    required String password,
  }) async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Password reset completion attempted');

    state = const AsyncValue<void>.loading();
    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.completePasswordReset(
        userId: userId,
        secret: secret,
        password: password,
      );

      logger.info('Password reset completed');
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Password reset completion failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}
