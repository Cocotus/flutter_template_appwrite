import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

/// In-memory state of the home page's widget demo.
///
/// Deliberately trivial: it exists so the home page can demonstrate the
/// standard view → controller → Freezed-state wiring of this template with
/// real, interactive widgets. Replace it together with `HomeView` when you
/// build your app's real home page.
@freezed
abstract class HomeDemoState with _$HomeDemoState {
  /// Creates a [HomeDemoState].
  const factory HomeDemoState({
    /// Value of the demo text field.
    @Default('') String displayName,

    /// Value of the demo switch.
    @Default(true) bool notificationsEnabled,

    /// Value of the demo dropdown.
    @Default('user') String role,
  }) = _HomeDemoState;
}
