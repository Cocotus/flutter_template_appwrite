import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';

part 'settings_state.freezed.dart';

/// The settings page's working copy of everything it can change.
///
/// The page is a **form**, not a set of live switches: every control edits this
/// draft, and nothing reaches a store until the user presses Save. Leaving the
/// page throws the draft away, which is why there is no Cancel button — walking
/// away *is* cancelling.
///
/// An earlier version of this template persisted on every widget event, which
/// meant a `shared_preferences` write and an Appwrite round trip per switch
/// flip, per colour swatch and per dropdown selection. Collecting the changes
/// here instead turns a settings session into exactly one write.
///
/// When your app adds a second editable model to this page, add it as another
/// field here rather than giving it its own save path.
@freezed
abstract class SettingsDraft with _$SettingsDraft {
  /// Creates a [SettingsDraft].
  const factory SettingsDraft({
    /// Theme, language, accent, developer mode and display name.
    @Default(UserSettings()) UserSettings userSettings,
  }) = _SettingsDraft;
}
