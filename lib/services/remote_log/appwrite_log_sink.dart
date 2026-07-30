import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/services/auth/current_user.dart';
import 'package:flutter_template_appwrite/services/log_table_service.dart';
import 'package:flutter_template_appwrite/services/remote_log/remote_log_sink.dart';

/// A [RemoteLogSink] that writes entries as rows into the Appwrite `logs`
/// table via [LogTableService].
///
/// Only ever receives error/fatal events (see `RemoteLogTalkerObserver`),
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
      final LogTableService logTableService =
          _ref.read(logTableServiceProvider);

      // Attach the current user ID when someone is logged in, so log rows
      // can be correlated with a user. An empty string means "anonymous".
      final String userId =
          _ref.read(currentUserProvider).value?.$id ?? '';

      final RemoteLogEntry entryWithUser = entry.copyWith(userId: userId);
      await logTableService.writeLogEntry(entryWithUser);
    } catch (_) {
      // Intentionally swallowed: if remote logging itself fails we must NOT
      // log that failure as an error, because that would be forwarded to
      // this sink again and could loop forever. Local logs still work.
    }
  }
}
