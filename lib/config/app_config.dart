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

  /// The ID of the table that stores one premium `Entitlement` row per
  /// paying user (written only by the payment webhook function).
  static const String entitlementsTableId = String.fromEnvironment(
    'APPWRITE_ENTITLEMENTS_TABLE_ID',
    defaultValue: 'entitlements',
  );

  /// The hosted checkout URL of the premium product (e.g. a Lemon Squeezy
  /// "buy" link). NO secret — it is a public storefront URL; the app only
  /// appends the account e-mail and user ID as query parameters.
  ///
  /// Empty (the default) disables the buy button; the premium card then
  /// shows a configuration hint instead.
  static const String premiumCheckoutUrl = String.fromEnvironment(
    'PREMIUM_CHECKOUT_URL',
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

  /// Whether the app is ALLOWED to run in demo mode (fake auth + in-memory
  /// data, no Appwrite backend required).
  ///
  /// This is the real, compile-time kill switch for the demo feature. It
  /// gates BOTH the visibility of the login-page demo switch AND the ability
  /// of the service layer to select the fake implementations — a runtime
  /// toggle alone can never bypass authentication in a shipped binary.
  ///
  /// - Production build: omit the define → `false` → demo unreachable, the
  ///   app always validates against Appwrite.
  /// - Demo/showcase build: pass `--dart-define=DEMO_MODE_ALLOWED=true`.
  /// - Debug builds additionally allow it regardless (see `DemoMode`), so
  ///   developers can flip it without a special build.
  static const bool demoModeAllowed = bool.fromEnvironment(
    'DEMO_MODE_ALLOWED',
  );
}
