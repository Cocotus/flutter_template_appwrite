import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'theme_service.g.dart';

/// Exposes the current dark-mode flag and a [toggle] action.
///
/// The single source of truth is [UserSettings.isDarkMode] (held by
/// `UserSettingsController`): before login it comes from the local cache,
/// after login the value loaded from Appwrite takes over. This service
/// simply mirrors that flag reactively, so `app.dart` and the login view
/// have one obvious place to read and switch the theme.
@Riverpod(keepAlive: true)
class ThemeService extends _$ThemeService {
  @override
  bool build() {
    // Rebuilds automatically whenever the settings change (e.g. after the
    // remote settings arrive post-login).
    final UserSettings settings = ref.watch(userSettingsControllerProvider);
    return settings.isDarkMode;
  }

  /// Switches between light and dark mode and persists the choice
  /// (local cache always; Appwrite too when logged in).
  Future<void> toggle() async {
    final bool newIsDarkMode = !state;

    final UserSettingsController settingsController =
        ref.read(userSettingsControllerProvider.notifier);
    await settingsController.setDarkMode(newIsDarkMode);
  }
}
