import 'package:flutter_template_appwrite/models/entitlement.dart';
import 'package:flutter_template_appwrite/services/demo/demo_data.dart';
import 'package:flutter_template_appwrite/services/license_service.dart';

/// In-memory [LicenseService] used when demo mode is active.
///
/// The demo account is premium so the demo shows the full experience —
/// flip [demoIsPremium] to `false` to demonstrate the locked/upsell state.
class DemoLicenseService implements LicenseService {
  /// Whether the demo user is treated as premium.
  static const bool demoIsPremium = true;

  @override
  Future<Entitlement?> loadEntitlement({required String userId}) async {
    if (demoIsPremium == false) {
      return null;
    }
    return const Entitlement(
      plan: 'premium',
      orderId: 'demo-order-1',
      purchasedAt: '2026-01-01T00:00:00Z',
      email: demoEmail,
    );
  }
}
