// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [AuthService] instance.
///
/// Kept alive because authentication is used across the whole app. Tests
/// override this provider with a fake, e.g.
/// `authServiceProvider.overrideWithValue(FakeAuthService())`.
///
/// When demo mode is active it returns a [DemoAuthService] instead, so the
/// app runs with a fake account and never touches Appwrite. Because this
/// watches [demoModeProvider], toggling the demo switch rebuilds this
/// provider — and, transitively, `CurrentUser` and the router guard.

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

/// Provides the app-wide [AuthService] instance.
///
/// Kept alive because authentication is used across the whole app. Tests
/// override this provider with a fake, e.g.
/// `authServiceProvider.overrideWithValue(FakeAuthService())`.
///
/// When demo mode is active it returns a [DemoAuthService] instead, so the
/// app runs with a fake account and never touches Appwrite. Because this
/// watches [demoModeProvider], toggling the demo switch rebuilds this
/// provider — and, transitively, `CurrentUser` and the router guard.

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// Provides the app-wide [AuthService] instance.
  ///
  /// Kept alive because authentication is used across the whole app. Tests
  /// override this provider with a fake, e.g.
  /// `authServiceProvider.overrideWithValue(FakeAuthService())`.
  ///
  /// When demo mode is active it returns a [DemoAuthService] instead, so the
  /// app runs with a fake account and never touches Appwrite. Because this
  /// watches [demoModeProvider], toggling the demo switch rebuilds this
  /// provider — and, transitively, `CurrentUser` and the router guard.
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'8d4714ce7e048968546cd4967f06919a011d9869';
