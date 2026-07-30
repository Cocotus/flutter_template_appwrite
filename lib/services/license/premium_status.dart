import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/entitlement.dart';
import 'package:flutter_template_appwrite/services/auth/current_user.dart';
import 'package:flutter_template_appwrite/services/license/license_service.dart';

part 'premium_status.g.dart';

/// Holds the current user's [Entitlement], or `null` for free users.
///
/// Rebuilds whenever the logged-in user changes. Call [refresh] after the
/// user returns from the checkout ("check purchase" button) so a fresh
/// webhook-written row is picked up without re-login.
@Riverpod(keepAlive: true)
class PremiumStatus extends _$PremiumStatus {
  @override
  Future<Entitlement?> build() async {
    final appwrite_models.User? user =
        await ref.watch(currentUserProvider.future);
    if (user == null) {
      return null;
    }
    final LicenseService license = ref.watch(licenseServiceProvider);
    return license.loadEntitlement(userId: user.$id);
  }

  /// Re-reads the entitlement row (used after a purchase).
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// Convenience flag: whether the current user has a premium entitlement.
///
/// Use this to gate features, e.g. via the `PremiumGate` widget. While the
/// status is still loading it reports `false` (locked), which errs on the
/// safe side.
@Riverpod(keepAlive: true)
bool isPremium(Ref ref) {
  final AsyncValue<Entitlement?> status = ref.watch(premiumStatusProvider);
  return status.value != null;
}
