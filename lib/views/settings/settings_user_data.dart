import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/settings_backup.dart';
import 'package:flutter_template_appwrite/models/user_data.dart';
import 'package:flutter_template_appwrite/services/backup_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/user_data_service.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/buttons/app_secondary_button.dart';
import 'package:flutter_template_appwrite/widgets/section_header.dart';

/// The "My data" settings section: what the user has created, and how to move
/// it between machines.
///
/// Unlike the controls above it on the settings page, these buttons act
/// **immediately** — each one *is* the action the user pressed, not a form
/// value waiting for Save. This is the only place in the template that touches
/// the filesystem, and it only ever happens because someone clicked one of
/// these buttons: there is no automatic export, no mirror file and no
/// background writer.
class SettingsUserDataSection extends ConsumerWidget {
  /// Creates a [SettingsUserDataSection].
  const SettingsUserDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UserData data = ref.watch(userDataServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: l10n.settingsUserData,
          subtitle: l10n.settingsUserDataDescription,
        ),
        const SizedBox(height: 8),
        Text(l10n.settingsUserDataCount(data.notes.length)),
        const SizedBox(height: 12),
        _buildTransferButtons(context, ref, l10n),
        const SizedBox(height: 12),
        _buildClearButton(context, ref, l10n, data),
      ],
    );
  }

  Widget _buildTransferButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        AppSecondaryButton(
          label: l10n.settingsExport,
          icon: Icons.download_outlined,
          onPressed: () {
            _export(context, ref, l10n);
          },
        ),
        AppSecondaryButton(
          label: l10n.settingsImport,
          icon: Icons.upload_outlined,
          onPressed: () {
            _import(context, ref, l10n);
          },
        ),
      ],
    );
  }

  Widget _buildClearButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserData data,
  ) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return TextButton.icon(
      onPressed: data.isEmpty
          ? null
          : () {
              _confirmClear(context, ref, l10n);
            },
      style: TextButton.styleFrom(foregroundColor: scheme.error),
      icon: const Icon(Icons.delete_forever_outlined, size: 18),
      label: Text(l10n.settingsClearData),
    );
  }

  Future<void> _export(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final BackupService backup = ref.read(backupServiceProvider);
    try {
      final String? path = await backup.exportToFile();
      if (path == null || context.mounted == false) {
        return;
      }
      showSnackbar(context, l10n.settingsExportDone(path));
    } catch (error, stackTrace) {
      ref.read(loggerServiceProvider).handle(error, stackTrace, 'Export failed');
      if (context.mounted) {
        showErrorSnackbar(context, l10n.errorGeneric);
      }
    }
  }

  Future<void> _import(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final BackupService backup = ref.read(backupServiceProvider);
    try {
      final SettingsBackup? imported = await backup.importFromFile();
      if (imported == null || context.mounted == false) {
        return;
      }
      showSnackbar(context, l10n.settingsImportDone);
    } on FormatException {
      // A wrong or too-new file is user error, not an app failure: a precise
      // message, no log noise.
      if (context.mounted) {
        showErrorSnackbar(context, l10n.settingsImportFailed);
      }
    } catch (error, stackTrace) {
      ref.read(loggerServiceProvider).handle(error, stackTrace, 'Import failed');
      if (context.mounted) {
        showErrorSnackbar(context, l10n.errorGeneric);
      }
    }
  }

  Future<void> _confirmClear(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.settingsClearData),
          content: Text(l10n.settingsClearDataConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(l10n.commonDelete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }
    await ref.read(userDataServiceProvider.notifier).clearAll();
  }
}
