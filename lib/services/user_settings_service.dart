import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

part 'user_settings_service.g.dart';

/// Holds and persists the current user's [UserSettings].
///
/// This lives in `services/` (not `controllers/`) because settings are shared,
/// cross-cutting state: theme, locale and the sidebar all depend on it, not just
/// one view.
///
/// ## Local only, on purpose
///
/// This controller knows nothing about Appwrite. `shared_preferences` is the
/// live, authoritative store: [build] reads it synchronously at startup so the
/// first frame already has the right theme and language, and [save] writes it
/// back. That is the whole persistence story here.
///
/// Getting the settings into the cloud is a separate, explicit step owned by
/// `CloudSync` — pull after login, push on Save and on logout. Keeping the two
/// apart is what lets a build with `HAS_LOGIN=false` use this class unchanged,
/// with no Appwrite code reachable at all.
///
/// Its counterpart for user-created content is `UserDataService`; see
/// [UserData] for why the two are separate stores.
@Riverpod(keepAlive: true)
class UserSettingsService extends _$UserSettingsService {
  @override
  UserSettings build() {
    final PreferencesService preferences =
        ref.read(preferencesServiceProvider);
    final UserSettings? storedSettings = preferences.readCachedUserSettings();

    if (storedSettings != null) {
      return storedSettings;
    }
    return const UserSettings();
  }

  /// Applies and persists [newSettings].
  ///
  /// The state — and with it the theme, locale and sidebar — updates
  /// immediately, then the value is written to `shared_preferences`.
  Future<void> save(UserSettings newSettings) async {
    state = newSettings;

    final PreferencesService preferences =
        ref.read(preferencesServiceProvider);
    await preferences.writeCachedUserSettings(newSettings);
  }

  /// Convenience setter used by the theme switch on the login screen.
  ///
  /// A direct one-tap action rather than a form field, so it applies and
  /// persists straight away — unlike the settings page, which collects its
  /// changes into a draft and commits them on Save.
  Future<void> setDarkMode(bool isDarkMode) async {
    final UserSettings newSettings = state.copyWith(isDarkMode: isDarkMode);
    await save(newSettings);
  }

  /// Convenience setter used by the sidebar collapse button.
  ///
  /// Also a direct action — see [setDarkMode].
  Future<void> setSidebarCollapsed(bool isCollapsed) async {
    final UserSettings newSettings =
        state.copyWith(sidebarCollapsed: isCollapsed);
    await save(newSettings);
  }
}
