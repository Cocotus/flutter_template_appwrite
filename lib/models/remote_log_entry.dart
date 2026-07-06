import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_log_entry.freezed.dart';
part 'remote_log_entry.g.dart';

/// A single log event that is written to the Appwrite `logs` table.
///
/// Only `error` and `fatal` level events are forwarded remotely (see
/// `RemoteLogSink`), and only when remote logging is enabled via the
/// `REMOTE_LOGGING_ENABLED` config flag.
///
/// Never put secrets or PII (passwords, tokens, full email addresses) into
/// [message] — redact values before logging (see `redactEmail`).
@freezed
abstract class RemoteLogEntry with _$RemoteLogEntry {
  /// Creates a [RemoteLogEntry] instance.
  const factory RemoteLogEntry({
    /// The log level, e.g. `error` or `fatal`.
    required String level,

    /// The (already redacted) log message.
    required String message,

    /// The stack trace as text, or an empty string when not available.
    @Default('') String stackTrace,

    /// The moment the event was logged, in UTC ISO-8601 format.
    required String timestamp,

    /// The Appwrite user ID of the current session, or an empty string
    /// when the event happened while nobody was logged in.
    @Default('') String userId,
  }) = _RemoteLogEntry;

  /// Creates a [RemoteLogEntry] instance from a JSON map.
  factory RemoteLogEntry.fromJson(Map<String, dynamic> json) =>
      _$RemoteLogEntryFromJson(json);
}
