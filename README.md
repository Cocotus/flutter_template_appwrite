# Flutter Appwrite Template

A **production-ready Flutter starter template** for **Web (first-class), Windows and Linux desktop**:

- **Riverpod 3.x** with **code generation** (`@riverpod`) and **hooks** (`hooks_riverpod` + `flutter_hooks`) — no `StatefulWidget` anywhere
- **Freezed** data models with JSON serialization
- **Appwrite Cloud** backend: email/password auth + per-user settings stored in TablesDB
- **Talker** logging: console + in-app live log view, automatic Riverpod & route logging, optional remote log sink
- **go_router** with an auth guard and a persistent, collapsible sidebar shell (`StatefulShellRoute`)
- **Material 3** light/dark theming, **English/German** localization (ARB), responsive layout

The app itself is an *empty but complete* shell — login/register, home, settings, profile, about, help and a developer log view — meant to be cloned and extended.

## Screenshots

> _Placeholder — add screenshots of the login screen and the shell here._

## 1. Dev environment setup

### Flutter SDK

1. Install [VS Code](https://code.visualstudio.com/) with the **Flutter** extension (or Android Studio / IntelliJ with the Flutter plugin).
2. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) (this template was built with **Flutter 3.44.1 / Dart 3.12**) and verify with:
   ```sh
   flutter doctor
   ```
3. Enable the desktop/web targets:
   ```sh
   flutter config --enable-web --enable-windows-desktop --enable-linux-desktop
   ```
4. **Linux prerequisites** (build machine):
   ```sh
   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev libsecret-1-dev
   ```
   `libsecret-1-dev` is required by `flutter_secure_storage`; at runtime a keyring service (e.g. `gnome-keyring`) must be available.

### Appwrite Cloud setup

1. Create an account at [cloud.appwrite.io](https://cloud.appwrite.io) and create a **project**. Note the **Project ID** and the API **endpoint** (e.g. `https://cloud.appwrite.io/v1`).
2. **Add a Web platform** to the project (Appwrite console → your project → *Overview* → *Add platform* → *Web*) and register the hostname you serve the app from — `localhost` for development. Without this, browser requests are blocked by CORS. Also register the hostname of your **password recovery URL** (see config below), otherwise `createRecovery` fails with a 400 error.
3. Make sure **Email/Password** authentication is enabled (*Auth* → *Settings*).
4. Create a **Database** (default ID used by this template: `app`).
5. Inside it, create a **table** `user_settings` (TablesDB — databases → tables → rows):
   - Columns:

     | Column             | Type    | Required | Default |
     |--------------------|---------|----------|---------|
     | `isDarkMode`       | Boolean | no       | `false` |
     | `languageCode`     | String  | no       | `en`    |
     | `sidebarCollapsed` | Boolean | no       | `false` |
     | `developerMode`    | Boolean | no       | `false` |
     | `displayName`      | String  | no       | `""`    |

   - **Permissions:** enable **row security**. On the table, grant **Create** to role **Users** (any logged-in user may create their own row). Do **not** grant table-level read/update/delete — the app sets **owner-only row permissions** (`read`/`update`/`delete` for `Role.user(userId)`) on every row it writes.
   - The app stores **one row per user with the row ID equal to the Appwrite user ID**, so lookups are direct and there is exactly one settings row per user.
6. *(Optional, for remote logging)* create a table `logs` with columns `level` (String), `message` (String), `stackTrace` (String, size ~16384), `timestamp` (String), `userId` (String), and grant **Create** to role **Users**. See [Logging](#4-logging--debugging).
7. **Password reset (TODO for your app):** this template calls `account.createRecovery(...)` to send the reset email. The page that *completes* the reset (reads the `userId`/`secret` URL parameters and calls `account.updateRecovery(...)`) is intentionally not included — build it at the route your `PASSWORD_RECOVERY_URL` points to.

## 2. Configure the project

Copy the example config and fill in your values:

```sh
cp config/app_config.example.json config/app_config.json
```

```json
{
  "APPWRITE_ENDPOINT": "https://cloud.appwrite.io/v1",
  "APPWRITE_PROJECT_ID": "your-project-id",
  "APPWRITE_DATABASE_ID": "app",
  "APPWRITE_USER_SETTINGS_TABLE_ID": "user_settings",
  "APPWRITE_LOGS_TABLE_ID": "logs",
  "PASSWORD_RECOVERY_URL": "http://localhost:8080/reset-password",
  "REMOTE_LOGGING_ENABLED": false
}
```

`config/app_config.json` is **gitignored** — no secrets are ever committed. The values are injected at build time via `--dart-define-from-file` (see `lib/config/app_config.dart`).

## 3. Code generation & first run

Generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_localizations*.dart`) **are committed**, so the template builds out of the box. After changing models, providers or ARB files, regenerate:

```sh
flutter pub get
dart run build_runner build     # Riverpod / Freezed / JSON
flutter gen-l10n                # localizations (also runs on every build)
```

> `build_runner` ≥ 2.15 no longer needs `--delete-conflicting-outputs`; the flag is obsolete and ignored.

Run the app (pick your device):

```sh
flutter run -d chrome  --dart-define-from-file=config/app_config.json
flutter run -d windows --dart-define-from-file=config/app_config.json
flutter run -d linux   --dart-define-from-file=config/app_config.json
```

VS Code users: ready-made launch configurations are in `.vscode/launch.json`.

First start shows the **login screen**: register a user (this creates the Appwrite account, logs in and writes the default settings row), then explore Settings → enable **Developer mode** to reveal the **Logs** view.

## 4. Logging & debugging

All logging goes through **Talker** via `LoggerService` — never `print`/`debugPrint`:

- Logs appear in the **console** *and* in the in-app **Logs view** (sidebar entry; visible when **developer mode** is enabled in Settings, always visible in debug builds).
- **Riverpod** provider updates/failures are logged automatically (`TalkerRiverpodObserver`), as are **route changes** (`TalkerRouteObserver`) and **all uncaught errors** (`FlutterError.onError` + `PlatformDispatcher.onError`).
- The auth flow emits example logs (attempt/success/failure) with **redacted emails** — never log secrets or PII.
- **Remote logging (optional, off by default):** set `REMOTE_LOGGING_ENABLED` to `true` and create the `logs` table (see setup). Only `error`-level events are forwarded (`RemoteLogSink` → `AppwriteLogSink`). For real production crash monitoring, consider [Sentry](https://pub.dev/packages/sentry_flutter) (`sentry_flutter`) instead — deliberately not a default dependency.

## 5. Regenerate icons / favicon

All launcher icons come from a **single source image**: replace `assets/images/logo.png` (1024×1024 PNG) with your logo, then:

```sh
dart run flutter_launcher_icons
```

This regenerates the web favicon + manifest icons and the Windows `.ico`. Linux desktop icons are not covered by the tool — they are assigned at packaging time via a `.desktop` file.

## 6. Build & release (Web)

```sh
flutter build web --release
```

- **SPA fallback is required:** this app uses **path URLs** (`usePathUrlStrategy()`, e.g. `/login` instead of `/#/login`). Your static host must **rewrite all unknown paths to `index.html`**, otherwise refreshing or deep-linking any route returns 404. (Netlify: `/* /index.html 200` in `_redirects`; nginx: `try_files $uri /index.html;`; Firebase Hosting: `"rewrites": [{"source": "**", "destination": "/index.html"}]`.)
- **Renderer:** builds default to **CanvasKit**. You can opt into the WasmGC build with `flutter build web --wasm` (the old HTML renderer no longer exists).
- Remember to register the production hostname as a Web platform in the Appwrite console.

Windows/Linux release builds: `flutter build windows --release` / `flutter build linux --release` (CI builds all three — see `.github/workflows/ci.yml`).

> **Windows note:** if your checkout lives in a deeply nested folder, MSBuild can fail with `MSB3491 … exceeds the maximum path limit` (260 chars, triggered by plugin build files). Clone the repo close to the drive root (e.g. `C:\dev\my_app`) or enable Windows long-path support.

## 7. Project structure

```
lib/
├── main.dart            # bootstrap: URL strategy, error hooks → Talker, ProviderScope
├── app.dart             # MaterialApp.router: theme, locale, localization delegates
├── config/              # AppConfig (--dart-define), no secrets in code
├── models/              # Freezed models (UserSettings, RemoteLogEntry)
├── services/            # shared/cross-cutting logic as keepAlive providers:
│                        #   Appwrite client, Auth, Database (TablesDB), Logger,
│                        #   RemoteLogSink, Preferences, SecureStorage,
│                        #   UserSettings, Theme, Locale, AppVersion
├── router/              # go_router: auth guard + StatefulShellRoute shell
├── views/               # one folder per feature: view (+ paired controller)
│   ├── login/           #   login_view.dart + login_controller.dart
│   ├── shell/           #   header + collapsible NavigationRail
│   ├── home/ settings/ profile/ about/ help/ logs/ splash/
├── widgets/             # reusable loading / error / empty / snackbar / avatar
├── utils/               # redactEmail, mapAuthError
└── l10n/                # app_en.arb, app_de.arb (+ generated localizations)
```

**Rule of thumb:** a *controller* holds the logic of **one view**; a *service* holds logic **shared by many views** (DB, theme, config, logging) and is a keepAlive singleton provider.

## 8. Coding conventions

> This template intentionally favors explicit, verbose, beginner-friendly Dart over concise expert-style code, follows the official Dart naming guidelines, and documents all public APIs, so an average/intermediate Flutter developer can read and extend it.

Hard rules (enforced across the whole codebase):

- **No `StatefulWidget` / `ConsumerStatefulWidget`.** `StatelessWidget` only for logic-free UI; anything with state uses `ConsumerWidget` or `HookConsumerWidget` plus a paired `@riverpod` controller (`xyz_view.dart` + `xyz_controller.dart`).
- **`TextEditingController`s live in the view** via `useTextEditingController()` (auto-disposed by hooks); controllers receive **plain Strings only** and **never a `BuildContext`**. UI-only flags (e.g. password visibility) use `useState`.
- View logic lives in **controllers**, shared logic in **services**; controllers call services, **never the raw Appwrite client** — that keeps them mockable (see `test/fakes/`).
- Long-lived services are `@Riverpod(keepAlive: true)`; everything else auto-disposes (Riverpod 3 default).
- All models are **`@freezed`** with `fromJson`/`toJson`.
- All async work is exposed as **`AsyncValue`**; views render it with the shared loading/error/empty widgets and react to results via `ref.listen` (snackbars, navigation).
- **All logging via Talker** (`LoggerService`) — no `print`/`debugPrint`; log exceptions once, where they are handled, with context; **never log secrets or PII** (redact emails etc.).
- **Style:** explicit types, block bodies over multi-step `=>`, `if`/`else` over nested ternaries, named intermediate variables over long call chains, `_buildXxx()` helpers for big widget trees, `///` docs on every public API, `lowerCamelCase` constants, `snake_case` file names.

### Documented deviations from common older guides

- **TablesDB instead of the legacy `Databases` API** — Appwrite 1.9+ presents databases → *tables* → *rows*; the older collections/documents API still exists but is marked legacy.
- **`riverpod_lint` runs as a native analyzer plugin** (3.1+): configured via the `plugins:` block in `analysis_options.yaml`; findings appear in `flutter analyze`. `custom_lint` is no longer needed.
- **No `runZonedGuarded`** around `runApp`: `PlatformDispatcher.instance.onError` already catches uncaught async errors on all targets and avoids zone-mismatch issues (current Flutter guidance).
- **Appwrite session persistence is SDK-managed** (cookies/internal store). `flutter_secure_storage` is included as the sanctioned place for any *future* secrets (`SecureStorageService`), not for session tokens.

## 9. Tests

```sh
flutter test
```

- `test/views/login_view_test.dart` — widget tests: form renders, register-mode toggle, password eye toggle.
- `test/controllers/login_controller_test.dart` — controller tests against hand-written fakes (`test/fakes/fake_services.dart`) via provider overrides; no network involved.

## License

[MIT](LICENSE)
