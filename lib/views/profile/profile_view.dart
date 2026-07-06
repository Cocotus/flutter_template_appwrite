import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/views/profile/profile_controller.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/error_display.dart';
import 'package:flutter_template_appwrite/widgets/loading_indicator.dart';
import 'package:flutter_template_appwrite/widgets/user_avatar.dart';

/// Profile page: shows the current Appwrite user and offers logout.
class ProfileView extends ConsumerWidget {
  /// Creates a [ProfileView].
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final AsyncValue<appwrite_models.User?> userState =
        ref.watch(currentUserProvider);
    final AsyncValue<void> logoutState = ref.watch(profileControllerProvider);

    // Surface logout failures as a snackbar.
    ref.listen<AsyncValue<void>>(
      profileControllerProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (next.hasError && next.isLoading == false) {
          showErrorSnackbar(context, localizations.errorGeneric);
        }
      },
    );

    // Consistent AsyncValue handling with the shared state widgets.
    return userState.when(
      loading: () {
        return const LoadingIndicator();
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorDisplay(
          message: localizations.errorGeneric,
          onRetry: () {
            ref.read(currentUserProvider.notifier).refresh();
          },
        );
      },
      data: (appwrite_models.User? user) {
        if (user == null) {
          // The router guard redirects in this state; render nothing.
          return const SizedBox.shrink();
        }
        return _buildProfileContent(
          context: context,
          ref: ref,
          localizations: localizations,
          user: user,
          isLoggingOut: logoutState.isLoading,
        );
      },
    );
  }

  Widget _buildProfileContent({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required appwrite_models.User user,
    required bool isLoggingOut,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UserAvatar(displayName: user.name, radius: 48),
            const SizedBox(height: 24),
            Text(
              user.name.isEmpty ? '—' : user.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            FilledButton.tonalIcon(
              onPressed: isLoggingOut
                  ? null
                  : () {
                      ref.read(profileControllerProvider.notifier).logout();
                    },
              icon: const Icon(Icons.logout),
              label: Text(localizations.logout),
            ),
          ],
        ),
      ),
    );
  }
}
