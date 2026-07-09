import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/locale_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/theme/accent_colors.dart';
import 'package:flutter_template_appwrite/views/settings/settings_controller.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_text_field.dart';

/// Settings page: theme, language, developer mode and display name.
///
/// Every change is persisted immediately (local cache + Appwrite) through
/// [SettingsController] and updates the running app live — flipping dark
/// mode or the language re-renders the whole app at once.
class SettingsView extends HookConsumerWidget {
  /// Creates a [SettingsView].
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UserSettings settings = ref.watch(userSettingsControllerProvider);
    final AsyncValue<void> saveState = ref.watch(settingsControllerProvider);

    // Widget-scoped controller for the display name field (hook-managed).
    final TextEditingController displayNameController =
        useTextEditingController(text: settings.displayName);

    // Surface save errors as a snackbar; the values themselves roll back
    // to the last loaded state on the next settings fetch.
    ref.listen<AsyncValue<void>>(
      settingsControllerProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (next.hasError && next.isLoading == false) {
          showErrorSnackbar(context, localizations.errorGeneric);
        }
      },
    );

    final bool isSaving = saveState.isLoading;
    final SettingsController controller =
        ref.read(settingsControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.settings,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              _buildDarkModeSwitch(
                localizations: localizations,
                settings: settings,
                controller: controller,
                isSaving: isSaving,
              ),
              _buildAccentColorPicker(
                context: context,
                localizations: localizations,
                settings: settings,
                controller: controller,
                isSaving: isSaving,
              ),
              _buildLanguageDropdown(
                localizations: localizations,
                settings: settings,
                controller: controller,
                isSaving: isSaving,
              ),
              _buildDeveloperModeSwitch(
                localizations: localizations,
                settings: settings,
                controller: controller,
                isSaving: isSaving,
              ),
              const Divider(height: 48),
              _buildDisplayNameField(
                localizations: localizations,
                displayNameController: displayNameController,
                controller: controller,
                isSaving: isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch({
    required AppLocalizations localizations,
    required UserSettings settings,
    required SettingsController controller,
    required bool isSaving,
  }) {
    return SwitchListTile(
      title: Text(localizations.darkMode),
      secondary: const Icon(Icons.dark_mode_outlined),
      value: settings.isDarkMode,
      onChanged: isSaving
          ? null
          : (bool newValue) {
              controller.setDarkMode(newValue);
            },
    );
  }

  // A row of tappable color swatches; the active one gets a check mark.
  // Picking one re-seeds the whole Material 3 palette (see AppTheme).
  Widget _buildAccentColorPicker({
    required BuildContext context,
    required AppLocalizations localizations,
    required UserSettings settings,
    required SettingsController controller,
    required bool isSaving,
  }) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(localizations.accentColor),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            for (final AccentColor preset in accentColorPresets)
              _buildColorSwatch(
                context: context,
                preset: preset,
                isSelected: preset.value == settings.accentColorValue,
                onTap: isSaving
                    ? null
                    : () => controller.setAccentColor(preset.value),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch({
    required BuildContext context,
    required AccentColor preset,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    // White or black check mark, whichever contrasts with the swatch.
    final Color checkColor =
        ThemeData.estimateBrightnessForColor(preset.color) == Brightness.dark
            ? Colors.white
            : Colors.black;

    // Selected swatch: a ring around the circle with a small gap, so the
    // color itself stays fully visible (nicer than a border on the swatch).
    return Tooltip(
      message: preset.name,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: preset.color,
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? Icon(Icons.check, size: 20, color: checkColor)
                : null,
          ),
        ),
      ),
    );
  }

  // A modern segmented control instead of a dropdown — with only a handful
  // of languages, all options stay visible and switching is one click.
  Widget _buildLanguageDropdown({
    required AppLocalizations localizations,
    required UserSettings settings,
    required SettingsController controller,
    required bool isSaving,
  }) {
    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(localizations.language),
      trailing: SegmentedButton<String>(
        segments: <ButtonSegment<String>>[
          for (final String languageCode in supportedLanguageCodes)
            ButtonSegment<String>(
              value: languageCode,
              label: Text(_languageDisplayName(languageCode)),
            ),
        ],
        selected: <String>{settings.languageCode},
        showSelectedIcon: false,
        onSelectionChanged: isSaving
            ? null
            : (Set<String> newSelection) {
                // Single-select mode: the set always holds exactly one code.
                controller.setLanguageCode(newSelection.first);
              },
      ),
    );
  }

  Widget _buildDeveloperModeSwitch({
    required AppLocalizations localizations,
    required UserSettings settings,
    required SettingsController controller,
    required bool isSaving,
  }) {
    return SwitchListTile(
      title: Text(localizations.developerMode),
      subtitle: Text(localizations.developerModeDescription),
      secondary: const Icon(Icons.terminal_outlined),
      value: settings.developerMode,
      onChanged: isSaving
          ? null
          : (bool newValue) {
              controller.setDeveloperMode(newValue);
            },
    );
  }

  Widget _buildDisplayNameField({
    required AppLocalizations localizations,
    required TextEditingController displayNameController,
    required SettingsController controller,
    required bool isSaving,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AppTextField(
            controller: displayNameController,
            label: localizations.displayName,
            icon: Icons.badge_outlined,
          ),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: isSaving
              ? null
              : () {
                  controller.setDisplayName(displayNameController.text);
                },
          child: Text(localizations.save),
        ),
      ],
    );
  }

  // Shows each language in its own tongue so users can always find their
  // language, no matter which one is currently active.
  String _languageDisplayName(String languageCode) {
    if (languageCode == 'de') {
      return 'Deutsch';
    }
    return 'English';
  }
}
