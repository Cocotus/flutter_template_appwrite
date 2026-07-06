import 'package:flutter/material.dart';

/// A circular avatar showing the user's initials.
///
/// Used in the sidebar and on the profile page. Falls back to a generic
/// person icon when no name is available.
class UserAvatar extends StatelessWidget {
  /// Creates a [UserAvatar].
  const UserAvatar({super.key, required this.displayName, this.radius = 20});

  /// The name whose initials are shown; may be empty.
  final String displayName;

  /// The circle radius in logical pixels.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String initials = _buildInitials(displayName);

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: initials.isEmpty
          ? Icon(
              Icons.person,
              size: radius,
              color: colorScheme.onPrimaryContainer,
            )
          : Text(
              initials,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  // Builds up to two uppercase initials from the given name,
  // e.g. "Jane Doe" -> "JD".
  String _buildInitials(String name) {
    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return '';
    }

    final List<String> parts = trimmedName.split(RegExp(r'\s+'));
    final StringBuffer initialsBuffer = StringBuffer();

    for (final String part in parts) {
      if (part.isNotEmpty) {
        initialsBuffer.write(part[0].toUpperCase());
      }
      if (initialsBuffer.length >= 2) {
        break;
      }
    }

    return initialsBuffer.toString();
  }
}
