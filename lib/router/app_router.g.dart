// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app's [GoRouter].
///
/// Auth guard: the top-level [GoRouter.redirect] reads the current auth
/// state ([currentUserProvider]) on every navigation:
/// - While the startup session check runs, everything shows the splash page.
/// - Without a session, everything redirects to `/login`.
/// - With a session, `/login` and `/splash` redirect to the shell.
///
/// The [GoRouter.refreshListenable] is bumped whenever the auth state
/// changes, so login/logout re-run the redirect immediately — without it,
/// the guard would only run on explicit navigation events.

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

/// Provides the app's [GoRouter].
///
/// Auth guard: the top-level [GoRouter.redirect] reads the current auth
/// state ([currentUserProvider]) on every navigation:
/// - While the startup session check runs, everything shows the splash page.
/// - Without a session, everything redirects to `/login`.
/// - With a session, `/login` and `/splash` redirect to the shell.
///
/// The [GoRouter.refreshListenable] is bumped whenever the auth state
/// changes, so login/logout re-run the redirect immediately — without it,
/// the guard would only run on explicit navigation events.

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Provides the app's [GoRouter].
  ///
  /// Auth guard: the top-level [GoRouter.redirect] reads the current auth
  /// state ([currentUserProvider]) on every navigation:
  /// - While the startup session check runs, everything shows the splash page.
  /// - Without a session, everything redirects to `/login`.
  /// - With a session, `/login` and `/splash` redirect to the shell.
  ///
  /// The [GoRouter.refreshListenable] is bumped whenever the auth state
  /// changes, so login/logout re-run the redirect immediately — without it,
  /// the guard would only run on explicit navigation events.
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'd74badb1e215244c9fbad9bf0a72f26a9844ac7b';
