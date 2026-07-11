import 'package:flutter/material.dart';

/// A labeled on/off switch row with the app's standard look.
///
/// Wraps [SwitchListTile] so every boolean setting in the app (settings
/// page, login demo switch, ...) renders identically: leading icon, title,
/// optional subtitle, switch on the right. Pass `null` as [onChanged] to
/// disable the switch (e.g. while a save is running).
class AppSwitchTile extends StatelessWidget {
  /// Creates an [AppSwitchTile].
  const AppSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.contentPadding,
  });

  /// The setting's name.
  final String title;

  /// Optional explanatory second line.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// The current on/off state.
  final bool value;

  /// Called with the new state; `null` disables the switch.
  final ValueChanged<bool>? onChanged;

  /// Overrides the tile's padding (e.g. [EdgeInsets.zero] inside cards).
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      secondary: icon == null ? null : Icon(icon),
      contentPadding: contentPadding,
      value: value,
      onChanged: onChanged,
    );
  }
}
