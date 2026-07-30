import 'package:flutter/material.dart';

/// The app's secondary action button (cancel, export, less important
/// actions next to an [AppPrimaryButton]).
///
/// Wraps [OutlinedButton]; same loading behavior as the primary button.
class AppSecondaryButton extends StatelessWidget {
  /// Creates an [AppSecondaryButton].
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  /// The button caption.
  final String label;

  /// Called on tap; pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// While true the button is disabled and shows a spinner.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    if (icon != null && isLoading == false) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon),
        label: child,
      );
    }
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}
