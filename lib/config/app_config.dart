/// Compile-time application configuration.
///
/// All values are injected at build/run time via `--dart-define` or, more
/// conveniently, via `--dart-define-from-file=config/app_config.json`.
/// Copy `config/app_config.example.json` to `config/app_config.json` and
/// fill in your own Appwrite project values (see README).
///
/// No secrets are ever committed to the repository: the real
/// `config/app_config.json` is listed in `.gitignore`.
class AppConfig {
  // This class is a namespace for constants; it is never instantiated.
  const AppConfig._();

  /// The Appwrite API endpoint, e.g. `https://cloud.appwrite.io/v1`.
  static const String appwriteEndpoint = String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: 'https://cloud.appwrite.io/v1',
  );

  /// The Appwrite project ID from your Appwrite console.
  ///
  /// The default value is intentionally empty so that CI can compile the app
  /// without secrets; the app shows a clear error at runtime if it is empty.
  static const String appwriteProjectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
  );

  /// The ID of the Appwrite database that holds this app's tables.
  static const String appwriteDatabaseId = String.fromEnvironment(
    'APPWRITE_DATABASE_ID',
    defaultValue: 'app',
  );

  /// The ID of the table that stores one [UserSettings] row per user.
  static const String userSettingsTableId = String.fromEnvironment(
    'APPWRITE_USER_SETTINGS_TABLE_ID',
    defaultValue: 'user_settings',
  );

  /// The ID of the table that receives remote log entries
  /// (only used when [remoteLoggingEnabled] is true).
  static const String logsTableId = String.fromEnvironment(
    'APPWRITE_LOGS_TABLE_ID',
    defaultValue: 'logs',
  );

  /// The URL that Appwrite embeds in password recovery emails.
  ///
  /// The origin of this URL must be registered as a Web platform in the
  /// Appwrite console, otherwise `createRecovery` fails with a 400 error.
  static const String passwordRecoveryUrl = String.fromEnvironment(
    'PASSWORD_RECOVERY_URL',
    defaultValue: 'http://localhost:8080/reset-password',
  );

  /// Whether error/fatal logs are forwarded to the Appwrite `logs` table.
  ///
  /// Off by default; see `RemoteLogSink` and the README for details.
  static const bool remoteLoggingEnabled = bool.fromEnvironment(
    'REMOTE_LOGGING_ENABLED',
  );
}
