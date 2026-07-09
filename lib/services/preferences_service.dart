import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';

part 'preferences_service.g.dart';

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
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart '
    '(and in tests) with a loaded SharedPreferences instance.',
  );
}

/// Local, non-sensitive cache built on [SharedPreferences].
///
/// Used for the cached [UserSettings] copy so the UI can start with the
/// last known settings instantly, before the authoritative row is fetched
/// from Appwrite ("local first, remote wins" — see `UserSettingsController`).
///
/// Do NOT store secrets here — use `SecureStorageService` for anything
/// sensitive.
class PreferencesService {
  /// Creates a [PreferencesService] on top of a loaded SharedPreferences
  /// instance (callers pass it as `preferences:`).
  PreferencesService({required this._preferences});

  final SharedPreferences _preferences;

  static const String _userSettingsKey = 'cached_user_settings';
  static const String _demoModeKey = 'demo_mode_enabled';

  /// Returns the locally cached [UserSettings], or `null` when nothing has
  /// been cached yet (first app start) or the cache is unreadable.
  UserSettings? readCachedUserSettings() {
    final String? jsonText = _preferences.getString(_userSettingsKey);
    if (jsonText == null) {
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonText) as Map<String, dynamic>;
      return UserSettings.fromJson(jsonMap);
    } catch (_) {
      // A corrupt cache is not worth crashing over — fall back to defaults.
      return null;
    }
  }

  /// Stores [settings] as the local cache copy.
  Future<void> writeCachedUserSettings(UserSettings settings) async {
    final String jsonText = jsonEncode(settings.toJson());
    await _preferences.setString(_userSettingsKey, jsonText);
  }

  /// Removes the cached settings (used on logout).
  Future<void> clearCachedUserSettings() async {
    await _preferences.remove(_userSettingsKey);
  }

  /// Returns the last chosen demo-mode preference (defaults to `false`).
  ///
  /// This is only the *stored user choice*; whether demo mode is actually
  /// active also depends on the compile-time [AppConfig.demoModeAllowed]
  /// gate — see the `DemoMode` provider.
  bool readDemoMode() {
    return _preferences.getBool(_demoModeKey) ?? false;
  }

  /// Persists the demo-mode [enabled] choice.
  Future<void> writeDemoMode({required bool enabled}) async {
    await _preferences.setBool(_demoModeKey, enabled);
  }
}

/// Provides the app-wide [PreferencesService] instance.
@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) {
  final SharedPreferences preferences = ref.watch(sharedPreferencesProvider);
  return PreferencesService(preferences: preferences);
}
