// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [SharedPreferences] instance.
///
/// [SharedPreferences.getInstance] is asynchronous, so `main.dart` loads it
/// once before `runApp` and overrides this provider with the real instance:
///
/// ```dart
/// final SharedPreferences preferences = await SharedPreferences.getInstance();
/// runApp(
///   ProviderScope(
///     overrides: <Override>[
///       sharedPreferencesProvider.overrideWithValue(preferences),
///     ],
///     child: const App(),
///   ),
/// );
/// ```
///
/// This keeps every later read synchronous and simple.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides the [SharedPreferences] instance.
///
/// [SharedPreferences.getInstance] is asynchronous, so `main.dart` loads it
/// once before `runApp` and overrides this provider with the real instance:
///
/// ```dart
/// final SharedPreferences preferences = await SharedPreferences.getInstance();
/// runApp(
///   ProviderScope(
///     overrides: <Override>[
///       sharedPreferencesProvider.overrideWithValue(preferences),
///     ],
///     child: const App(),
///   ),
/// );
/// ```
///
/// This keeps every later read synchronous and simple.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Provides the [SharedPreferences] instance.
  ///
  /// [SharedPreferences.getInstance] is asynchronous, so `main.dart` loads it
  /// once before `runApp` and overrides this provider with the real instance:
  ///
  /// ```dart
  /// final SharedPreferences preferences = await SharedPreferences.getInstance();
  /// runApp(
  ///   ProviderScope(
  ///     overrides: <Override>[
  ///       sharedPreferencesProvider.overrideWithValue(preferences),
  ///     ],
  ///     child: const App(),
  ///   ),
  /// );
  /// ```
  ///
  /// This keeps every later read synchronous and simple.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'3ac173864301fe9a55e7af10d823abbba62e6b97';

/// Provides the app-wide [PreferencesService] instance.

@ProviderFor(preferencesService)
final preferencesServiceProvider = PreferencesServiceProvider._();

/// Provides the app-wide [PreferencesService] instance.

final class PreferencesServiceProvider
    extends
        $FunctionalProvider<
          PreferencesService,
          PreferencesService,
          PreferencesService
        >
    with $Provider<PreferencesService> {
  /// Provides the app-wide [PreferencesService] instance.
  PreferencesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesServiceHash();

  @$internal
  @override
  $ProviderElement<PreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreferencesService create(Ref ref) {
    return preferencesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesService>(value),
    );
  }
}

String _$preferencesServiceHash() =>
    r'10785a707ea9b39fe1a59ebcb3bd381caa7ea3cf';
