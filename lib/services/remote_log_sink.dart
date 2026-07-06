import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';

/// Destination for log events that should leave the device.
///
/// On Web and Desktop the end user has no terminal, so serious errors in
/// production are invisible unless they are shipped somewhere. This small
/// abstraction keeps the "where" pluggable: the template ships an
/// [AppwriteLogSink]; for full production crash monitoring consider Sentry
/// (`sentry_flutter`) instead — see the README.
abstract class RemoteLogSink {
  /// Persists one log [entry] remotely.
  Future<void> write(RemoteLogEntry entry);
}

/// A [RemoteLogSink] that writes entries as rows into the Appwrite `logs`
/// table via [DatabaseService].
///
/// Only ever receives error/fatal events (see [RemoteLogTalkerObserver]),
/// and only when the `REMOTE_LOGGING_ENABLED` config flag is true.
class AppwriteLogSink implements RemoteLogSink {
  /// Creates an [AppwriteLogSink].
  ///
  /// Takes a [Ref] (passed as `ref:`) instead of concrete services so the
  /// services are looked up lazily at write time — this avoids creating
  /// the whole Appwrite stack just because the logger was initialized.
  AppwriteLogSink({required this._ref});

  final Ref _ref;

  @override
  Future<void> write(RemoteLogEntry entry) async {
    try {
      final DatabaseService databaseService =
          _ref.read(databaseServiceProvider);

      // Attach the current user ID when someone is logged in, so log rows
      // can be correlated with a user. An empty string means "anonymous".
      final String userId =
          _ref.read(currentUserProvider).value?.$id ?? '';

      final RemoteLogEntry entryWithUser = entry.copyWith(userId: userId);
      await databaseService.writeLogEntry(entryWithUser);
    } catch (_) {
      // Intentionally swallowed: if remote logging itself fails we must NOT
      // log that failure as an error, because that would be forwarded to
      // this sink again and could loop forever. Local logs still work.
    }
  }
}

/// A Talker observer that forwards ONLY error and exception events to a
/// [RemoteLogSink].
///
/// Deliberately ignores info/debug/warning logs: shipping every log line to
/// a hosted backend costs money and drowns the signal.
class RemoteLogTalkerObserver extends TalkerObserver {
  /// Creates a [RemoteLogTalkerObserver] forwarding to the given sink
  /// (passed as `sink:`).
  RemoteLogTalkerObserver({required this._sink});

  final RemoteLogSink _sink;

  @override
  void onError(TalkerError err) {
    _forward(
      level: 'error',
      message: err.displayMessage,
      stackTrace: err.stackTrace,
    );
  }

  @override
  void onException(TalkerException err) {
    _forward(
      level: 'error',
      message: err.displayMessage,
      stackTrace: err.stackTrace,
    );
  }

  // Builds the entry and fires the write without awaiting it: logging must
  // never block or crash the app.
  void _forward({
    required String level,
    required String message,
    StackTrace? stackTrace,
  }) {
    final RemoteLogEntry entry = RemoteLogEntry(
      level: level,
      message: message,
      stackTrace: stackTrace?.toString() ?? '',
      timestamp: DateTime.now().toUtc().toIso8601String(),
    );

    unawaited(_sink.write(entry));
  }
}
