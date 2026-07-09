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
/// provider — and, transitively, [CurrentUser] and the router guard.

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
/// provider — and, transitively, [CurrentUser] and the router guard.

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
  /// provider — and, transitively, [CurrentUser] and the router guard.
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

/// Holds the currently logged-in Appwrite user, or `null` when logged out.
///
/// This is the single source of truth for the router's auth guard. Call
/// [CurrentUser.refresh] after every login/logout so the guard re-evaluates.

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

/// Holds the currently logged-in Appwrite user, or `null` when logged out.
///
/// This is the single source of truth for the router's auth guard. Call
/// [CurrentUser.refresh] after every login/logout so the guard re-evaluates.
final class CurrentUserProvider
    extends $AsyncNotifierProvider<CurrentUser, appwrite_models.User?> {
  /// Holds the currently logged-in Appwrite user, or `null` when logged out.
  ///
  /// This is the single source of truth for the router's auth guard. Call
  /// [CurrentUser.refresh] after every login/logout so the guard re-evaluates.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();
}

String _$currentUserHash() => r'5b6b44c49aad46f61dfbe68036eda873a66b664b';

/// Holds the currently logged-in Appwrite user, or `null` when logged out.
///
/// This is the single source of truth for the router's auth guard. Call
/// [CurrentUser.refresh] after every login/logout so the guard re-evaluates.

abstract class _$CurrentUser extends $AsyncNotifier<appwrite_models.User?> {
  FutureOr<appwrite_models.User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<appwrite_models.User?>, appwrite_models.User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<appwrite_models.User?>,
                appwrite_models.User?
              >,
              AsyncValue<appwrite_models.User?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
