/// Compile-time application configuration.
///
/// All values are injected at build/run time via `--dart-define` or, more
/// conveniently, via `--dart-define-from-file=config/app_config.json`.
/// Copy `config/app_config.example.json` to `config/app_config.json` and
/// fill in your own Appwrite project values (see README §2).
///
/// No secrets are ever committed to the repository: the real
/// `config/app_config.json` is listed in `.gitignore`.
///
/// ## Deployment profiles
///
/// [hasLogin], [hasPremium] and [demoModeAllowed] are independent flags,
/// but in practice they combine into four profiles this template already
/// supports without touching a single line of Dart:
///
/// | Profile | `HAS_LOGIN` | `HAS_PREMIUM` | `DEMO_MODE_ALLOWED` | Notes |
/// |---|---|---|---|---|
/// | **Full SaaS** (this template's own default) | `true` | `true` | `false` | Real Appwrite login required; premium checkout wired once you set `PREMIUM_CHECKOUT_URL` (§7). |
/// | **Freeware / public tool** | `false` | `false` | `false` | No login, no paid tier, settings live in-memory only; optionally set [buyMeCoffeeUsername] for a donate button. `morpatcher_flutter` — a real app built from this template — ships exactly this profile. |
/// | **Demo / showcase build** | *(leave at default)* | *(leave at default)* | `true` | Visitors see the real login screen but can flip its Demo mode switch into in-memory fakes — nothing else about the app changes. |
/// | **GitHub Pages public demo** | *(leave at default)* | *(leave at default)* | `true` | Exactly the demo/showcase profile; this is what `.github/workflows/gh-pages.yml` builds (README §11). |
///
/// Mix and match rather than treating these as fixed presets — e.g. a
/// freeware fork can still add `DEMO_MODE_ALLOWED=true` to its own GitHub
/// Pages build, even though [hasLogin] being `false` already means there is
/// no login screen for a demo switch to appear on (see [demoModeAllowed]).
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
  ///   This is orthogonal to [hasLogin]/[hasPremium] — leave those at
  ///   whatever your fork ships with; demo mode only changes what backs the
  ///   login screen, not whether one exists. GitHub Pages deployments use
  ///   this (README §11) to show a real login screen with no real backend.
  /// - Debug builds additionally allow it regardless (see `DemoMode`), so
  ///   developers can flip it without a special build.
  ///
  /// Only meaningful when [hasLogin] is `true`: with `hasLogin: false`
  /// there is no login page at all, so there is no demo switch to gate —
  /// see the "Freeware / public tool" profile in the class doc above.
  static const bool demoModeAllowed = bool.fromEnvironment(
    'DEMO_MODE_ALLOWED',
  );

  /// Whether the app ships with a premium/subscription offering.
  ///
  /// Set to `false` for freeware apps or open-source tools where there is no
  /// paid tier. When `false`:
  ///   - The premium-checkout card on the profile page is hidden, so
  ///     [premiumCheckoutUrl] and [entitlementsTableId] stop mattering.
  ///   - The "Buy Me a Coffee" donate button is shown in the sidebar
  ///     instead (provided [buyMeCoffeeUsername] is non-empty) — the two
  ///     are mutually exclusive on purpose, a shipped app either sells
  ///     something or asks for tips, never both.
  ///
  /// Production default: `true` (premium feature enabled, no donate
  /// button) — this template ships expecting a paid tier; flip to `false`
  /// for the "Freeware / public tool" profile in the class doc above.
  static const bool hasPremium = bool.fromEnvironment(
    'HAS_PREMIUM',
    defaultValue: true,
  );

  /// Whether the app requires user authentication.
  ///
  /// Set to `false` for fully public tools that need no login. When `false`:
  ///   - The router skips the login page and splash auth-check entirely —
  ///     see `AppRouter`'s redirect logic.
  ///   - Appwrite auth services are never called; `CurrentUser.build`
  ///     returns `null` immediately, so not even a network round-trip to
  ///     check for a session happens.
  ///   - User settings live only in memory for the current session
  ///     (no cloud persistence, because there is no user identity to key on).
  ///   - [demoModeAllowed] becomes moot — there is no login screen left for
  ///     its demo switch to appear on.
  ///
  /// Production default: `true` (login required) — this template ships
  /// expecting a real Appwrite backend; flip to `false` for the
  /// "Freeware / public tool" profile in the class doc above. To showcase
  /// the template publicly without flipping this, use [demoModeAllowed]
  /// instead — it keeps the real login screen but backs it with fakes.
  static const bool hasLogin = bool.fromEnvironment(
    'HAS_LOGIN',
    defaultValue: true,
  );

  /// The Buy Me a Coffee account slug (the part after buymeacoffee.com/).
  ///
  /// Used only when [hasPremium] is `false` (see there). Leave empty (the
  /// default) to suppress the donate button even in freeware mode — e.g.
  /// while a fork is still using this template's own generic branding and
  /// has no donate account of its own yet. Once a fork has a fixed identity
  /// of its own (its own name, its own repo), consider hardcoding your slug
  /// as this field's `defaultValue` instead of relying on `--dart-define`
  /// in every build/workflow — the same idea as the `githubUrl` constant in
  /// `lib/views/shell/app_shell.dart` (also a placeholder to replace, see
  /// the README's "Two dead placeholder URLs" checklist item). For a
  /// worked example, see `morpatcher_flutter`'s `AppConfig.buyMeCoffeeUsername`,
  /// which does exactly this.
  static const String buyMeCoffeeUsername = String.fromEnvironment(
    'BUY_ME_COFFEE_USERNAME',
  );
}
