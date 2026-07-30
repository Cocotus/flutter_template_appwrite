// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are shared,
/// cross-cutting state: theme, locale and the sidebar all depend on it, not just
/// one view.
///
/// ## Local only, on purpose
///
/// This controller knows nothing about Appwrite. `shared_preferences` is the
/// live, authoritative store: [build] reads it synchronously at startup so the
/// first frame already has the right theme and language, and [save] writes it
/// back. That is the whole persistence story here.
///
/// Getting the settings into the cloud is a separate, explicit step owned by
/// `CloudSync` — pull after login, push on Save and on logout. Keeping the two
/// apart is what lets a build with `HAS_LOGIN=false` use this class unchanged,
/// with no Appwrite code reachable at all.
///
/// Its counterpart for user-created content is `UserDataService`; see
/// [UserData] for why the two are separate stores.

@ProviderFor(UserSettingsService)
final userSettingsServiceProvider = UserSettingsServiceProvider._();

/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are shared,
/// cross-cutting state: theme, locale and the sidebar all depend on it, not just
/// one view.
///
/// ## Local only, on purpose
///
/// This controller knows nothing about Appwrite. `shared_preferences` is the
/// live, authoritative store: [build] reads it synchronously at startup so the
/// first frame already has the right theme and language, and [save] writes it
/// back. That is the whole persistence story here.
///
/// Getting the settings into the cloud is a separate, explicit step owned by
/// `CloudSync` — pull after login, push on Save and on logout. Keeping the two
/// apart is what lets a build with `HAS_LOGIN=false` use this class unchanged,
/// with no Appwrite code reachable at all.
///
/// Its counterpart for user-created content is `UserDataService`; see
/// [UserData] for why the two are separate stores.
final class UserSettingsServiceProvider
    extends $NotifierProvider<UserSettingsService, UserSettings> {
  /// Holds and persists the current user's [UserSettings].
  ///
  /// This lives in `services/` (not `controllers/`) because settings are shared,
  /// cross-cutting state: theme, locale and the sidebar all depend on it, not just
  /// one view.
  ///
  /// ## Local only, on purpose
  ///
  /// This controller knows nothing about Appwrite. `shared_preferences` is the
  /// live, authoritative store: [build] reads it synchronously at startup so the
  /// first frame already has the right theme and language, and [save] writes it
  /// back. That is the whole persistence story here.
  ///
  /// Getting the settings into the cloud is a separate, explicit step owned by
  /// `CloudSync` — pull after login, push on Save and on logout. Keeping the two
  /// apart is what lets a build with `HAS_LOGIN=false` use this class unchanged,
  /// with no Appwrite code reachable at all.
  ///
  /// Its counterpart for user-created content is `UserDataService`; see
  /// [UserData] for why the two are separate stores.
  UserSettingsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsServiceHash();

  @$internal
  @override
  UserSettingsService create() => UserSettingsService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSettings>(value),
    );
  }
}

String _$userSettingsServiceHash() =>
    r'f17191e91f6d4afa1b74421171a05ff5e38897ce';

/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are shared,
/// cross-cutting state: theme, locale and the sidebar all depend on it, not just
/// one view.
///
/// ## Local only, on purpose
///
/// This controller knows nothing about Appwrite. `shared_preferences` is the
/// live, authoritative store: [build] reads it synchronously at startup so the
/// first frame already has the right theme and language, and [save] writes it
/// back. That is the whole persistence story here.
///
/// Getting the settings into the cloud is a separate, explicit step owned by
/// `CloudSync` — pull after login, push on Save and on logout. Keeping the two
/// apart is what lets a build with `HAS_LOGIN=false` use this class unchanged,
/// with no Appwrite code reachable at all.
///
/// Its counterpart for user-created content is `UserDataService`; see
/// [UserData] for why the two are separate stores.

abstract class _$UserSettingsService extends $Notifier<UserSettings> {
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
