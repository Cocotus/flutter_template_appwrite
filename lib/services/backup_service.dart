import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/settings_backup.dart';
import 'package:flutter_template_appwrite/services/user_data_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'backup_service.g.dart';

/// Builds, applies and transfers the complete [SettingsBackup] document.
///
/// One entry point for every "move my whole configuration" operation, so the
/// export file, the clipboard payload and the Appwrite copy are guaranteed to be
/// the same shape. [current] and [apply] are the assembly and disassembly points
/// all three transports share — the file and clipboard ones live in this class,
/// the cloud one in `CloudSync`.
///
/// Every method here runs only in response to a button the user pressed. There
/// is no automatic export and no background writer: this is the only code in the
/// template that touches the filesystem, and it does so exactly when asked.
///
/// Deliberately free of a top-level `dart:io` import — an unconditional one
/// breaks the web build. Everything goes through `file_selector`/`cross_file`,
/// whose web implementations map onto a file picker and a browser download.
class BackupService {
  /// Creates a [BackupService].
  BackupService({required this._ref});

  // Holds `Ref` rather than the values, because this service must read the
  // *current* state of both stores at call time — a snapshot captured at
  // construction would export whatever was true when the provider was first
  // built. Safe here because the provider is keepAlive.
  final Ref _ref;

  /// Default file name offered when exporting.
  static const String fileName = 'settings_backup.json';

  /// Collects the current state of both stores into one document.
  SettingsBackup current() {
    return SettingsBackup(
      exportedAt: DateTime.now(),
      userSettings: _ref.read(userSettingsServiceProvider),
      userData: _ref.read(userDataServiceProvider),
    );
  }

  /// Writes every part of [backup] back into its store.
  ///
  /// Both stores are local (`shared_preferences`), so this is a plain two-step
  /// write with no ordering constraint.
  Future<void> apply(SettingsBackup backup) async {
    await _ref
        .read(userSettingsServiceProvider.notifier)
        .save(backup.userSettings);
    await _ref
        .read(userDataServiceProvider.notifier)
        .replaceAll(backup.userData);
  }

  /// Encodes [backup] as indented JSON.
  ///
  /// Indented on purpose: the whole point of an export is that a human can open
  /// it, read it and hand-edit it.
  String encode(SettingsBackup backup) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(backup.toJson());
  }

  /// Decodes [jsonText] into an [SettingsBackup].
  ///
  /// Throws [FormatException] when the text is not a JSON object or carries a
  /// schema version this build does not understand, so the caller can show a
  /// precise message instead of silently importing nothing.
  SettingsBackup decode(String jsonText) {
    final Object? decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object at the top level');
    }

    final Object? version = decoded['schemaVersion'];
    if (version is int && version > currentBackupSchemaVersion) {
      throw FormatException(
        'Backup schema version $version is newer than this app supports '
        '($currentBackupSchemaVersion)',
      );
    }

    return SettingsBackup.fromJson(decoded);
  }

  /// Writes the current state to a user-chosen file, or downloads it on web.
  ///
  /// Returns the chosen path, or null when the user cancelled.
  Future<String?> exportToFile() async {
    final Uint8List bytes = Uint8List.fromList(utf8.encode(encode(current())));

    if (kIsWeb) {
      // On web `saveTo` is what triggers the browser download; the argument is
      // only used as the suggested file name.
      final XFile file = XFile.fromData(
        bytes,
        mimeType: 'application/json',
        name: fileName,
      );
      await file.saveTo(fileName);
      return fileName;
    }

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: const <XTypeGroup>[
        XTypeGroup(label: 'JSON', extensions: <String>['json']),
      ],
    );
    if (location == null) {
      return null;
    }

    final XFile file = XFile.fromData(
      bytes,
      mimeType: 'application/json',
      name: fileName,
    );
    await file.saveTo(location.path);
    return location.path;
  }

  /// Asks the user for a file, applies it, and returns what was imported.
  ///
  /// Returns null when the user cancels. Throws [FormatException] on an
  /// unreadable or too-new document.
  Future<SettingsBackup?> importFromFile() async {
    const XTypeGroup jsonGroup = XTypeGroup(
      label: 'JSON',
      extensions: <String>['json'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[jsonGroup],
    );
    if (file == null) {
      return null;
    }

    final SettingsBackup backup = decode(await file.readAsString());
    await apply(backup);
    return backup;
  }

  /// Copies the current state to the clipboard.
  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: encode(current())));
  }

  /// Applies a document from the clipboard.
  ///
  /// Returns null when the clipboard is empty. Throws [FormatException] on an
  /// unreadable document.
  Future<SettingsBackup?> pasteFromClipboard() async {
    final ClipboardData? clip = await Clipboard.getData(Clipboard.kTextPlain);
    final String? text = clip?.text;
    if (text == null || text.trim().isEmpty) {
      return null;
    }

    final SettingsBackup backup = decode(text);
    await apply(backup);
    return backup;
  }
}

/// Provides the app-wide [BackupService].
@Riverpod(keepAlive: true)
BackupService backupService(Ref ref) {
  return BackupService(ref: ref);
}
