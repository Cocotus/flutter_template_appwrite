// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the active app [Locale], backed by [UserSettings.languageCode].
///
/// `app.dart` passes this to `MaterialApp.router(locale: ...)`, so changing
/// the language in the settings view re-renders the whole app immediately.

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// Provides the active app [Locale], backed by [UserSettings.languageCode].
///
/// `app.dart` passes this to `MaterialApp.router(locale: ...)`, so changing
/// the language in the settings view re-renders the whole app immediately.

final class AppLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// Provides the active app [Locale], backed by [UserSettings.languageCode].
  ///
  /// `app.dart` passes this to `MaterialApp.router(locale: ...)`, so changing
  /// the language in the settings view re-renders the whole app immediately.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'280224ba680aa100f7c14ec70ebd763c44599715';
