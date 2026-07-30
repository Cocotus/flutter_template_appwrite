import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_template_appwrite/theme/app_theme.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Per-user application settings.
///
/// Stored locally in `shared_preferences` — that copy is authoritative and is
/// what the app reads at startup. When a build ships with `HAS_LOGIN=true` the
/// same JSON also goes into the user's Appwrite account-preferences object, so
/// signing in on another machine brings it along (see `CloudSyncService`).
///
/// This is **configuration**: a fixed, small set of scalars the user picks from
/// a form. Anything the user *creates* — and that therefore grows without
/// bound — belongs in [UserData] instead, which has a different storage route
/// for exactly that reason.
///
/// Every field has a default value (`@Default`) so that `fromJson` tolerates
/// stored copies that are missing a key, e.g. after adding a new setting to a
/// build that is already in production.
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
    /// Stored as an int so it serializes cleanly to JSON / Appwrite. The
    /// default references [AppTheme.defaultSeedColorValue] instead of
    /// repeating the literal, so the app's default accent lives in exactly
    /// one place.
    @Default(AppTheme.defaultSeedColorValue) int accentColorValue,

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
