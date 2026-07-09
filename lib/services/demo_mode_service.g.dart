// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_mode_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The effective demo-mode state for the whole app.
///
/// When `true`, the service layer swaps in the in-memory fakes
/// (`DemoAuthService` / `DemoDatabaseService`) instead of the Appwrite-backed
/// implementations, so every view works without a backend or a login.
///
/// The value is `persisted user choice AND [demoModeIsAllowed]`: the stored
/// preference can never turn demo mode on in a build that does not allow it.
///
/// Kept alive because [authServiceProvider] and [databaseServiceProvider]
/// watch it: flipping it rebuilds those services (and, transitively,
/// `currentUserProvider` and the router guard), so the app switches between
/// real and demo backends without a restart.

@ProviderFor(DemoMode)
final demoModeProvider = DemoModeProvider._();

/// The effective demo-mode state for the whole app.
///
/// When `true`, the service layer swaps in the in-memory fakes
/// (`DemoAuthService` / `DemoDatabaseService`) instead of the Appwrite-backed
/// implementations, so every view works without a backend or a login.
///
/// The value is `persisted user choice AND [demoModeIsAllowed]`: the stored
/// preference can never turn demo mode on in a build that does not allow it.
///
/// Kept alive because [authServiceProvider] and [databaseServiceProvider]
/// watch it: flipping it rebuilds those services (and, transitively,
/// `currentUserProvider` and the router guard), so the app switches between
/// real and demo backends without a restart.
final class DemoModeProvider extends $NotifierProvider<DemoMode, bool> {
  /// The effective demo-mode state for the whole app.
  ///
  /// When `true`, the service layer swaps in the in-memory fakes
  /// (`DemoAuthService` / `DemoDatabaseService`) instead of the Appwrite-backed
  /// implementations, so every view works without a backend or a login.
  ///
  /// The value is `persisted user choice AND [demoModeIsAllowed]`: the stored
  /// preference can never turn demo mode on in a build that does not allow it.
  ///
  /// Kept alive because [authServiceProvider] and [databaseServiceProvider]
  /// watch it: flipping it rebuilds those services (and, transitively,
  /// `currentUserProvider` and the router guard), so the app switches between
  /// real and demo backends without a restart.
  DemoModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoModeHash();

  @$internal
  @override
  DemoMode create() => DemoMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$demoModeHash() => r'bbafe07a543fb13ecebc72571346b39805d7f177';

/// The effective demo-mode state for the whole app.
///
/// When `true`, the service layer swaps in the in-memory fakes
/// (`DemoAuthService` / `DemoDatabaseService`) instead of the Appwrite-backed
/// implementations, so every view works without a backend or a login.
///
/// The value is `persisted user choice AND [demoModeIsAllowed]`: the stored
/// preference can never turn demo mode on in a build that does not allow it.
///
/// Kept alive because [authServiceProvider] and [databaseServiceProvider]
/// watch it: flipping it rebuilds those services (and, transitively,
/// `currentUserProvider` and the router guard), so the app switches between
/// real and demo backends without a restart.

abstract class _$DemoMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
