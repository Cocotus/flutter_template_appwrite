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

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...<Widget>[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.retry),
            ),
          ],
        ],
      ),
    );
  }
}
