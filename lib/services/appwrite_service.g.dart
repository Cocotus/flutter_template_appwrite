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
///
/// Throws a [StateError] when read in a build with `HAS_LOGIN=false`. In that
/// profile the app has no user identity, so nothing may talk to Appwrite at
/// all — settings and user data live purely in `shared_preferences`. Failing
/// loudly here turns that rule into something the code guarantees rather than
/// something a comment asks for.

@ProviderFor(appwriteService)
final appwriteServiceProvider = AppwriteServiceProvider._();

/// Provides the single app-wide [AppwriteService] instance.
///
/// Kept alive for the whole app lifetime: the client owns the session and
/// must not be re-created between views.
///
/// Throws a [StateError] when read in a build with `HAS_LOGIN=false`. In that
/// profile the app has no user identity, so nothing may talk to Appwrite at
/// all — settings and user data live purely in `shared_preferences`. Failing
/// loudly here turns that rule into something the code guarantees rather than
/// something a comment asks for.

final class AppwriteServiceProvider
    extends
        $FunctionalProvider<AppwriteService, AppwriteService, AppwriteService>
    with $Provider<AppwriteService> {
  /// Provides the single app-wide [AppwriteService] instance.
  ///
  /// Kept alive for the whole app lifetime: the client owns the session and
  /// must not be re-created between views.
  ///
  /// Throws a [StateError] when read in a build with `HAS_LOGIN=false`. In that
  /// profile the app has no user identity, so nothing may talk to Appwrite at
  /// all — settings and user data live purely in `shared_preferences`. Failing
  /// loudly here turns that rule into something the code guarantees rather than
  /// something a comment asks for.
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

String _$appwriteServiceHash() => r'781f5fd572fed549a5f09538b13dbf8288c1b44e';
