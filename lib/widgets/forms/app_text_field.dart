import 'package:flutter/material.dart';

/// A single-line text input with the app's standard look.
///
/// Wraps [TextField] so the label + leading icon styling is defined once and
/// reused everywhere (login, settings, ...). Only the options the app
/// actually needs are exposed; add parameters here as new needs appear so
/// every field keeps a consistent API.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
  });

  /// Holds and exposes the field's text.
  final TextEditingController controller;

  /// The floating label shown above the field.
  final String label;

  /// Optional leading icon (e.g. an envelope for an email field).
  final IconData? icon;

  /// The on-screen keyboard type, e.g. [TextInputType.emailAddress].
  final TextInputType? keyboardType;

  /// What the keyboard action button does (next field / submit).
  final TextInputAction? textInputAction;

  /// Whether this field grabs focus when the form first appears.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
    );
  }
}
