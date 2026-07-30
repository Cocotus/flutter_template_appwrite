// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

String _$currentUserHash() => r'cd8bc6bbdade29cf45f9bde393ab0f68a7b3b163';

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
