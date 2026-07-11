import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/models/entitlement.dart';
import 'package:flutter_template_appwrite/services/appwrite_service.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_license_service.dart';
import 'package:flutter_template_appwrite/services/demo_mode_service.dart';

part 'license_service.g.dart';

/// Reads the user's premium entitlement from the `entitlements` table.
///
/// The table is written EXCLUSIVELY by the payment webhook function (see
/// `functions/lemonsqueezy-webhook/` and the README's monetization section);
/// this service only ever reads. The client never decides about premium on
/// its own — the row's existence IS the entitlement.
class LicenseService {
  /// Creates a [LicenseService] that talks to the given TablesDB API
  /// (callers pass it as `tablesDB:`).
  LicenseService({required this._tablesDB});

  final TablesDB _tablesDB;

  /// Loads the entitlement row of the user with the given [userId].
  ///
  /// Returns `null` when no row exists (Appwrite responds with 404) — the
  /// normal state for free users, not a failure.
  Future<Entitlement?> loadEntitlement({required String userId}) async {
    try {
      final appwrite_models.Row row = await _tablesDB.getRow(
        databaseId: AppConfig.appwriteDatabaseId,
        tableId: AppConfig.entitlementsTableId,
        rowId: userId,
      );
      return Entitlement.fromJson(row.data);
    } on AppwriteException catch (error) {
      if (error.code == 404) {
        return null;
      }
      rethrow;
    }
  }

  /// The hosted checkout URL for the given user.
  ///
  /// Appends the account e-mail (pre-fills the payment form) and the
  /// Appwrite user ID as custom data — the webhook uses that ID to assign
  /// the purchase to the right account, so paying with a different e-mail
  /// still unlocks the correct user.
  static Uri buildCheckoutUri({
    required String userId,
    required String email,
  }) {
    final Uri base = Uri.parse(AppConfig.premiumCheckoutUrl);

    // Start from the query parameters already present on the configured
    // checkout URL, then add ours on top. Written as an explicit loop
    // instead of a spread (`...`) so the merge step is easy to follow.
    final Map<String, String> queryParameters = <String, String>{};
    for (final MapEntry<String, String> entry in base.queryParameters.entries) {
      queryParameters[entry.key] = entry.value;
    }
    queryParameters['checkout[email]'] = email;
    queryParameters['checkout[custom][user_id]'] = userId;

    return base.replace(queryParameters: queryParameters);
  }
}

/// Provides the app-wide [LicenseService] instance.
///
/// When demo mode is active it returns a [DemoLicenseService] so the demo
/// shows the premium experience without a backend.
@Riverpod(keepAlive: true)
LicenseService licenseService(Ref ref) {
  if (ref.watch(demoModeProvider)) {
    return DemoLicenseService();
  }
  final AppwriteService appwrite = ref.watch(appwriteServiceProvider);
  return LicenseService(tablesDB: appwrite.tablesDB);
}

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
