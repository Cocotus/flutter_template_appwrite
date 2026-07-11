import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/views/home/home_state.dart';

part 'home_controller.g.dart';

/// Controller for the home page's widget demo.
///
/// Shows the template's standard controller pattern in its smallest form:
/// the view calls plain methods, the controller owns an `AsyncValue` state,
/// and a fake [save] demonstrates the loading-spinner flow of
/// `AppPrimaryButton`. Replace together with `HomeView` when you build your
/// app's real home page.
@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<HomeDemoState> build() {
    return const HomeDemoState();
  }

  HomeDemoState get _current => state.value ?? const HomeDemoState();

  /// Updates the demo switch.
  void setNotificationsEnabled({required bool enabled}) {
    state = AsyncValue<HomeDemoState>.data(
      _current.copyWith(notificationsEnabled: enabled),
    );
  }

  /// Updates the demo dropdown.
  void setRole(String role) {
    state = AsyncValue<HomeDemoState>.data(_current.copyWith(role: role));
  }

  /// Pretends to persist the demo form (in-memory only).
  ///
  /// The artificial delay exists so the loading state of the save button
  /// is actually visible — a real controller would call a service here.
  Future<void> save(String displayName) async {
    final HomeDemoState newState = _current.copyWith(displayName: displayName);

    state = const AsyncValue<HomeDemoState>.loading();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    state = AsyncValue<HomeDemoState>.data(newState);

    ref.read(loggerServiceProvider).info('Widget demo saved (in-memory)');
  }

  /// Resets the demo form to its defaults.
  void reset() {
    state = const AsyncValue<HomeDemoState>.data(HomeDemoState());
  }
}
