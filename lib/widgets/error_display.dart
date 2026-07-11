import 'package:flutter/material.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';

/// The standard error state used for every `AsyncValue.error` in this
/// template, so error handling looks identical across all views.
class ErrorDisplay extends StatelessWidget {
  /// Creates an [ErrorDisplay].
  const ErrorDisplay({super.key, required this.message, this.onRetry});

  /// The (already localized) message describing what went wrong.
  final String message;

  /// Optional retry action; when given, a retry button is shown.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Built as an explicit list instead of a collection-`if`/spread in the
    // literal, so the optional retry button reads as a plain statement.
    final List<Widget> children = <Widget>[
      Icon(Icons.error_outline, size: 48, color: colorScheme.error),
      const SizedBox(height: 16),
      Text(message, textAlign: TextAlign.center),
    ];

    if (onRetry != null) {
      children.add(const SizedBox(height: 16));
      children.add(
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(localizations.retry),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
