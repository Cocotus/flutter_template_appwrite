import 'package:flutter/material.dart';

/// Builds the app's Material 3 [ThemeData] from a single seed color.
///
/// One place owns the whole look — the design concept is a modern
/// "dashboard" style web UI in a dark navy tone:
///
/// * Header bar and sidebar use a fixed **brand navy** surface in BOTH light
///   and dark mode (like many modern SaaS apps). The navy is subtly tinted
///   with the user's accent color, so switching the accent is clearly
///   visible even in light mode.
/// * The color schemes are derived via `ColorScheme.fromSeed` with the
///   **vibrant** scheme variant, which keeps noticeably more of the seed's
///   saturation than the default (fixes the "washed out" Material 3 look).
/// * Dark mode uses a deep navy surface ladder instead of the default
///   Material grey, light mode gets a softly seed-tinted background.
/// * All component styling (buttons, inputs, cards, dialogs, sidebar) is
///   defined HERE, never at the call site — restyle by editing this file.
class AppTheme {
  // Namespace for static builders; never instantiated.
  const AppTheme._();

  /// The fallback seed color used before any user setting is known.
  static const Color defaultSeedColor = Color(0xFF3D5AFE);

  // The deep navy base that header + sidebar are built from. The user's
  // accent color is blended on top (see [brandSurface]).
  static const Color _brandNavyBase = Color(0xFF0D1526);

  // Shared corner radii so every control family feels consistent.
  static const double _controlRadius = 12;
  static const double _cardRadius = 16;

  /// The header/sidebar background: brand navy tinted with the accent color.
  ///
  /// Used in both light and dark mode, so the shell always keeps its modern
  /// dark-navy identity while the content area follows the theme mode.
  static Color brandSurface(Color seedColor) {
    // 18% accent over deep navy: dark enough for white text, but the accent
    // hue clearly shines through when the user changes it.
    return Color.alphaBlend(
      seedColor.withValues(alpha: 0.18),
      _brandNavyBase,
    );
  }

  /// Foreground color for text/icons that sit on [brandSurface].
  static const Color onBrandSurface = Colors.white;

  /// Muted foreground for secondary items on [brandSurface].
  static final Color onBrandSurfaceMuted =
      Colors.white.withValues(alpha: 0.65);

  /// Builds the theme for the given [brightness], seeded from [seedColor].
  static ThemeData build({
    required Brightness brightness,
    Color seedColor = defaultSeedColor,
  }) {
    final bool isDark = brightness == Brightness.dark;

    // "vibrant" keeps much more of the seed's chroma than the default
    // tonal-spot variant — this is what makes the accent color actually
    // look like the accent color, especially in light mode.
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    if (isDark) {
      // Replace the default Material dark greys with a deep navy surface
      // ladder (each step slightly lighter), tinted with a hint of accent.
      colorScheme = _applyNavySurfaces(colorScheme, seedColor);
    }

    final Color shellColor = brandSurface(seedColor);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _scaffoldBackground(colorScheme, seedColor),
      appBarTheme: _appBarTheme(shellColor),
      navigationRailTheme: _navigationRailTheme(shellColor, seedColor),
      filledButtonTheme: _filledButtonTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      chipTheme: _chipTheme(),
      segmentedButtonTheme: _segmentedButtonTheme(),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_controlRadius),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        strokeCap: StrokeCap.round,
      ),
      tooltipTheme: _tooltipTheme(colorScheme),
    );
  }

  // ---------------------------------------------------------------------
  // Colors & surfaces
  // ---------------------------------------------------------------------

  // Dark mode: swap the generated grey surfaces for a deep navy ladder.
  // Each level is a fixed navy blended with a small amount of accent so the
  // whole dark UI harmonizes with the chosen seed.
  static ColorScheme _applyNavySurfaces(ColorScheme scheme, Color seedColor) {
    Color navy(int base) {
      // 6% accent tint keeps the navy neutral but "in family" with the seed.
      return Color.alphaBlend(seedColor.withValues(alpha: 0.06), Color(base));
    }

    return scheme.copyWith(
      surface: navy(0xFF0B1220),
      surfaceContainerLowest: navy(0xFF070D18),
      surfaceContainerLow: navy(0xFF0F1728),
      surfaceContainer: navy(0xFF121B2E),
      surfaceContainerHigh: navy(0xFF172136),
      surfaceContainerHighest: navy(0xFF1D2840),
      onSurface: const Color(0xFFE3E9F2),
      onSurfaceVariant: const Color(0xFF9AA8BF),
      outline: const Color(0xFF465671),
      outlineVariant: const Color(0xFF27334B),
    );
  }

  // Light mode gets a soft, seed-tinted off-white so pages never look like
  // bare paper; dark mode uses the navy surface directly.
  static Color _scaffoldBackground(ColorScheme scheme, Color seedColor) {
    if (scheme.brightness == Brightness.dark) {
      return scheme.surface;
    }
    return Color.alphaBlend(
      seedColor.withValues(alpha: 0.04),
      const Color(0xFFF7F9FC),
    );
  }

  // ---------------------------------------------------------------------
  // Shell (header + sidebar)
  // ---------------------------------------------------------------------

  static AppBarTheme _appBarTheme(Color shellColor) {
    return AppBarTheme(
      backgroundColor: shellColor,
      foregroundColor: onBrandSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: onBrandSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }

  // Sidebar (NavigationRail): dark navy with an accent-tinted pill indicator
  // and white labels. Font sizes live here rather than at the call site.
  static NavigationRailThemeData _navigationRailTheme(
    Color shellColor,
    Color seedColor,
  ) {
    const double labelFontSize = 14;

    return NavigationRailThemeData(
      backgroundColor: shellColor,
      // Accent-tinted selection pill — clearly visible on the navy surface.
      indicatorColor: seedColor.withValues(alpha: 0.38),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_controlRadius),
      ),
      selectedIconTheme: const IconThemeData(color: onBrandSurface),
      unselectedIconTheme: IconThemeData(color: onBrandSurfaceMuted),
      selectedLabelTextStyle: const TextStyle(
        fontSize: labelFontSize,
        fontWeight: FontWeight.w600,
        color: onBrandSurface,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: labelFontSize,
        color: onBrandSurfaceMuted,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Buttons — one shared shape/typography for every button family
  // ---------------------------------------------------------------------

  static RoundedRectangleBorder get _buttonShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_controlRadius),
    );
  }

  static const TextStyle _buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const EdgeInsets _buttonPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: _buttonShape,
        padding: _buttonPadding,
        textStyle: _buttonTextStyle,
        minimumSize: const Size(64, 48),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: _buttonShape,
        padding: _buttonPadding,
        textStyle: _buttonTextStyle,
        minimumSize: const Size(64, 48),
        elevation: 1,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: _buttonShape,
        padding: _buttonPadding,
        textStyle: _buttonTextStyle,
        minimumSize: const Size(64, 48),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: _buttonShape,
        textStyle: _buttonTextStyle,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Inputs — filled fields with rounded corners and a clear focus ring
  // ---------------------------------------------------------------------

  static InputDecorationTheme _inputDecorationTheme(ColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;

    // Subtle filled background so fields are visible without heavy borders.
    final Color fillColor = isDark
        ? scheme.surfaceContainerHigh
        : scheme.surfaceContainerHighest.withValues(alpha: 0.55);

    OutlineInputBorder borderWith(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(_controlRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      // Resting state: hairline outline; focus: 2px accent ring.
      enabledBorder:
          borderWith(scheme.outlineVariant.withValues(alpha: 0.8), 1),
      focusedBorder: borderWith(scheme.primary, 2),
      errorBorder: borderWith(scheme.error, 1),
      focusedErrorBorder: borderWith(scheme.error, 2),
      border: borderWith(scheme.outlineVariant, 1),
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
    );
  }

  // ---------------------------------------------------------------------
  // Containers & feedback
  // ---------------------------------------------------------------------

  static CardThemeData _cardTheme(ColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;

    return CardThemeData(
      // Flat, bordered cards read as "modern web" better than shadows.
      elevation: 0,
      color: isDark ? scheme.surfaceContainerLow : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme scheme) {
    return DialogThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme scheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_controlRadius),
      ),
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
    );
  }

  static ChipThemeData _chipTheme() {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide.none,
      ),
    );
  }

  static SegmentedButtonThemeData _segmentedButtonTheme() {
    return SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_controlRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TooltipThemeData _tooltipTheme(ColorScheme scheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: scheme.onInverseSurface, fontSize: 13),
    );
  }
}
