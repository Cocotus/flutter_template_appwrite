// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [LicenseService] instance.
///
/// When demo mode is active it returns a [DemoLicenseService] so the demo
/// shows the premium experience without a backend.

@ProviderFor(licenseService)
final licenseServiceProvider = LicenseServiceProvider._();

/// Provides the app-wide [LicenseService] instance.
///
/// When demo mode is active it returns a [DemoLicenseService] so the demo
/// shows the premium experience without a backend.

final class LicenseServiceProvider
    extends $FunctionalProvider<LicenseService, LicenseService, LicenseService>
    with $Provider<LicenseService> {
  /// Provides the app-wide [LicenseService] instance.
  ///
  /// When demo mode is active it returns a [DemoLicenseService] so the demo
  /// shows the premium experience without a backend.
  LicenseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'licenseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$licenseServiceHash();

  @$internal
  @override
  $ProviderElement<LicenseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LicenseService create(Ref ref) {
    return licenseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LicenseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LicenseService>(value),
    );
  }
}

String _$licenseServiceHash() => r'c73374c70c87ba5c9a2183d398b8e920ca88ffa7';

/// Holds the current user's [Entitlement], or `null` for free users.
///
/// Rebuilds whenever the logged-in user changes. Call [refresh] after the
/// user returns from the checkout ("check purchase" button) so a fresh
/// webhook-written row is picked up without re-login.

@ProviderFor(PremiumStatus)
final premiumStatusProvider = PremiumStatusProvider._();

/// Holds the current user's [Entitlement], or `null` for free users.
///
/// Rebuilds whenever the logged-in user changes. Call [refresh] after the
/// user returns from the checkout ("check purchase" button) so a fresh
/// webhook-written row is picked up without re-login.
final class PremiumStatusProvider
    extends $AsyncNotifierProvider<PremiumStatus, Entitlement?> {
  /// Holds the current user's [Entitlement], or `null` for free users.
  ///
  /// Rebuilds whenever the logged-in user changes. Call [refresh] after the
  /// user returns from the checkout ("check purchase" button) so a fresh
  /// webhook-written row is picked up without re-login.
  PremiumStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumStatusHash();

  @$internal
  @override
  PremiumStatus create() => PremiumStatus();
}

String _$premiumStatusHash() => r'890d72f6fe0459df1dc6ef1672d32dd9cc1837ca';

/// Holds the current user's [Entitlement], or `null` for free users.
///
/// Rebuilds whenever the logged-in user changes. Call [refresh] after the
/// user returns from the checkout ("check purchase" button) so a fresh
/// webhook-written row is picked up without re-login.

abstract class _$PremiumStatus extends $AsyncNotifier<Entitlement?> {
  FutureOr<Entitlement?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Entitlement?>, Entitlement?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Entitlement?>, Entitlement?>,
              AsyncValue<Entitlement?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Convenience flag: whether the current user has a premium entitlement.
///
/// Use this to gate features, e.g. via the `PremiumGate` widget. While the
/// status is still loading it reports `false` (locked), which errs on the
/// safe side.

@ProviderFor(isPremium)
final isPremiumProvider = IsPremiumProvider._();

/// Convenience flag: whether the current user has a premium entitlement.
///
/// Use this to gate features, e.g. via the `PremiumGate` widget. While the
/// status is still loading it reports `false` (locked), which errs on the
/// safe side.

final class IsPremiumProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Convenience flag: whether the current user has a premium entitlement.
  ///
  /// Use this to gate features, e.g. via the `PremiumGate` widget. While the
  /// status is still loading it reports `false` (locked), which errs on the
  /// safe side.
  IsPremiumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPremiumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPremiumHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isPremium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isPremiumHash() => r'ea113219888c7181b6e8dc19cd04acbaf6d5b8a2';
