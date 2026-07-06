import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'settings_controller.g.dart';

/// Controller for the settings view.
///
/// Exposes the save progress as `AsyncValue<void>`: the view disables its
/// inputs while a save is running and shows a snackbar when a save fails.
/// The settings values themselves live in `UserSettingsController` (they
/// are shared, cross-cutting state); this controller only orchestrates
/// changes coming from this one view.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<void> build() {
    // No initial work needed; the screen starts in an idle data state.
  }

  /// Turns dark mode on or off.
  Future<void> setDarkMode(bool isDarkMode) async {
    final UserSettings currentSettings =
        ref.read(userSettingsControllerProvider);
    final UserSettings newSettings =
        currentSettings.copyWith(isDarkMode: isDarkMode);
    await _save(newSettings);
  }

  /// Switches the app language, e.g. to `en` or `de`.
  Future<void> setLanguageCode(String languageCode) async {
    final UserSettings currentSettings =
        ref.read(userSettingsControllerProvider);
    final UserSettings newSettings =
        currentSettings.copyWith(languageCode: languageCode);
    await _save(newSettings);
  }

  /// Enables or disables developer mode (reveals the Logs sidebar entry).
  Future<void> setDeveloperMode(bool isDeveloperModeEnabled) async {
    final UserSettings currentSettings =
        ref.read(userSettingsControllerProvider);
    final UserSettings newSettings =
        currentSettings.copyWith(developerMode: isDeveloperModeEnabled);
    await _save(newSettings);
  }

  /// Updates the display name shown in the avatar and greeting.
  Future<void> setDisplayName(String displayName) async {
    final UserSettings currentSettings =
        ref.read(userSettingsControllerProvider);
    final UserSettings newSettings =
        currentSettings.copyWith(displayName: displayName.trim());
    await _save(newSettings);
  }

  // Persists the new settings (local cache + Appwrite) and tracks the
  // request state for the view.
  Future<void> _save(UserSettings newSettings) async {
    final LoggerService logger = ref.read(loggerServiceProvider);

    state = const AsyncValue<void>.loading();
    try {
      final UserSettingsController settingsController =
          ref.read(userSettingsControllerProvider.notifier);
      await settingsController.save(newSettings);

      logger.info('User settings saved');
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Saving user settings failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}
