import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/entitlement.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/license_service.dart';
import 'package:flutter_template_appwrite/views/profile/profile_controller.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/buttons/app_buttons.dart';
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
            const SizedBox(height: 24),
            _buildPremiumCard(
              context: context,
              ref: ref,
              localizations: localizations,
              user: user,
            ),
            const SizedBox(height: 24),
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

  // Premium status + purchase flow. The entitlement is read-only for the
  // client; buying happens on the hosted checkout page (Merchant of Record
  // handles payment methods, VAT and invoices), the payment webhook then
  // writes the entitlement row — see the README's monetization section.
  Widget _buildPremiumCard({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required appwrite_models.User user,
  }) {
    final AsyncValue<Entitlement?> premiumState =
        ref.watch(premiumStatusProvider);
    final Entitlement? entitlement = premiumState.value;
    final bool isChecking = premiumState.isLoading;

    final Widget content;
    if (entitlement != null) {
      // Premium user: show the unlocked state with the purchase date.
      final String purchasedDate = entitlement.purchasedAt.length >= 10
          ? entitlement.purchasedAt.substring(0, 10)
          : entitlement.purchasedAt;
      content = ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          Icons.workspace_premium,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        title: Text(localizations.premiumActive),
        subtitle: Text(
          purchasedDate.isEmpty
              ? localizations.premiumTitle
              : '${localizations.premiumTitle} · $purchasedDate',
        ),
      );
    } else {
      // Free user: upsell + buy/check buttons.
      final bool isCheckoutConfigured =
          AppConfig.premiumCheckoutUrl.isNotEmpty;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.workspace_premium_outlined, size: 32),
            title: Text(localizations.premiumTitle),
            subtitle: Text(localizations.premiumUpsell),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              AppPrimaryButton(
                label: localizations.premiumBuy,
                icon: Icons.shopping_cart_checkout,
                onPressed: isCheckoutConfigured
                    ? () {
                        final Uri checkoutUri =
                            LicenseService.buildCheckoutUri(
                          userId: user.$id,
                          email: user.email,
                        );
                        // Fire-and-forget: the hosted checkout opens in the
                        // browser; afterwards "check purchase" picks up the
                        // webhook-written entitlement.
                        launchUrl(checkoutUri);
                      }
                    : null,
              ),
              const SizedBox(width: 12),
              AppSecondaryButton(
                label: localizations.premiumCheckPurchase,
                icon: Icons.refresh,
                isLoading: isChecking,
                onPressed: () {
                  ref.read(premiumStatusProvider.notifier).refresh();
                },
              ),
            ],
          ),
          if (isCheckoutConfigured == false)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                localizations.premiumCheckoutMissing,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }
}
