// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the three moments at which this app talks to Appwrite.
///
/// The local `shared_preferences` copy is the app's live, authoritative store:
/// every settings change and every piece of user content is written there
/// immediately and the network is not involved. Appwrite is a sync layer on top,
/// and it is touched at exactly three points, all of them things the user did on
/// purpose:
///
/// 1. **[pull] after login** — the remote copy replaces the local one.
/// 2. **[push] when Save is pressed** in the settings page, or via the explicit
///    "Sync now" button next to it.
/// 3. **[push] on logout** — so the session's work is not left behind on the
///    device.
///
/// Nothing here runs on a timer, a listener or a widget event. That is the whole
/// point: a maintainer reading a bug report about "my data did not sync" has
/// three places to look, not an event graph.
///
/// The state is the timestamp of the last successful sync (`null` when this
/// device never synced), wrapped in an `AsyncValue` so the settings page can
/// show progress and errors with the same handling it uses everywhere else.
///
/// **Conflict model:** last write wins, and [pull] replaces the local copy
/// wholesale. Because a logout always pushes first, the ordinary
/// "work, log out, sign in elsewhere" flow carries everything across. Signing in
/// on a device that has unsynced local changes discards them in favour of the
/// remote copy — the trade for not maintaining a merge algorithm, and the reason
/// [pull] logs what it replaced.

@ProviderFor(CloudSync)
final cloudSyncProvider = CloudSyncProvider._();

/// Owns the three moments at which this app talks to Appwrite.
///
/// The local `shared_preferences` copy is the app's live, authoritative store:
/// every settings change and every piece of user content is written there
/// immediately and the network is not involved. Appwrite is a sync layer on top,
/// and it is touched at exactly three points, all of them things the user did on
/// purpose:
///
/// 1. **[pull] after login** — the remote copy replaces the local one.
/// 2. **[push] when Save is pressed** in the settings page, or via the explicit
///    "Sync now" button next to it.
/// 3. **[push] on logout** — so the session's work is not left behind on the
///    device.
///
/// Nothing here runs on a timer, a listener or a widget event. That is the whole
/// point: a maintainer reading a bug report about "my data did not sync" has
/// three places to look, not an event graph.
///
/// The state is the timestamp of the last successful sync (`null` when this
/// device never synced), wrapped in an `AsyncValue` so the settings page can
/// show progress and errors with the same handling it uses everywhere else.
///
/// **Conflict model:** last write wins, and [pull] replaces the local copy
/// wholesale. Because a logout always pushes first, the ordinary
/// "work, log out, sign in elsewhere" flow carries everything across. Signing in
/// on a device that has unsynced local changes discards them in favour of the
/// remote copy — the trade for not maintaining a merge algorithm, and the reason
/// [pull] logs what it replaced.
final class CloudSyncProvider
    extends $AsyncNotifierProvider<CloudSync, DateTime?> {
  /// Owns the three moments at which this app talks to Appwrite.
  ///
  /// The local `shared_preferences` copy is the app's live, authoritative store:
  /// every settings change and every piece of user content is written there
  /// immediately and the network is not involved. Appwrite is a sync layer on top,
  /// and it is touched at exactly three points, all of them things the user did on
  /// purpose:
  ///
  /// 1. **[pull] after login** — the remote copy replaces the local one.
  /// 2. **[push] when Save is pressed** in the settings page, or via the explicit
  ///    "Sync now" button next to it.
  /// 3. **[push] on logout** — so the session's work is not left behind on the
  ///    device.
  ///
  /// Nothing here runs on a timer, a listener or a widget event. That is the whole
  /// point: a maintainer reading a bug report about "my data did not sync" has
  /// three places to look, not an event graph.
  ///
  /// The state is the timestamp of the last successful sync (`null` when this
  /// device never synced), wrapped in an `AsyncValue` so the settings page can
  /// show progress and errors with the same handling it uses everywhere else.
  ///
  /// **Conflict model:** last write wins, and [pull] replaces the local copy
  /// wholesale. Because a logout always pushes first, the ordinary
  /// "work, log out, sign in elsewhere" flow carries everything across. Signing in
  /// on a device that has unsynced local changes discards them in favour of the
  /// remote copy — the trade for not maintaining a merge algorithm, and the reason
  /// [pull] logs what it replaced.
  CloudSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudSyncHash();

  @$internal
  @override
  CloudSync create() => CloudSync();
}

String _$cloudSyncHash() => r'64315c07de09fdb13f275e8ebfbfd839f22bc268';

/// Owns the three moments at which this app talks to Appwrite.
///
/// The local `shared_preferences` copy is the app's live, authoritative store:
/// every settings change and every piece of user content is written there
/// immediately and the network is not involved. Appwrite is a sync layer on top,
/// and it is touched at exactly three points, all of them things the user did on
/// purpose:
///
/// 1. **[pull] after login** — the remote copy replaces the local one.
/// 2. **[push] when Save is pressed** in the settings page, or via the explicit
///    "Sync now" button next to it.
/// 3. **[push] on logout** — so the session's work is not left behind on the
///    device.
///
/// Nothing here runs on a timer, a listener or a widget event. That is the whole
/// point: a maintainer reading a bug report about "my data did not sync" has
/// three places to look, not an event graph.
///
/// The state is the timestamp of the last successful sync (`null` when this
/// device never synced), wrapped in an `AsyncValue` so the settings page can
/// show progress and errors with the same handling it uses everywhere else.
///
/// **Conflict model:** last write wins, and [pull] replaces the local copy
/// wholesale. Because a logout always pushes first, the ordinary
/// "work, log out, sign in elsewhere" flow carries everything across. Signing in
/// on a device that has unsynced local changes discards them in favour of the
/// remote copy — the trade for not maintaining a merge algorithm, and the reason
/// [pull] logs what it replaced.

abstract class _$CloudSync extends $AsyncNotifier<DateTime?> {
  FutureOr<DateTime?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DateTime?>, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DateTime?>, DateTime?>,
              AsyncValue<DateTime?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
