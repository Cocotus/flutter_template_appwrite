// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are
/// shared, cross-cutting state: theme, locale and the sidebar all depend on
/// it, not just one view.
///
/// Settings precedence ("local first, remote wins"):
/// 1. [build] returns sane defaults, merged with the local
///    `shared_preferences` cache, so the UI renders instantly.
/// 2. After login, [loadForCurrentUser] fetches the authoritative row from
///    Appwrite and replaces the state once it arrives.
/// 3. Every change via [save] is written to BOTH the local cache and the
///    Appwrite row.

@ProviderFor(UserSettingsController)
final userSettingsControllerProvider = UserSettingsControllerProvider._();

/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are
/// shared, cross-cutting state: theme, locale and the sidebar all depend on
/// it, not just one view.
///
/// Settings precedence ("local first, remote wins"):
/// 1. [build] returns sane defaults, merged with the local
///    `shared_preferences` cache, so the UI renders instantly.
/// 2. After login, [loadForCurrentUser] fetches the authoritative row from
///    Appwrite and replaces the state once it arrives.
/// 3. Every change via [save] is written to BOTH the local cache and the
///    Appwrite row.
final class UserSettingsControllerProvider
    extends $NotifierProvider<UserSettingsController, UserSettings> {
  /// Holds and persists the current user's [UserSettings].
  ///
  /// This lives in `services/` (not `controllers/`) because settings are
  /// shared, cross-cutting state: theme, locale and the sidebar all depend on
  /// it, not just one view.
  ///
  /// Settings precedence ("local first, remote wins"):
  /// 1. [build] returns sane defaults, merged with the local
  ///    `shared_preferences` cache, so the UI renders instantly.
  /// 2. After login, [loadForCurrentUser] fetches the authoritative row from
  ///    Appwrite and replaces the state once it arrives.
  /// 3. Every change via [save] is written to BOTH the local cache and the
  ///    Appwrite row.
  UserSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsControllerHash();

  @$internal
  @override
  UserSettingsController create() => UserSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSettings>(value),
    );
  }
}

String _$userSettingsControllerHash() =>
    r'8effdaeb52803469227a1173e5d94febe702b927';

/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are
/// shared, cross-cutting state: theme, locale and the sidebar all depend on
/// it, not just one view.
///
/// Settings precedence ("local first, remote wins"):
/// 1. [build] returns sane defaults, merged with the local
///    `shared_preferences` cache, so the UI renders instantly.
/// 2. After login, [loadForCurrentUser] fetches the authoritative row from
///    Appwrite and replaces the state once it arrives.
/// 3. Every change via [save] is written to BOTH the local cache and the
///    Appwrite row.

abstract class _$UserSettingsController extends $Notifier<UserSettings> {
  UserSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserSettings, UserSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserSettings, UserSettings>,
              UserSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
