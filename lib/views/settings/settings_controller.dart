import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/cloud_sync/cloud_sync_controller.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/views/settings/settings_state.dart';

part 'settings_controller.g.dart';

/// Holds the settings page's unsaved [SettingsDraft].
///
/// Seeded from the live store, and re-seeded whenever it changes — after a
/// save, an import, or a pull following login — so the form never shows values
/// that no longer exist.
///
/// **Auto-dispose on purpose**, which is the opposite of the usual advice in
/// AGENTS.md §3. Everywhere else auto-dispose is a hazard because it throws away
/// state the app still needs; here throwing the state away is precisely the
/// feature. The provider lives exactly as long as the settings page is on
/// screen, so navigating away drops the draft and coming back starts from the
/// saved values. That is what makes "if the user does not want to save, they
/// just leave" true without a Cancel button and without any revert logic.
@riverpod
class SettingsDraftController extends _$SettingsDraftController {
  @override
  SettingsDraft build() {
    return SettingsDraft(
      userSettings: ref.watch(userSettingsServiceProvider),
    );
  }

  /// Replaces the app settings in the draft.
  void updateSettings(UserSettings userSettings) {
    state = state.copyWith(userSettings: userSettings);
  }
}

/// Owns the settings page's Save action and its progress.
///
/// Exposes `AsyncValue<void>` so the view can disable the form while a save
/// runs and show a snackbar when one fails. The values themselves live in
/// [SettingsDraftController] until saved, and in the shared store afterwards.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<void> build() {
    // No initial work needed; the screen starts in an idle data state.
  }

  /// Commits the current draft.
  ///
  /// Writes the store locally — which is what makes the new theme and language
  /// take effect — and then pushes everything to Appwrite. The push does
  /// nothing in a build without login or while nobody is signed in, so there is
  /// no branch here for it.
  ///
  /// This is one of only three places the app talks to Appwrite; the other two
  /// are the pull after login and the push on logout (see `CloudSync`).
  ///
  /// A failed *push* does not fail this method: `CloudSync` reports its own
  /// errors through its own state, which the settings page renders in the sync
  /// row. This state covers the local write, which is the part that decides
  /// whether the user's changes survive closing the app.
  Future<void> save() async {
    final LoggerService logger = ref.read(loggerServiceProvider);

    state = const AsyncValue<void>.loading();
    try {
      final SettingsDraft draft = ref.read(settingsDraftControllerProvider);

      final UserSettingsService settingsController =
          ref.read(userSettingsServiceProvider.notifier);
      await settingsController.save(draft.userSettings);

      await ref.read(cloudSyncProvider.notifier).push();

      logger.info('User settings saved');
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Saving user settings failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}
