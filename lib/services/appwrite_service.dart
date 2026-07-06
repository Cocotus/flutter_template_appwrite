import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';

part 'appwrite_service.g.dart';

/// Owns the single Appwrite [Client] and the API objects built on top of it.
///
/// This is the ONLY place in the app that constructs the raw Appwrite
/// client. Everything else goes through [AuthService] (for [account]) or
/// [DatabaseService] (for [tablesDB]) so that controllers stay testable and
/// never talk to Appwrite directly.
///
/// Session persistence note: the Appwrite Flutter SDK manages its own
/// session storage (browser cookies on web, an internal cookie store on
/// desktop). The app never sees a raw session token, so nothing needs to be
/// stored manually — see `SecureStorageService` for the prepared extension
/// point if you ever handle custom secrets.
class AppwriteService {
  /// Creates an [AppwriteService] and configures the underlying [Client]
  /// from [AppConfig] (endpoint + project ID via --dart-define).
  AppwriteService() {
    _client = Client()
        .setEndpoint(AppConfig.appwriteEndpoint)
        .setProject(AppConfig.appwriteProjectId);
    _account = Account(_client);
    _tablesDB = TablesDB(_client);
  }

  late final Client _client;
  late final Account _account;
  late final TablesDB _tablesDB;

  /// The raw Appwrite client (exposed for advanced use only).
  Client get client => _client;

  /// The Appwrite Account API (authentication, sessions, recovery).
  Account get account => _account;

  /// The Appwrite TablesDB API (databases → tables → rows).
  ///
  /// TablesDB is the current Appwrite data API; the older `Databases`
  /// (collections/documents) API still exists but is marked legacy.
  TablesDB get tablesDB => _tablesDB;
}

/// Provides the single app-wide [AppwriteService] instance.
///
/// Kept alive for the whole app lifetime: the client owns the session and
/// must not be re-created between views.
@Riverpod(keepAlive: true)
AppwriteService appwriteService(Ref ref) {
  return AppwriteService();
}
