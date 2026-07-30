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
