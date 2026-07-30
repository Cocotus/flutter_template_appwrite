import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_data.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

part 'user_data_service.g.dart';

/// Holds and persists everything the user creates inside the app.
///
/// The counterpart to `UserSettingsService`: that one owns configuration,
/// this one owns content. See [UserData] for why the two are split.
///
/// ## Persistence
///
/// Every mutation updates the state first (so the UI is instant), then writes
/// the whole document to `shared_preferences`. That is the only automatic
/// write, and it never touches the network. A full rewrite per change is far
/// simpler than incremental keys and, for a capped document, cheaper to reason
/// about than it looks.
///
/// Getting the document off the device is always something the user asked for:
/// the Export/Import buttons in the settings page (`BackupService`), or the
/// Appwrite sync that runs on login, on Save and on logout (`CloudSync`).
///
/// Reads are **synchronous**: `main.dart` already awaits
/// `SharedPreferences.getInstance()` before `runApp`, so [build] can return the
/// stored document directly and views never handle a loading state for it.
///
/// ## Adapting this to your app
///
/// [addNote] is an example of the shape every mutation should have: change a
/// copy, enforce the cap, hand it to [replaceAll]-style single write path.
/// Replace it with your app's real operations and keep `_apply` as the only
/// place that writes.
@Riverpod(keepAlive: true)
class UserDataService extends _$UserDataService {
  @override
  UserData build() {
    final PreferencesService preferences = ref.read(preferencesServiceProvider);
    final UserData? stored = preferences.readUserData();
    if (stored != null) {
      return stored;
    }
    return const UserData();
  }

  /// EXAMPLE MUTATION — appends a note, oldest pruned past [UserData.maxNotes].
  ///
  /// Replace with your app's real operations; keep the shape.
  Future<void> addNote(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final List<String> notes = List<String>.from(state.notes);
    notes.add(trimmed);

    if (notes.length > UserData.maxNotes) {
      final int excess = notes.length - UserData.maxNotes;
      notes.removeRange(0, excess);
    }

    await _apply(state.copyWith(notes: notes));
  }

  /// EXAMPLE MUTATION — removes the note at [index].
  Future<void> removeNote(int index) async {
    if (index < 0 || index >= state.notes.length) {
      return;
    }

    final List<String> notes = List<String>.from(state.notes);
    notes.removeAt(index);
    await _apply(state.copyWith(notes: notes));
  }

  /// Replaces the whole document, used by import and by the login pull.
  Future<void> replaceAll(UserData imported) async {
    await _apply(
      imported.copyWith(schemaVersion: const UserData().schemaVersion),
    );
  }

  /// Deletes everything the user created.
  Future<void> clearAll() async {
    await _apply(const UserData());
  }

  // The single write path: state first so the UI updates immediately, then the
  // authoritative local store. Nothing else, and nothing over the network.
  Future<void> _apply(UserData next) async {
    state = next.copyWith(updatedAt: DateTime.now());

    final PreferencesService preferences = ref.read(preferencesServiceProvider);
    await preferences.writeUserData(state);
  }
}
