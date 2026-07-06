// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app version as a display string, e.g. `0.1.0 (1)`.
///
/// The value comes from `package_info_plus` at runtime (which reads the
/// version from `pubspec.yaml` via the platform build), so it is always in
/// sync with the built artifact. Shown discreetly on the login screen and
/// on the About page.

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

/// Provides the app version as a display string, e.g. `0.1.0 (1)`.
///
/// The value comes from `package_info_plus` at runtime (which reads the
/// version from `pubspec.yaml` via the platform build), so it is always in
/// sync with the built artifact. Shown discreetly on the login screen and
/// on the About page.

final class AppVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Provides the app version as a display string, e.g. `0.1.0 (1)`.
  ///
  /// The value comes from `package_info_plus` at runtime (which reads the
  /// version from `pubspec.yaml` via the platform build), so it is always in
  /// sync with the built artifact. Shown discreetly on the login screen and
  /// on the About page.
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'2c39c8aa06e2af6d5822417e52ff504e8aaaa326';
