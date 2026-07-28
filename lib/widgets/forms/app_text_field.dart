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
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.scrollController,
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

  /// Number of lines the field grows to; `null` grows without limit.
  /// Defaults to `1` (single-line), matching every pre-existing call site.
  final int? maxLines;

  /// Minimum number of visible lines; only meaningful when [maxLines] is
  /// `null` or greater than `1`.
  final int? minLines;

  /// When true, the field fills all available height from its parent
  /// (which must give it a bounded height, e.g. via `Expanded`) instead of
  /// sizing to [maxLines]/[minLines], and scrolls internally past that.
  ///
  /// Pass [scrollController] alongside this so a [Scrollbar] thumb is
  /// shown — the standard Flutter/Material way to signal that a multiline
  /// field holds more text than currently fits (the thumb's size reflects
  /// how much more there is, and it can be dragged).
  final bool expands;

  /// Scroll position of the field's internal text view. Only used when
  /// [expands] is true.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = expands || maxLines == null || maxLines! > 1;

    final Widget field = TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: expands ? null : maxLines,
      minLines: expands ? null : minLines,
      expands: expands,
      scrollController: scrollController,
      // Without this, an `expands` field centers short content vertically,
      // which reads oddly for a growing, code-like text box — pin it to
      // the top instead, right under the label.
      textAlignVertical: expands ? TextAlignVertical.top : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        alignLabelWithHint: isMultiline,
      ),
    );

    if (!expands) {
      return field;
    }
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: field,
    );
  }
}
