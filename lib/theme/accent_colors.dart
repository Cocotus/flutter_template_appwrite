import 'package:flutter/material.dart';

/// A selectable accent color offered on the settings page.
///
/// Each entry is just a seed color plus a human-readable [name] (shown as a
/// tooltip on its swatch). The whole app palette is derived from the chosen
/// seed via `ColorScheme.fromSeed` — see `AppTheme`.
class AccentColor {
  /// Creates an [AccentColor] preset.
  const AccentColor({required this.name, required this.color});

  /// Short label shown as the swatch tooltip, e.g. "Blue".
  final String name;

  /// The seed color this preset applies.
  final Color color;

  /// This preset's color as the ARGB int stored in `UserSettings`.
  int get value => color.toARGB32();
}

/// The curated palette shown in the settings accent-color picker.
///
/// Add or remove entries here to change the offered colors; nothing else in
/// the app needs to change. The first entry's color also serves as the
/// app-wide default seed (see `AppTheme.defaultSeedColor`).
const List<AccentColor> accentColorPresets = <AccentColor>[
  AccentColor(name: 'Blue', color: Color(0xFF3D5AFE)),
  AccentColor(name: 'Light Blue', color: Color(0xFF0288D1)),
  AccentColor(name: 'Cyan', color: Color(0xFF0097A7)),
  AccentColor(name: 'Teal', color: Color(0xFF009688)),
  AccentColor(name: 'Green', color: Color(0xFF2E7D32)),
  AccentColor(name: 'Light Green', color: Color(0xFF689F38)),
  AccentColor(name: 'Lime', color: Color(0xFF9E9D24)),
  AccentColor(name: 'Amber', color: Color(0xFFFF8F00)),
  AccentColor(name: 'Orange', color: Color(0xFFF57C00)),
  AccentColor(name: 'Deep Orange', color: Color(0xFFE64A19)),
  AccentColor(name: 'Red', color: Color(0xFFD32F2F)),
  AccentColor(name: 'Pink', color: Color(0xFFC2185B)),
  AccentColor(name: 'Purple', color: Color(0xFF7B1FA2)),
  AccentColor(name: 'Deep Purple', color: Color(0xFF512DA8)),
  AccentColor(name: 'Indigo', color: Color(0xFF3F51B5)),
  AccentColor(name: 'Brown', color: Color(0xFF6D4C41)),
  AccentColor(name: 'Blue Grey', color: Color(0xFF546E7A)),
];
