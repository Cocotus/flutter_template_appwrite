import 'package:flutter/material.dart';

/// Builds the app's Material 3 [ThemeData] from a single seed color.
///
/// One place owns the whole look: change the seed (per user, via the accent
/// color setting) or tweak [_navigationRailTheme] here, and it applies
/// everywhere. Both light and dark schemes are derived from the same seed
/// through `ColorScheme.fromSeed`, so colors stay harmonious in either mode.
class AppTheme {
  // Namespace for static builders; never instantiated.
  const AppTheme._();

  /// The fallback seed color used before any user setting is known.
  static const Color defaultSeedColor = Color(0xFF3D5AFE);

  /// Builds the theme for the given [brightness], seeded from [seedColor].
  static ThemeData build({
    required Brightness brightness,
    Color seedColor = defaultSeedColor,
  }) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Slightly larger, easier-to-read sidebar labels (see request).
      navigationRailTheme: _navigationRailTheme(colorScheme),
    );
  }

  // Sidebar (NavigationRail) styling. Font sizes live here rather than being
  // hard-coded at each call site, so the whole sidebar restyles in one edit.
  static NavigationRailThemeData _navigationRailTheme(
    ColorScheme colorScheme,
  ) {
    const double labelFontSize = 15;

    return NavigationRailThemeData(
      selectedLabelTextStyle: TextStyle(
        fontSize: labelFontSize,
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: labelFontSize,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
