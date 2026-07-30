import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

/// Everything the user *creates* inside the app.
///
/// This is the second half of the template's persistence split, and it exists
/// in every app built from this template even when it starts out nearly empty:
///
/// * [UserSettings] is **configuration** — a fixed, small set of scalars the
///   user picks from a form. It goes into the Appwrite account-preferences
///   object, which is capped at 64 kB.
/// * [UserData] is **content** — whatever the user accumulates over time:
///   notes, bookmarks, journal entries, saved queries, drafts. It is unbounded
///   in principle, so it goes into an Appwrite Storage file instead.
///
/// The split is by growth, not by importance. A settings model that grows a
/// list of user-created entries has become user data and belongs here; keeping
/// it in preferences works right up until the day a heavy user hits the limit
/// and their save starts failing.
///
/// ## Replace the example field
///
/// [notes] is a placeholder so the whole path — model, local store, file
/// upload, export/import — is wired and working out of the box. Replace it with
/// your app's real content and delete this note. Keep the shape: give every
/// field an `@Default`, and cap anything that can grow (see [maxNotes]) so a
/// runaway list cannot silently outgrow its storage.
@freezed
abstract class UserData with _$UserData {
  /// Creates a [UserData].
  const factory UserData({
    /// Layout version of this document, for future migrations.
    @Default(1) int schemaVersion,

    /// When this document last changed.
    DateTime? updatedAt,

    /// EXAMPLE FIELD — replace with your app's own user-created content.
    @Default(<String>[]) List<String> notes,
  }) = _UserData;

  const UserData._();

  /// Creates a [UserData] from a JSON map.
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// Maximum number of [notes] kept.
  ///
  /// Every growing list needs a cap. Without one the document grows until some
  /// storage layer refuses it, and the first sign of trouble is a failed save
  /// rather than a warning.
  static const int maxNotes = 1000;

  /// Whether the user has created anything yet.
  bool get isEmpty {
    return notes.isEmpty;
  }
}
