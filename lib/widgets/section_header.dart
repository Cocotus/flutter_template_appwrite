import 'package:flutter/material.dart';

/// A section heading used to structure content pages (settings, home, ...).
///
/// One place owns the heading typography: [SectionHeader.page] for the page
/// title at the top, the default constructor for sections further down.
class SectionHeader extends StatelessWidget {
  /// Creates a section-level heading.
  const SectionHeader({super.key, required this.title, this.subtitle})
      : _isPageTitle = false;

  /// Creates the page-level heading (larger, used once at the top).
  const SectionHeader.page({super.key, required this.title, this.subtitle})
      : _isPageTitle = true;

  /// The heading text.
  final String title;

  /// Optional explanatory line below the heading.
  final String? subtitle;

  final bool _isPageTitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? titleStyle = _isPageTitle
        ? theme.textTheme.headlineMedium
        : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);

    return Padding(
      padding: EdgeInsets.only(bottom: subtitle == null ? 12 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: titleStyle),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
