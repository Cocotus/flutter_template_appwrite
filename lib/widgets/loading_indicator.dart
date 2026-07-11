import 'package:flutter/material.dart';

/// The standard loading state used for every `AsyncValue.loading` in this
/// template, so loading looks identical across all views.
class LoadingIndicator extends StatelessWidget {
  /// Creates a [LoadingIndicator].
  const LoadingIndicator({super.key, this.message});

  /// Optional text shown below the spinner.
  final String? message;

  @override
  Widget build(BuildContext context) {
    // Built as an explicit list instead of a collection-`if`/spread in the
    // literal, so the optional message line reads as a plain statement.
    final List<Widget> children = <Widget>[
      // Rounded stroke cap + color come from progressIndicatorTheme.
      const SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(strokeWidth: 3.5),
      ),
    ];

    if (message != null) {
      children.add(const SizedBox(height: 16));
      children.add(
        Text(
          message!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
