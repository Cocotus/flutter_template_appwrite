import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/services/remote_log_sink.dart';

part 'logger_service.g.dart';

/// Central logging facade for the whole app, built on Talker.
///
/// Usage rules for this template:
/// - Never use `print` or `debugPrint` for app logging — always go through
///   this service so every message shows up in the console AND in the
///   in-app Logs view (`TalkerScreen`).
/// - Log an exception once, at the boundary where it is handled with
///   context (usually a controller's `try/catch`), via [handle]. Do not
///   re-log the same error at every layer.
/// - Never log secrets or PII (passwords, tokens, full email addresses).
///   Redact values first, e.g. with `redactEmail`.
class LoggerService {
  /// Creates a [LoggerService] that writes to the given Talker instance
  /// (callers pass it as `talker:`).
  LoggerService({required this._talker});

  final Talker _talker;

  /// The underlying Talker instance.
  ///
  /// Exposed so the Logs view can embed `TalkerScreen(talker: ...)` and so
  /// `main.dart` can register the Riverpod and route observers.
  Talker get talker => _talker;

  /// Logs an informational message.
  void info(String message) {
    _talker.info(message);
  }

  /// Logs a debug message (hidden in release-oriented filters).
  void debug(String message) {
    _talker.debug(message);
  }

  /// Logs a warning message.
  void warning(String message) {
    _talker.warning(message);
  }

  /// Logs an error message (without an exception object).
  void error(String message) {
    _talker.error(message);
  }

  /// Logs a caught [exception] with its [stackTrace] and a short context
  /// [message] explaining where/why it was handled.
  void handle(Object exception, StackTrace? stackTrace, [String? message]) {
    _talker.handle(exception, stackTrace, message);
  }
}

/// Builds a [LoggerService] around an existing [talker] instance.
///
/// When remote logging is enabled via config, an observer is attached that
/// forwards error/fatal events to the Appwrite `logs` table. All other
/// levels stay local on purpose (cost and noise on a hosted backend).
///
/// `main.dart` creates the Talker instance itself (it needs it for the
/// global error hooks and the Riverpod observer before the first provider
/// is ever read) and injects it here via a provider override.
LoggerService createLoggerService({
  required Ref ref,
  required Talker talker,
}) {
  if (AppConfig.remoteLoggingEnabled) {
    final AppwriteLogSink remoteSink = AppwriteLogSink(ref: ref);
    talker.configure(observer: RemoteLogTalkerObserver(sink: remoteSink));
  }
  return LoggerService(talker: talker);
}

/// Provides the single app-wide [LoggerService] instance.
///
/// Kept alive for the whole app lifetime: the logger must never be
/// disposed. In the real app this provider is overridden in `main.dart` so
/// it wraps the same Talker instance that receives the global error hooks;
/// the default implementation below keeps tests and tools working without
/// that override.
@Riverpod(keepAlive: true)
LoggerService loggerService(Ref ref) {
  final Talker talker = TalkerFlutter.init();
  return createLoggerService(ref: ref, talker: talker);
}
