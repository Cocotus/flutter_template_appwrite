import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';

part 'appwrite_service.g.dart';

/// Owns the single Appwrite [Client] and the API objects built on top of it.
///
/// This is the ONLY place in the app that constructs the raw Appwrite
/// client. Everything else goes through [AuthService] (for [account]),
/// [CloudSyncService] (for [account] prefs + [storage]) or [LogTableService]
/// (for [tablesDB]) so that controllers stay testable and never talk to
/// Appwrite directly.
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
    _storage = Storage(_client);
    _tablesDB = TablesDB(_client);
  }

  late final Client _client;
  late final Account _account;
  late final Storage _storage;
  late final TablesDB _tablesDB;

  /// The raw Appwrite client (exposed for advanced use only).
  Client get client => _client;

  /// The Appwrite Account API (authentication, sessions, recovery, and the
  /// per-user preferences object — see [CloudSyncService]).
  Account get account => _account;

  /// The Appwrite Storage API (buckets → files).
  ///
  /// Holds the user-data document, which can outgrow the 64 kB
  /// account-preferences object (see [CloudSyncService]).
  Storage get storage => _storage;

  /// The Appwrite TablesDB API (databases → tables → rows).
  ///
  /// Used ONLY by the optional `logs` table (see [LogTableService]) and the
  /// premium `entitlements` table. User settings and user data deliberately
  /// do not live in a table at all — see [CloudSyncService].
  ///
  /// TablesDB is the current Appwrite data API; the older `Databases`
  /// (collections/documents) API still exists but is marked legacy.
  TablesDB get tablesDB => _tablesDB;
}

/// Provides the single app-wide [AppwriteService] instance.
///
/// Kept alive for the whole app lifetime: the client owns the session and
/// must not be re-created between views.
///
/// Throws a [StateError] when read in a build with `HAS_LOGIN=false`. In that
/// profile the app has no user identity, so nothing may talk to Appwrite at
/// all — settings and user data live purely in `shared_preferences`. Failing
/// loudly here turns that rule into something the code guarantees rather than
/// something a comment asks for.
@Riverpod(keepAlive: true)
AppwriteService appwriteService(Ref ref) {
  if (AppConfig.hasLogin == false) {
    throw StateError(
      'AppwriteService was read in a build with HAS_LOGIN=false. '
      'Without a login there is no user to key remote data on: settings and '
      'user data are stored locally via PreferencesService only.',
    );
  }
  return AppwriteService();
}
