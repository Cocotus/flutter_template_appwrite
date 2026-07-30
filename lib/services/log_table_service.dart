import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';
import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/services/appwrite_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_log_table_service.dart';
import 'package:flutter_template_appwrite/services/demo_mode.dart';

part 'log_table_service.g.dart';

/// Writes error/fatal log entries into the optional Appwrite `logs` table.
///
/// This is the only thing in the template that still uses the TablesDB API, and
/// it is deliberately narrow: a write-only sink for telemetry, used solely by
/// `AppwriteLogSink` and only when `REMOTE_LOGGING_ENABLED` is true.
///
/// User settings and user data do NOT live in a table — see
/// [CloudSyncService] for why (account preferences and a Storage bucket).
class LogTableService {
  /// Creates a [LogTableService] that talks to the given TablesDB API
  /// (callers pass it as `tablesDB:`).
  LogTableService({required this._tablesDB});

  final TablesDB _tablesDB;

  /// Writes one log [entry] into the `logs` table.
  Future<void> writeLogEntry(RemoteLogEntry entry) async {
    await _tablesDB.createRow(
      databaseId: AppConfig.appwriteDatabaseId,
      tableId: AppConfig.logsTableId,
      rowId: ID.unique(),
      data: entry.toJson(),
    );
  }
}

/// Provides the app-wide [LogTableService] instance.
///
/// Kept alive because the logger outlives every view. In demo mode it returns
/// a [DemoLogTableService], so a demo run never posts anything anywhere.
@Riverpod(keepAlive: true)
LogTableService logTableService(Ref ref) {
  if (ref.watch(demoModeProvider)) {
    return DemoLogTableService();
  }
  final AppwriteService appwrite = ref.watch(appwriteServiceProvider);
  return LogTableService(tablesDB: appwrite.tablesDB);
}
