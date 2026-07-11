import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/router/app_router.dart';
import 'package:flutter_template_appwrite/services/license_service.dart';
import 'package:flutter_template_appwrite/widgets/buttons/app_buttons.dart';

/// Shows [child] only to premium users; everyone else sees an upgrade card
/// pointing to the profile page (where the purchase lives).
///
/// Wrap any feature, section or whole view body:
/// ```dart
/// PremiumGate(child: SupportContactCard())
/// ```
/// REMINDER: this is UI gating only — anything truly sensitive must also be
/// protected server-side (permissions, functions), never just hidden here.
class PremiumGate extends ConsumerWidget {
  /// Creates a [PremiumGate] around the given [child].
  const PremiumGate({super.key, required this.child});

  /// The premium-only content.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPremium = ref.watch(isPremiumProvider);
    if (isPremium) {
      return child;
    }

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.workspace_premium_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              localizations.premiumLocked,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: localizations.premiumBuy,
              icon: Icons.workspace_premium_outlined,
              onPressed: () {
                // The purchase flow lives on the profile page.
                context.go(AppRoutes.profile);
              },
            ),
          ],
        ),
      ),
    );
  }
}
