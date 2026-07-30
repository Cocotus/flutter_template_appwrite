import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/services/log_table_service.dart';

/// No-op [LogTableService] used when demo mode is active.
///
/// A demo run has no backend to post to, and shipping a showcase build's log
/// entries into a real project's `logs` table would be pure noise.
class DemoLogTableService implements LogTableService {
  @override
  Future<void> writeLogEntry(RemoteLogEntry entry) async {
    // Remote logging is a no-op in demo mode.
  }
}
