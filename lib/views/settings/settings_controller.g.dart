// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the settings page's unsaved [SettingsDraft].
///
/// Seeded from the live store, and re-seeded whenever it changes — after a
/// save, an import, or a pull following login — so the form never shows values
/// that no longer exist.
///
/// **Auto-dispose on purpose**, which is the opposite of the usual advice in
/// AGENTS.md §3. Everywhere else auto-dispose is a hazard because it throws away
/// state the app still needs; here throwing the state away is precisely the
/// feature. The provider lives exactly as long as the settings page is on
/// screen, so navigating away drops the draft and coming back starts from the
/// saved values. That is what makes "if the user does not want to save, they
/// just leave" true without a Cancel button and without any revert logic.

@ProviderFor(SettingsDraftController)
final settingsDraftControllerProvider = SettingsDraftControllerProvider._();

/// Holds the settings page's unsaved [SettingsDraft].
///
/// Seeded from the live store, and re-seeded whenever it changes — after a
/// save, an import, or a pull following login — so the form never shows values
/// that no longer exist.
///
/// **Auto-dispose on purpose**, which is the opposite of the usual advice in
/// AGENTS.md §3. Everywhere else auto-dispose is a hazard because it throws away
/// state the app still needs; here throwing the state away is precisely the
/// feature. The provider lives exactly as long as the settings page is on
/// screen, so navigating away drops the draft and coming back starts from the
/// saved values. That is what makes "if the user does not want to save, they
/// just leave" true without a Cancel button and without any revert logic.
final class SettingsDraftControllerProvider
    extends $NotifierProvider<SettingsDraftController, SettingsDraft> {
  /// Holds the settings page's unsaved [SettingsDraft].
  ///
  /// Seeded from the live store, and re-seeded whenever it changes — after a
  /// save, an import, or a pull following login — so the form never shows values
  /// that no longer exist.
  ///
  /// **Auto-dispose on purpose**, which is the opposite of the usual advice in
  /// AGENTS.md §3. Everywhere else auto-dispose is a hazard because it throws away
  /// state the app still needs; here throwing the state away is precisely the
  /// feature. The provider lives exactly as long as the settings page is on
  /// screen, so navigating away drops the draft and coming back starts from the
  /// saved values. That is what makes "if the user does not want to save, they
  /// just leave" true without a Cancel button and without any revert logic.
  SettingsDraftControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsDraftControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsDraftControllerHash();

  @$internal
  @override
  SettingsDraftController create() => SettingsDraftController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsDraft>(value),
    );
  }
}

String _$settingsDraftControllerHash() =>
    r'a6a42943a5fc9e19a58a5162cdf87b72a1d641dd';

/// Holds the settings page's unsaved [SettingsDraft].
///
/// Seeded from the live store, and re-seeded whenever it changes — after a
/// save, an import, or a pull following login — so the form never shows values
/// that no longer exist.
///
/// **Auto-dispose on purpose**, which is the opposite of the usual advice in
/// AGENTS.md §3. Everywhere else auto-dispose is a hazard because it throws away
/// state the app still needs; here throwing the state away is precisely the
/// feature. The provider lives exactly as long as the settings page is on
/// screen, so navigating away drops the draft and coming back starts from the
/// saved values. That is what makes "if the user does not want to save, they
/// just leave" true without a Cancel button and without any revert logic.

abstract class _$SettingsDraftController extends $Notifier<SettingsDraft> {
  SettingsDraft build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SettingsDraft, SettingsDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsDraft, SettingsDraft>,
              SettingsDraft,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Owns the settings page's Save action and its progress.
///
/// Exposes `AsyncValue<void>` so the view can disable the form while a save
/// runs and show a snackbar when one fails. The values themselves live in
/// [SettingsDraftController] until saved, and in the shared store afterwards.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Owns the settings page's Save action and its progress.
///
/// Exposes `AsyncValue<void>` so the view can disable the form while a save
/// runs and show a snackbar when one fails. The values themselves live in
/// [SettingsDraftController] until saved, and in the shared store afterwards.
final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, void> {
  /// Owns the settings page's Save action and its progress.
  ///
  /// Exposes `AsyncValue<void>` so the view can disable the form while a save
  /// runs and show a snackbar when one fails. The values themselves live in
  /// [SettingsDraftController] until saved, and in the shared store afterwards.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'3a3db3a47aaee6d82a2c063cb5185f4c035724c2';

/// Owns the settings page's Save action and its progress.
///
/// Exposes `AsyncValue<void>` so the view can disable the form while a save
/// runs and show a snackbar when one fails. The values themselves live in
/// [SettingsDraftController] until saved, and in the shared store afterwards.

abstract class _$SettingsController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
