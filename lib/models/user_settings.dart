import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Per-user application settings.
///
/// Exactly one settings row exists per user in the Appwrite `user_settings`
/// table; the row ID equals the Appwrite user ID (see `DatabaseService`).
/// The same JSON shape is also cached locally in `shared_preferences` so the
/// UI can show the last known settings instantly while the remote row loads.
///
/// Every field has a default value (`@Default`) so that `fromJson` tolerates
/// rows or caches that are missing a column, e.g. after adding a new setting
/// to a template that is already in production.
@freezed
abstract class UserSettings with _$UserSettings {
  /// Creates a [UserSettings] instance.
  const factory UserSettings({
    /// Whether the app uses the dark Material 3 color scheme.
    @Default(false) bool isDarkMode,

    /// The active UI language code, e.g. `en` or `de`.
    @Default('en') String languageCode,

    /// Whether the user manually collapsed the navigation sidebar.
    @Default(false) bool sidebarCollapsed,

    /// The accent (seed) color as a 32-bit ARGB integer.
    ///
    /// The whole Material 3 palette is derived from this single color via
    /// `ColorScheme.fromSeed` (see `AppTheme`), for both light and dark mode.
    /// Stored as an int so it serializes cleanly to JSON / Appwrite; the
    /// default matches the template's original blue seed.
    @Default(0xFF3D5AFE) int accentColorValue,

    /// Whether developer mode is enabled.
    ///
    /// Developer mode reveals the "Logs" entry in the sidebar so the user
    /// can inspect live Talker logs inside the app (always visible in
    /// debug builds regardless of this flag).
    @Default(false) bool developerMode,

    /// Optional display name shown in the profile and sidebar avatar.
    @Default('') String displayName,
  }) = _UserSettings;

  /// Creates a [UserSettings] instance from a JSON map.
  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
