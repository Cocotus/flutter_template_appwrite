import 'dart:async';

import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/services/remote_log/remote_log_sink.dart';

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
