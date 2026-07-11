import 'package:flutter/material.dart';

/// One selectable entry of an [AppDropdownField].
class AppDropdownOption<T> {
  /// Creates an [AppDropdownOption].
  const AppDropdownOption({required this.value, required this.label});

  /// The value reported to `onChanged` when this entry is picked.
  final T value;

  /// The text shown for this entry.
  final String label;
}

/// A dropdown selector styled like the app's text fields.
///
/// Wraps [DropdownButtonFormField] so dropdowns share the exact same
/// decoration (floating label, leading icon, filled background from
/// `AppTheme.inputDecorationTheme`) as [AppTextField]. Pass `null` as
/// [onChanged] to disable the field.
class AppDropdownField<T> extends StatelessWidget {
  /// Creates an [AppDropdownField].
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.icon,
  });

  /// The floating label shown above the field.
  final String label;

  /// The currently selected value; must match one of [options].
  final T value;

  /// The selectable entries.
  final List<AppDropdownOption<T>> options;

  /// Called with the newly picked value; `null` disables the field.
  final ValueChanged<T?>? onChanged;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
      items: <DropdownMenuItem<T>>[
        for (final AppDropdownOption<T> option in options)
          DropdownMenuItem<T>(
            value: option.value,
            child: Text(option.label),
          ),
      ],
    );
  }
}
