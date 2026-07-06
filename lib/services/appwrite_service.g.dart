// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appwrite_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the single app-wide [AppwriteService] instance.
///
/// Kept alive for the whole app lifetime: the client owns the session and
/// must not be re-created between views.

@ProviderFor(appwriteService)
final appwriteServiceProvider = AppwriteServiceProvider._();

/// Provides the single app-wide [AppwriteService] instance.
///
/// Kept alive for the whole app lifetime: the client owns the session and
/// must not be re-created between views.

final class AppwriteServiceProvider
    extends
        $FunctionalProvider<AppwriteService, AppwriteService, AppwriteService>
    with $Provider<AppwriteService> {
  /// Provides the single app-wide [AppwriteService] instance.
  ///
  /// Kept alive for the whole app lifetime: the client owns the session and
  /// must not be re-created between views.
  AppwriteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteServiceHash();

  @$internal
  @override
  $ProviderElement<AppwriteService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppwriteService create(Ref ref) {
    return appwriteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppwriteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppwriteService>(value),
    );
  }
}

String _$appwriteServiceHash() => r'65304aa7dccea86d796f658507547bf573d47bb6';
