import 'package:freezed_annotation/freezed_annotation.dart';

part 'entitlement.freezed.dart';
part 'entitlement.g.dart';

/// A user's premium entitlement (one-time "lifetime" purchase).
///
/// Exactly one row exists per premium user in the Appwrite `entitlements`
/// table; the ROW ID EQUALS THE APPWRITE USER ID (same pattern as
/// `UserSettings`). Rows are written EXCLUSIVELY by the payment webhook
/// function (see `functions/lemonsqueezy-webhook/`) using an API key — the
/// user only ever has row-level READ permission, so the client can never
/// grant itself premium.
///
/// Every field has a default so `fromJson` tolerates rows created by older
/// webhook versions.
@freezed
abstract class Entitlement with _$Entitlement {
  /// Creates an [Entitlement].
  const factory Entitlement({
    /// The purchased plan, e.g. `premium`.
    @Default('premium') String plan,

    /// The payment provider's order ID (audit trail / support lookups).
    @Default('') String orderId,

    /// ISO-8601 timestamp of the purchase.
    @Default('') String purchasedAt,

    /// The e-mail the purchase was made with (may differ from the account
    /// e-mail; matching is done via the user ID, this is informational).
    @Default('') String email,
  }) = _Entitlement;

  /// Creates an [Entitlement] from a JSON map.
  factory Entitlement.fromJson(Map<String, dynamic> json) =>
      _$EntitlementFromJson(json);
}
