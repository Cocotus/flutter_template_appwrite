// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the current dark-mode flag and a [toggle] action.
///
/// The single source of truth is [UserSettings.isDarkMode] (held by
/// `UserSettingsService`): before login it comes from the local cache,
/// after login the value loaded from Appwrite takes over. This service
/// simply mirrors that flag reactively, so `app.dart` and the login view
/// have one obvious place to read and switch the theme.

@ProviderFor(ThemeService)
final themeServiceProvider = ThemeServiceProvider._();

/// Exposes the current dark-mode flag and a [toggle] action.
///
/// The single source of truth is [UserSettings.isDarkMode] (held by
/// `UserSettingsService`): before login it comes from the local cache,
/// after login the value loaded from Appwrite takes over. This service
/// simply mirrors that flag reactively, so `app.dart` and the login view
/// have one obvious place to read and switch the theme.
final class ThemeServiceProvider extends $NotifierProvider<ThemeService, bool> {
  /// Exposes the current dark-mode flag and a [toggle] action.
  ///
  /// The single source of truth is [UserSettings.isDarkMode] (held by
  /// `UserSettingsService`): before login it comes from the local cache,
  /// after login the value loaded from Appwrite takes over. This service
  /// simply mirrors that flag reactively, so `app.dart` and the login view
  /// have one obvious place to read and switch the theme.
  ThemeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeServiceHash();

  @$internal
  @override
  ThemeService create() => ThemeService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$themeServiceHash() => r'2c361e10d09c63a06b2c0ff77f86d46580bafccf';

/// Exposes the current dark-mode flag and a [toggle] action.
///
/// The single source of truth is [UserSettings.isDarkMode] (held by
/// `UserSettingsService`): before login it comes from the local cache,
/// after login the value loaded from Appwrite takes over. This service
/// simply mirrors that flag reactively, so `app.dart` and the login view
/// have one obvious place to read and switch the theme.

abstract class _$ThemeService extends $Notifier<bool> {
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
