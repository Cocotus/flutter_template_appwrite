// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the settings view.
///
/// Exposes the save progress as `AsyncValue<void>`: the view disables its
/// inputs while a save is running and shows a snackbar when a save fails.
/// The settings values themselves live in `UserSettingsController` (they
/// are shared, cross-cutting state); this controller only orchestrates
/// changes coming from this one view.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Controller for the settings view.
///
/// Exposes the save progress as `AsyncValue<void>`: the view disables its
/// inputs while a save is running and shows a snackbar when a save fails.
/// The settings values themselves live in `UserSettingsController` (they
/// are shared, cross-cutting state); this controller only orchestrates
/// changes coming from this one view.
final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, void> {
  /// Controller for the settings view.
  ///
  /// Exposes the save progress as `AsyncValue<void>`: the view disables its
  /// inputs while a save is running and shows a snackbar when a save fails.
  /// The settings values themselves live in `UserSettingsController` (they
  /// are shared, cross-cutting state); this controller only orchestrates
  /// changes coming from this one view.
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
    r'614003d43e5b58a7bc860a061e6255378434c6d1';

/// Controller for the settings view.
///
/// Exposes the save progress as `AsyncValue<void>`: the view disables its
/// inputs while a save is running and shows a snackbar when a save fails.
/// The settings values themselves live in `UserSettingsController` (they
/// are shared, cross-cutting state); this controller only orchestrates
/// changes coming from this one view.

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
