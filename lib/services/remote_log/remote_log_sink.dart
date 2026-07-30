import 'package:flutter_template_appwrite/models/remote_log_entry.dart';

/// Destination for log events that should leave the device.
///
/// On Web and Desktop the end user has no terminal, so serious errors in
/// production are invisible unless they are shipped somewhere. This small
/// abstraction keeps the "where" pluggable: the template ships an
/// `AppwriteLogSink`; for full production crash monitoring consider Sentry
/// (`sentry_flutter`) instead — see the README.
abstract class RemoteLogSink {
  /// Persists one log [entry] remotely.
  Future<void> write(RemoteLogEntry entry);
}
