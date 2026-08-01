import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/router/app_router.dart';
import 'package:flutter_template_appwrite/views/reset_password/reset_password_controller.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/buttons/app_primary_button.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_password_field.dart';

/// Completes a password reset started from the login page's "Forgot
/// password?" link.
///
/// Reached only via the link Appwrite emails (see
/// `AuthService.sendPasswordReset`), which carries [userId] and [secret] as
/// query parameters — `AppRouter` extracts them from the URL and passes them
/// in here. Deliberately outside the authenticated shell and exempt from the
/// router's auth guard: whoever clicks the emailed link is, by definition,
/// not necessarily logged in yet (and may not even have a session on this
/// device at all).
class ResetPasswordView extends HookConsumerWidget {
  /// Creates a [ResetPasswordView].
  const ResetPasswordView({
    super.key,
    required this.userId,
    required this.secret,
  });

  /// The Appwrite user ID from the recovery link's `userId` query parameter.
  final String? userId;

  /// The one-time secret from the recovery link's `secret` query parameter.
  final String? secret;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController confirmController = useTextEditingController();

    // Distinguishes "never submitted yet" from "submitted successfully" —
    // both are `AsyncData<void>` on the controller, since `build()` itself
    // starts in a data state (same pattern as LoginController/HomeController).
    final ValueNotifier<bool> hasSubmitted = useState<bool>(false);

    final AsyncValue<void> resetState = ref.watch(
      resetPasswordControllerProvider,
    );
    final bool succeeded =
        hasSubmitted.value && resetState.hasValue && !resetState.isLoading;

    final bool linkIsValid =
        (userId?.isNotEmpty ?? false) && (secret?.isNotEmpty ?? false);

    ref.listen<AsyncValue<void>>(resetPasswordControllerProvider, (
      AsyncValue<void>? previous,
      AsyncValue<void> next,
    ) {
      if (next.hasError && next.isLoading == false) {
        final String message = _mapResetError(context, next.error!);
        showErrorSnackbar(context, message);
      }
    });

    final Widget content;
    if (!linkIsValid) {
      content = _buildInvalidLink(context, localizations);
    } else if (succeeded) {
      content = _buildSuccess(context, localizations);
    } else {
      content = _buildForm(
        context: context,
        ref: ref,
        localizations: localizations,
        passwordController: passwordController,
        confirmController: confirmController,
        resetState: resetState,
        hasSubmitted: hasSubmitted,
        userId: userId!,
        secret: secret!,
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(padding: const EdgeInsets.all(32), child: content),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required TextEditingController passwordController,
    required TextEditingController confirmController,
    required AsyncValue<void> resetState,
    required ValueNotifier<bool> hasSubmitted,
    required String userId,
    required String secret,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          localizations.resetPasswordTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.resetPasswordIntro,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        AppPasswordField(
          controller: passwordController,
          label: localizations.password,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        AppPasswordField(
          controller: confirmController,
          label: localizations.confirmPassword,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: localizations.resetPasswordSubmit,
          isLoading: resetState.isLoading,
          onPressed: () {
            final String password = passwordController.text;
            if (password.isEmpty) {
              showErrorSnackbar(context, localizations.errorGeneric);
              return;
            }
            if (password != confirmController.text) {
              showErrorSnackbar(context, localizations.passwordsDoNotMatch);
              return;
            }

            hasSubmitted.value = true;
            ref
                .read(resetPasswordControllerProvider.notifier)
                .submit(userId: userId, secret: secret, password: password);
          },
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context, AppLocalizations localizations) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          Icons.check_circle_outline,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          localizations.resetPasswordSuccessTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.resetPasswordSuccessMessage,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: localizations.backToLogin,
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }

  Widget _buildInvalidLink(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(Icons.error_outline, size: 48, color: colorScheme.error),
        const SizedBox(height: 16),
        Text(
          localizations.resetPasswordInvalidLinkTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.resetPasswordInvalidLinkMessage,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: localizations.backToLogin,
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}

// `account.updateRecovery` reports an invalid/expired link the same way
// `account.get()` reports "no session" -- an AppwriteException with code
// 401 -- but here that must map to a completely different message (nothing
// about credentials), so this is deliberately not `mapAuthError`.
String _mapResetError(BuildContext context, Object error) {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  if (error is AppwriteException && error.code == 401) {
    return localizations.resetPasswordInvalidLinkMessage;
  }
  return localizations.errorGeneric;
}
