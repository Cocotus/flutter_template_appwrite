// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds and persists everything the user creates inside the app.
///
/// The counterpart to `UserSettingsService`: that one owns configuration,
/// this one owns content. See [UserData] for why the two are split.
///
/// ## Persistence
///
/// Every mutation updates the state first (so the UI is instant), then writes
/// the whole document to `shared_preferences`. That is the only automatic
/// write, and it never touches the network. A full rewrite per change is far
/// simpler than incremental keys and, for a capped document, cheaper to reason
/// about than it looks.
///
/// Getting the document off the device is always something the user asked for:
/// the Export/Import buttons in the settings page (`BackupService`), or the
/// Appwrite sync that runs on login, on Save and on logout (`CloudSync`).
///
/// Reads are **synchronous**: `main.dart` already awaits
/// `SharedPreferences.getInstance()` before `runApp`, so [build] can return the
/// stored document directly and views never handle a loading state for it.
///
/// ## Adapting this to your app
///
/// [addNote] is an example of the shape every mutation should have: change a
/// copy, enforce the cap, hand it to [replaceAll]-style single write path.
/// Replace it with your app's real operations and keep `_apply` as the only
/// place that writes.

@ProviderFor(UserDataService)
final userDataServiceProvider = UserDataServiceProvider._();

/// Holds and persists everything the user creates inside the app.
///
/// The counterpart to `UserSettingsService`: that one owns configuration,
/// this one owns content. See [UserData] for why the two are split.
///
/// ## Persistence
///
/// Every mutation updates the state first (so the UI is instant), then writes
/// the whole document to `shared_preferences`. That is the only automatic
/// write, and it never touches the network. A full rewrite per change is far
/// simpler than incremental keys and, for a capped document, cheaper to reason
/// about than it looks.
///
/// Getting the document off the device is always something the user asked for:
/// the Export/Import buttons in the settings page (`BackupService`), or the
/// Appwrite sync that runs on login, on Save and on logout (`CloudSync`).
///
/// Reads are **synchronous**: `main.dart` already awaits
/// `SharedPreferences.getInstance()` before `runApp`, so [build] can return the
/// stored document directly and views never handle a loading state for it.
///
/// ## Adapting this to your app
///
/// [addNote] is an example of the shape every mutation should have: change a
/// copy, enforce the cap, hand it to [replaceAll]-style single write path.
/// Replace it with your app's real operations and keep `_apply` as the only
/// place that writes.
final class UserDataServiceProvider
    extends $NotifierProvider<UserDataService, UserData> {
  /// Holds and persists everything the user creates inside the app.
  ///
  /// The counterpart to `UserSettingsService`: that one owns configuration,
  /// this one owns content. See [UserData] for why the two are split.
  ///
  /// ## Persistence
  ///
  /// Every mutation updates the state first (so the UI is instant), then writes
  /// the whole document to `shared_preferences`. That is the only automatic
  /// write, and it never touches the network. A full rewrite per change is far
  /// simpler than incremental keys and, for a capped document, cheaper to reason
  /// about than it looks.
  ///
  /// Getting the document off the device is always something the user asked for:
  /// the Export/Import buttons in the settings page (`BackupService`), or the
  /// Appwrite sync that runs on login, on Save and on logout (`CloudSync`).
  ///
  /// Reads are **synchronous**: `main.dart` already awaits
  /// `SharedPreferences.getInstance()` before `runApp`, so [build] can return the
  /// stored document directly and views never handle a loading state for it.
  ///
  /// ## Adapting this to your app
  ///
  /// [addNote] is an example of the shape every mutation should have: change a
  /// copy, enforce the cap, hand it to [replaceAll]-style single write path.
  /// Replace it with your app's real operations and keep `_apply` as the only
  /// place that writes.
  UserDataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataServiceHash();

  @$internal
  @override
  UserDataService create() => UserDataService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserData>(value),
    );
  }
}

String _$userDataServiceHash() => r'4a6819f7b0119a1deb75b6d2e974155c248fac67';

/// Holds and persists everything the user creates inside the app.
///
/// The counterpart to `UserSettingsService`: that one owns configuration,
/// this one owns content. See [UserData] for why the two are split.
///
/// ## Persistence
///
/// Every mutation updates the state first (so the UI is instant), then writes
/// the whole document to `shared_preferences`. That is the only automatic
/// write, and it never touches the network. A full rewrite per change is far
/// simpler than incremental keys and, for a capped document, cheaper to reason
/// about than it looks.
///
/// Getting the document off the device is always something the user asked for:
/// the Export/Import buttons in the settings page (`BackupService`), or the
/// Appwrite sync that runs on login, on Save and on logout (`CloudSync`).
///
/// Reads are **synchronous**: `main.dart` already awaits
/// `SharedPreferences.getInstance()` before `runApp`, so [build] can return the
/// stored document directly and views never handle a loading state for it.
///
/// ## Adapting this to your app
///
/// [addNote] is an example of the shape every mutation should have: change a
/// copy, enforce the cap, hand it to [replaceAll]-style single write path.
/// Replace it with your app's real operations and keep `_apply` as the only
/// place that writes.

abstract class _$UserDataService extends $Notifier<UserData> {
  UserData build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserData, UserData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserData, UserData>,
              UserData,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
