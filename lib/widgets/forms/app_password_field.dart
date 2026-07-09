import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';

/// A password input with a built-in show/hide toggle.
///
/// Self-contained: each field manages its own visibility state (via a hook),
/// so callers just supply a [controller] and [label]. This is why it can be
/// dropped in as many times as needed (password, confirm password, ...)
/// without wiring up any shared state.
class AppPasswordField extends HookWidget {
  /// Creates an [AppPasswordField].
  const AppPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.textInputAction,
  });

  /// Holds and exposes the field's text.
  final TextEditingController controller;

  /// The floating label shown above the field.
  final String label;

  /// What the keyboard action button does (next field / submit).
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Widget-local UI state: whether the characters are currently revealed.
    final ValueNotifier<bool> isVisible = useState<bool>(false);

    final IconData icon =
        isVisible.value ? Icons.visibility_off : Icons.visibility;
    final String tooltip = isVisible.value
        ? localizations.hidePassword
        : localizations.showPassword;

    return TextField(
      controller: controller,
      obscureText: isVisible.value == false,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(icon),
          tooltip: tooltip,
          onPressed: () {
            isVisible.value = !isVisible.value;
          },
        ),
      ),
    );
  }
}
