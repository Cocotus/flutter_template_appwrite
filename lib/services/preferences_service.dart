import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_template_appwrite/models/user_data.dart';
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

/// The app's local, non-sensitive store, built on [SharedPreferences].
///
/// **This is the authoritative store**, not a cache in front of Appwrite. Both
/// [UserSettings] and [UserData] are read from here at startup and written back
/// on every change, with no network involved. Appwrite is a sync layer on top,
/// touched only on login, on an explicit Save and on logout — see `CloudSync`.
///
/// That ordering is what lets a build with `HAS_LOGIN=false` work unchanged:
/// nothing about the app's own persistence depends on there being an account.
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
  static const String _userDataKey = 'user_data';
  static const String _lastSyncedAtKey = 'cloud_last_synced_at';

  /// Returns the stored [UserSettings], or `null` when nothing has been
  /// stored yet (first app start) or the stored value is unreadable.
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

  // --- User data -------------------------------------------------------------

  /// Returns the stored [UserData], or `null` when nothing is stored yet or the
  /// stored value is unreadable.
  ///
  /// A corrupt document returns `null` rather than throwing, matching
  /// [readCachedUserSettings] — the caller then starts from defaults instead of
  /// the app failing to open.
  UserData? readUserData() {
    final String? jsonText = _preferences.getString(_userDataKey);
    if (jsonText == null) {
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonText) as Map<String, dynamic>;
      return UserData.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  /// Stores [data] as the authoritative user-data document.
  ///
  /// Returns the number of characters written, so a caller that allows large
  /// documents can warn before running into a platform limit — on web the
  /// backing store is localStorage, roughly 5 MB per origin, with no error
  /// raised until it is exceeded.
  Future<int> writeUserData(UserData data) async {
    final String jsonText = jsonEncode(data.toJson());
    await _preferences.setString(_userDataKey, jsonText);
    return jsonText.length;
  }

  /// Removes the stored user data (used on logout).
  Future<void> clearUserData() async {
    await _preferences.remove(_userDataKey);
  }

  // --- Cloud sync bookkeeping ------------------------------------------------

  /// Returns when the configuration was last synced with Appwrite, or `null`
  /// when it never has been on this device.
  ///
  /// Shown in the settings page so "is my data in the cloud?" has a visible
  /// answer — the app deliberately never syncs on its own (see `CloudSync`).
  DateTime? readLastSyncedAt() {
    final String? stored = _preferences.getString(_lastSyncedAtKey);
    if (stored == null) {
      return null;
    }
    return DateTime.tryParse(stored);
  }

  /// Records [timestamp] as the moment of the last successful sync.
  Future<void> writeLastSyncedAt(DateTime timestamp) async {
    await _preferences.setString(
      _lastSyncedAtKey,
      timestamp.toIso8601String(),
    );
  }

  /// Forgets the last sync time (used on logout).
  Future<void> clearLastSyncedAt() async {
    await _preferences.remove(_lastSyncedAtKey);
  }
}

/// Provides the app-wide [PreferencesService] instance.
@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) {
  final SharedPreferences preferences = ref.watch(sharedPreferencesProvider);
  return PreferencesService(preferences: preferences);
}
