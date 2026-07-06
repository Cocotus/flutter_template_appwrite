import 'package:flutter/material.dart';

/// Shows a floating snackbar with [message].
///
/// Used from `ref.listen` blocks in views to surface controller results
/// (e.g. auth errors) — the controller itself never touches a
/// [BuildContext].
void showSnackbar(BuildContext context, String message) {
  final SnackBar snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Shows a floating snackbar styled as an error.
void showErrorSnackbar(BuildContext context, String message) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  final SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: colorScheme.onErrorContainer),
    ),
    backgroundColor: colorScheme.errorContainer,
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
