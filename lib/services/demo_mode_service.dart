import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

part 'demo_mode_service.g.dart';

/// Whether the demo feature may be used AT ALL in this build.
///
/// Two independent conditions unlock it:
/// - [AppConfig.demoModeAllowed]: an explicit `--dart-define` for demo builds.
/// - [kDebugMode]: always allowed while developing, for convenience.
///
/// A production release passes neither, so [demoModeIsAllowed] is `false` and
/// the demo path is unreachable — the runtime switch below is then hidden and
/// forced off. This constant is the single place that decision lives.
final bool demoModeIsAllowed = AppConfig.demoModeAllowed || kDebugMode;

/// The effective demo-mode state for the whole app.
///
/// When `true`, the service layer swaps in the in-memory fakes
/// (`DemoAuthService` / `DemoDatabaseService`) instead of the Appwrite-backed
/// implementations, so every view works without a backend or a login.
///
/// The value is `persisted user choice AND [demoModeIsAllowed]`: the stored
/// preference can never turn demo mode on in a build that does not allow it.
///
/// Kept alive because [authServiceProvider] and [databaseServiceProvider]
/// watch it: flipping it rebuilds those services (and, transitively,
/// `currentUserProvider` and the router guard), so the app switches between
/// real and demo backends without a restart.
@Riverpod(keepAlive: true)
class DemoMode extends _$DemoMode {
  @override
  bool build() {
    if (demoModeIsAllowed == false) {
      return false;
    }
    return ref.read(preferencesServiceProvider).readDemoMode();
  }

  /// Turns demo mode on or off and persists the choice.
  ///
  /// No-op in builds where demo mode is not allowed, so a stale stored
  /// preference or an unexpected caller can never enable it in production.
  Future<void> set({required bool enabled}) async {
    if (demoModeIsAllowed == false) {
      return;
    }

    final LoggerService logger = ref.read(loggerServiceProvider);
    final PreferencesService preferences =
        ref.read(preferencesServiceProvider);

    await preferences.writeDemoMode(enabled: enabled);
    state = enabled;

    logger.info('Demo mode ${enabled ? 'enabled' : 'disabled'}');
  }
}
