import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/cloud_sync/cloud_sync_controller.dart';
import 'package:flutter_template_appwrite/models/language_option.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/theme/accent_colors.dart';
import 'package:flutter_template_appwrite/views/settings/settings_controller.dart';
import 'package:flutter_template_appwrite/views/settings/settings_state.dart';
import 'package:flutter_template_appwrite/views/settings/settings_user_data.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/buttons/app_primary_button.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_switch_tile.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_text_field.dart';
import 'package:flutter_template_appwrite/widgets/section_header.dart';

/// Settings page: theme, language, developer mode, display name and the
/// user-data transfer buttons.
///
/// This page is a **form**. Every control edits a [SettingsDraft]; nothing is
/// stored, and nothing changes about the running app, until the Save button at
/// the bottom is pressed. Leaving the page without saving discards the draft —
/// that is why there is no Cancel button.
///
/// Saving writes the local store (which is what applies the new theme and
/// language) and, when signed in, pushes everything to Appwrite in the same
/// step. The button is always pressable — there is no "unsaved changes"
/// check — because Save is also the only way to (re-)push whatever the user
/// created elsewhere in the app, or to retry after a failed push; a check
/// that only compared this page's own fields could never tell those cases
/// apart from "nothing to do".
class SettingsView extends HookConsumerWidget {
  /// Creates a [SettingsView].
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final SettingsDraft draft = ref.watch(settingsDraftControllerProvider);
    final SettingsDraftController draftController =
        ref.read(settingsDraftControllerProvider.notifier);

    // The saved values, as the source the display-name field re-seeds from.
    final UserSettings savedSettings =
        ref.watch(userSettingsServiceProvider);

    final AsyncValue<void> saveState = ref.watch(settingsControllerProvider);
    final bool isSaving = saveState.isLoading;

    // Widget-scoped controller for the display name field (hook-managed).
    // Keyed on the SAVED value, not the draft: the draft changes on every
    // keystroke, and re-applying it here would move the cursor to the end of
    // the field. Keying on the saved value means the effect only fires when the
    // form is re-seeded from outside — after a save, an import or a login pull
    // (see AGENTS.md §12).
    final String savedDisplayName = savedSettings.displayName;
    final TextEditingController displayNameController =
        useTextEditingController(text: savedDisplayName);
    useEffect(
      () {
        displayNameController.text = savedDisplayName;
        return null;
      },
      <Object?>[savedDisplayName],
    );

    // Surface save failures as a snackbar. The draft keeps the user's values,
    // so nothing is lost and they can simply press Save again.
    ref.listen<AsyncValue<void>>(
      settingsControllerProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (next.hasError && next.isLoading == false) {
          showErrorSnackbar(context, localizations.errorGeneric);
        }
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader.page(title: localizations.settings),
              const SizedBox(height: 12),
              _buildDarkModeSwitch(
                localizations: localizations,
                draft: draft,
                draftController: draftController,
                isSaving: isSaving,
              ),
              _buildAccentColorPicker(
                context: context,
                localizations: localizations,
                draft: draft,
                draftController: draftController,
                isSaving: isSaving,
              ),
              _buildLanguageDropdown(
                localizations: localizations,
                draft: draft,
                draftController: draftController,
                isSaving: isSaving,
              ),
              _buildDeveloperModeSwitch(
                localizations: localizations,
                draft: draft,
                draftController: draftController,
                isSaving: isSaving,
              ),
              const Divider(height: 48),
              _buildDisplayNameField(
                localizations: localizations,
                displayNameController: displayNameController,
                draft: draft,
                draftController: draftController,
                isSaving: isSaving,
              ),
              const Divider(height: 48),
              const SettingsUserDataSection(),
              const Divider(height: 48),
              _buildSaveBar(
                context: context,
                localizations: localizations,
                ref: ref,
                isSaving: isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // The one control that commits the whole page. Always pressable — see the
  // class doc for why there is no "unsaved changes" gate — and, when signed
  // in, shows when the result last made it to Appwrite.
  Widget _buildSaveBar({
    required BuildContext context,
    required AppLocalizations localizations,
    required WidgetRef ref,
    required bool isSaving,
  }) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> children = <Widget>[
      AppPrimaryButton(
        label: localizations.save,
        isLoading: isSaving,
        onPressed: () {
          ref.read(settingsControllerProvider.notifier).save();
        },
      ),
    ];

    // Hidden entirely when there is no signed-in user to sync with — a build
    // with HAS_LOGIN=false stores everything locally and never shows this.
    final CloudSync cloudSync = ref.read(cloudSyncProvider.notifier);
    if (cloudSync.isAvailable) {
      final AsyncValue<DateTime?> syncState = ref.watch(cloudSyncProvider);

      final String statusText;
      final Color statusColor;
      if (syncState.hasError) {
        statusText = localizations.settingsSyncFailed;
        statusColor = theme.colorScheme.error;
      } else {
        statusText = _lastSyncedText(context, localizations, syncState.value);
        statusColor = theme.colorScheme.onSurfaceVariant;
      }

      children.add(const SizedBox(width: 16));
      children.add(
        Expanded(
          child: Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(color: statusColor),
          ),
        ),
      );
    }

    return Row(children: children);
  }

  // Formats the last sync moment with the framework's own localized date and
  // time formatters, so no extra formatting dependency is needed.
  String _lastSyncedText(
    BuildContext context,
    AppLocalizations localizations,
    DateTime? syncedAt,
  ) {
    if (syncedAt == null) {
      return localizations.settingsNeverSynced;
    }

    final MaterialLocalizations material = MaterialLocalizations.of(context);
    final String date = material.formatMediumDate(syncedAt);
    final String time = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(syncedAt),
    );
    return localizations.settingsLastSynced('$date, $time');
  }

  Widget _buildDarkModeSwitch({
    required AppLocalizations localizations,
    required SettingsDraft draft,
    required SettingsDraftController draftController,
    required bool isSaving,
  }) {
    return AppSwitchTile(
      title: localizations.darkMode,
      icon: Icons.dark_mode_outlined,
      value: draft.userSettings.isDarkMode,
      onChanged: isSaving
          ? null
          : (bool newValue) {
              draftController.updateSettings(
                draft.userSettings.copyWith(isDarkMode: newValue),
              );
            },
    );
  }

  // A row of tappable color swatches; the active one gets a check mark.
  // Picking one re-seeds the whole Material 3 palette (see AppTheme) — once
  // the draft is saved.
  Widget _buildAccentColorPicker({
    required BuildContext context,
    required AppLocalizations localizations,
    required SettingsDraft draft,
    required SettingsDraftController draftController,
    required bool isSaving,
  }) {
    final List<Widget> swatches = <Widget>[];
    for (final AccentColor preset in accentColorPresets) {
      swatches.add(
        _buildColorSwatch(
          context: context,
          preset: preset,
          isSelected: preset.value == draft.userSettings.accentColorValue,
          onTap: isSaving
              ? null
              : () {
                  draftController.updateSettings(
                    draft.userSettings.copyWith(accentColorValue: preset.value),
                  );
                },
        ),
      );
    }

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(localizations.accentColor),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(spacing: 12, runSpacing: 12, children: swatches),
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

  // A dropdown with one entry per supported language. Labels are always the
  // English name (never the endonym) with a flag prefix, so the dropdown
  // itself stays readable even if the user picked a script they can't read.
  // The key forces a fresh DropdownMenu whenever the code changes from
  // outside this widget (e.g. the draft being re-seeded after an import),
  // since DropdownMenu only honors initialSelection on first build.
  Widget _buildLanguageDropdown({
    required AppLocalizations localizations,
    required SettingsDraft draft,
    required SettingsDraftController draftController,
    required bool isSaving,
  }) {
    final List<DropdownMenuEntry<String>> entries =
        <DropdownMenuEntry<String>>[];
    for (final LanguageOption option in languageOptions) {
      entries.add(
        DropdownMenuEntry<String>(
          value: option.code,
          label: option.englishName,
          leadingIcon: Text(option.flagEmoji),
        ),
      );
    }

    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(localizations.language),
      trailing: DropdownMenu<String>(
        key: ValueKey<String>(draft.userSettings.languageCode),
        enabled: !isSaving,
        enableFilter: true,
        width: 240,
        initialSelection: draft.userSettings.languageCode,
        dropdownMenuEntries: entries,
        onSelected: (String? newCode) {
          if (newCode != null) {
            draftController.updateSettings(
              draft.userSettings.copyWith(languageCode: newCode),
            );
          }
        },
      ),
    );
  }

  Widget _buildDeveloperModeSwitch({
    required AppLocalizations localizations,
    required SettingsDraft draft,
    required SettingsDraftController draftController,
    required bool isSaving,
  }) {
    return AppSwitchTile(
      title: localizations.developerMode,
      subtitle: localizations.developerModeDescription,
      icon: Icons.terminal_outlined,
      value: draft.userSettings.developerMode,
      onChanged: isSaving
          ? null
          : (bool newValue) {
              draftController.updateSettings(
                draft.userSettings.copyWith(developerMode: newValue),
              );
            },
    );
  }

  Widget _buildDisplayNameField({
    required AppLocalizations localizations,
    required TextEditingController displayNameController,
    required SettingsDraft draft,
    required SettingsDraftController draftController,
    required bool isSaving,
  }) {
    return AppTextField(
      controller: displayNameController,
      label: localizations.displayName,
      icon: Icons.badge_outlined,
      enabled: !isSaving,
      onChanged: (String value) {
        draftController.updateSettings(
          draft.userSettings.copyWith(displayName: value.trim()),
        );
      },
    );
  }
}
