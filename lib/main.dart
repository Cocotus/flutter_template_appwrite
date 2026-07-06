import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'package:flutter_template_appwrite/app.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

/// Application entry point.
///
/// Responsibilities, in order:
/// 1. Path-based URLs on the web (`/login` instead of `/#/login`).
/// 2. Load [SharedPreferences] once, so all later reads are synchronous.
/// 3. Route ALL uncaught errors into Talker — crucial on Web/Desktop where
///    the end user has no terminal to read stack traces from.
/// 4. Start the app in a [ProviderScope] whose observer logs every
///    Riverpod state change and provider failure automatically.
Future<void> main() async {
  // Must come first: plugins (SharedPreferences) need the bindings.
  WidgetsFlutterBinding.ensureInitialized();

  // Web: use clean path URLs. Requires the hosting server to rewrite
  // unknown paths to index.html (SPA fallback) — see README hosting notes.
  usePathUrlStrategy();

  // Loaded once here so sharedPreferencesProvider can hand out the
  // instance synchronously to the rest of the app.
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // One Talker instance for the whole app. Created here (not inside a
  // provider) because the global error hooks below must exist before the
  // first frame; loggerServiceProvider is overridden to wrap this instance.
  final Talker talker = TalkerFlutter.init();

  // Framework errors (widget build/layout exceptions).
  FlutterError.onError = (FlutterErrorDetails details) {
    talker.handle(details.exception, details.stack, 'FlutterError');
    if (kDebugMode) {
      // Keep the familiar red error output in debug consoles.
      FlutterError.presentError(details);
    }
  };

  // All other uncaught async/platform errors. Returning true marks them as
  // handled. Because this hook exists, wrapping runApp in runZonedGuarded
  // is intentionally NOT done — it would add nothing on Web/Desktop and
  // can trigger Flutter's zone-mismatch warning (current official
  // guidance).
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    talker.handle(error, stack, 'Uncaught platform error');
    return true;
  };

  runApp(
    ProviderScope(
      // (The Override list type is inferred — riverpod 3 does not export
      // the Override class in its public API.)
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        loggerServiceProvider.overrideWith((Ref ref) {
          return createLoggerService(ref: ref, talker: talker);
        }),
      ],
      // Logs every provider add/update/dispose/failure through Talker.
      observers: <ProviderObserver>[
        TalkerRiverpodObserver(
          talker: talker,
          settings: const TalkerRiverpodLoggerSettings(
            // Full state dumps get noisy quickly; log lifecycle events and
            // failures, not every value in detail.
            printStateFullData: false,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
