import 'package:flutter/material.dart';

/// The standard empty state ("nothing here yet") used across all views, so
/// empty lists and missing data look identical everywhere.
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState].
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  /// The (already localized) message explaining what is empty.
  final String message;

  /// The icon shown above the message.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 48, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
