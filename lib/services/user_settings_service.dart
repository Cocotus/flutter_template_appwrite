import 'package:appwrite/models.dart' as appwrite_models;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

part 'user_settings_service.g.dart';

/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are
/// shared, cross-cutting state: theme, locale and the sidebar all depend on
/// it, not just one view.
///
/// Settings precedence ("local first, remote wins"):
/// 1. [build] returns sane defaults, merged with the local
///    `shared_preferences` cache, so the UI renders instantly.
/// 2. After login, [loadForCurrentUser] fetches the authoritative row from
///    Appwrite and replaces the state once it arrives.
/// 3. Every change via [save] is written to BOTH the local cache and the
///    Appwrite row.
@Riverpod(keepAlive: true)
class UserSettingsController extends _$UserSettingsController {
  @override
  UserSettings build() {
    // Start from the last locally cached settings so theme/language are
    // right immediately — even before login and before any network call.
    final PreferencesService preferences =
        ref.read(preferencesServiceProvider);
    final UserSettings? cachedSettings = preferences.readCachedUserSettings();

    if (cachedSettings != null) {
      return cachedSettings;
    }
    return const UserSettings();
  }

  /// Loads the settings of the currently logged-in user from Appwrite.
  ///
  /// Called right after a successful login. When the user has no settings
  /// row yet (e.g. registered on another device but never saved settings),
  /// defaults are created remotely instead.
  Future<void> loadForCurrentUser() async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    final String userId = await _requireCurrentUserId();

    final DatabaseService databaseService =
        ref.read(databaseServiceProvider);
    final UserSettings? remoteSettings =
        await databaseService.loadUserSettings(userId: userId);

    if (remoteSettings == null) {
      logger.info('No remote settings row yet — creating defaults');
      await createDefaultsForCurrentUser();
      return;
    }

    // Remote wins over the local cache once it is available.
    state = remoteSettings;
    final PreferencesService preferences =
        ref.read(preferencesServiceProvider);
    await preferences.writeCachedUserSettings(remoteSettings);

    logger.info('User settings loaded from Appwrite');
  }

  /// Creates the initial settings row for the current user.
  ///
  /// Called right after registration. The current (default/cached) state is
  /// used as the initial remote value.
  Future<void> createDefaultsForCurrentUser() async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    final String userId = await _requireCurrentUserId();

    final DatabaseService databaseService =
        ref.read(databaseServiceProvider);
    await databaseService.saveUserSettings(
      userId: userId,
      settings: state,
    );

    logger.info('Default user settings created in Appwrite');
  }

  /// Applies and persists [newSettings].
  ///
  /// The state (and with it theme, locale, sidebar) updates immediately;
  /// persistence happens afterwards: always to the local cache, and to
  /// Appwrite only when a user is logged in (before login there is no row
  /// to write to — e.g. the theme toggle on the login screen).
  Future<void> save(UserSettings newSettings) async {
    state = newSettings;

    final PreferencesService preferences =
        ref.read(preferencesServiceProvider);
    await preferences.writeCachedUserSettings(newSettings);

    final String? userId = _currentUserIdOrNull();
    if (userId == null) {
      // Not logged in: cache-only persistence is intentional here.
      return;
    }

    final DatabaseService databaseService =
        ref.read(databaseServiceProvider);
    await databaseService.saveUserSettings(
      userId: userId,
      settings: newSettings,
    );
  }

  /// Convenience setter used by the theme switch.
  Future<void> setDarkMode(bool isDarkMode) async {
    final UserSettings newSettings = state.copyWith(isDarkMode: isDarkMode);
    await save(newSettings);
  }

  /// Convenience setter used by the sidebar collapse button.
  Future<void> setSidebarCollapsed(bool isCollapsed) async {
    final UserSettings newSettings =
        state.copyWith(sidebarCollapsed: isCollapsed);
    await save(newSettings);
  }

  // Returns the current user's ID, or null when nobody is logged in.
  String? _currentUserIdOrNull() {
    final appwrite_models.User? user =
        ref.read(currentUserProvider).value;
    return user?.$id;
  }

  // Returns the current user's ID or throws — for operations that only
  // make sense while logged in.
  Future<String> _requireCurrentUserId() async {
    // Make sure the auth state is actually resolved (not still loading).
    final appwrite_models.User? user =
        await ref.read(currentUserProvider.future);
    if (user == null) {
      throw StateError('No user is logged in');
    }
    return user.$id;
  }
}
