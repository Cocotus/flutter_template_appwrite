# Flutter Appwrite Template

A **production-ready Flutter starter template** for **Web (first-class), Windows and Linux desktop**:

- **Riverpod 3.x** with **code generation** (`@riverpod`) and **hooks** (`hooks_riverpod` + `flutter_hooks`) — no `StatefulWidget` anywhere
- **Freezed** data models with JSON serialization
- **Appwrite Cloud** backend: email/password auth + per-user settings stored in TablesDB
- **Talker** logging: console + in-app live log view, automatic Riverpod & route logging, optional remote log sink
- **go_router** with an auth guard and a persistent, collapsible sidebar shell (`StatefulShellRoute`)
- **Material 3** light/dark theming, **English/German** localization (ARB), responsive layout
- **Admin-dashboard design**: full-height dark sidebar (accent-tinted, grouped menu sections, user card + logout at the bottom) with a light page header over the content area; bundled **Inter** font
- **In-app Markdown docs**: the Help page renders a checked-in user manual (`docs/help_<locale>.md`) — versioned with the code, works offline
- **Reusable base widgets** (`lib/widgets/`): text/password fields, dropdown, switch tile, primary/secondary buttons with loading spinner, section headers — the Home page demonstrates them live, wired to a Riverpod controller
- **Offline / intranet ready**: no Google Fonts or other runtime CDN fetches required (see the offline section below)

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
2. **Add a Web platform** to the project (Appwrite console → your project → *Overview* → *Add platform* → *Web*) and register the hostname you serve the app from — `localhost` for development, your production domain later.
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

   - **Permissions:** enable **row security**. On the table, grant **Create** to role **Users** (any logged-in user may create their own row). Do **not** grant table-level read/update/delete — those are granted at row level automatically when the user creates their row (the code sets the user as document owner).
   - The app stores **one row per user with the row ID equal to the Appwrite user ID**, so lookups are direct and there is exactly one settings row per user.
6. *(Optional, for remote logging)* create a table `logs` with columns `level` (String), `message` (String), `stackTrace` (String, size ~16384), `timestamp` (String), `userId` (String), and grant **Create** to role **Users**.
7. **Password reset (TODO for your app):** this template calls `account.createRecovery(...)` to send the reset email. The page that *completes* the reset (reads the `userId`/`secret` URL parameters and calls `account.updateRecovery(...)`) is **not implemented** in this template — you must add it. The `PASSWORD_RECOVERY_URL` in the config is a placeholder.

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

First start shows the **login screen**: register a user (this creates the Appwrite account, logs in and writes the default settings row), then explore Settings → enable **Developer mode** to reveal the Logs view in the sidebar.

## 4. Logging & debugging

All logging goes through **Talker** via `LoggerService` — never `print`/`debugPrint`:

- Logs appear in the **console** *and* in the in-app **Logs view** (sidebar entry; visible when **developer mode** is enabled in Settings, always visible in debug builds).
- **Riverpod** provider updates/failures are logged automatically (`TalkerRiverpodObserver`), as are **route changes** (`TalkerRouteObserver`) and **all uncaught errors** (`FlutterError.onError` + `PlatformDispatcher.instance.onError`).
- The auth flow emits example logs (attempt/success/failure) with **redacted emails** — never log secrets or PII.
- **Remote logging (optional, off by default):** set `REMOTE_LOGGING_ENABLED` to `true` and create the `logs` table (see setup). Only `error`-level events are forwarded (`RemoteLogSink` → `Appwrite TablesDB`).

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

- **SPA fallback is required:** this app uses **path URLs** (`usePathUrlStrategy()`, e.g. `/login` instead of `/#/login`). Your static host must **rewrite all unknown paths to `index.html`**, otherwise direct navigation and browser refresh break. Firebase Hosting, Netlify, Vercel do this by default with the right config file (see their docs).
- **Renderer:** builds default to **CanvasKit**. You can opt into the WasmGC build with `flutter build web --wasm` (the old HTML renderer no longer exists).
- Remember to register the production hostname as a Web platform in the Appwrite console.

### Offline / intranet deployments

Classic Flutter-web pitfall: by default a release build loads **CanvasKit from Google's CDN** (`gstatic.com`) and, when using the `google_fonts` package, **fonts from Google Fonts at runtime** — on a closed intranet the app then hangs or falls back badly. This template avoids both:

- **Fonts are bundled:** Inter ships as asset TTFs (`assets/fonts/`, OFL licensed, see the pubspec `fonts:` section). The `google_fonts` package is deliberately NOT used.
- **Bundle CanvasKit into the build** instead of loading it from gstatic:

  ```sh
  flutter build web --release --no-web-resources-cdn
  ```

  This copies CanvasKit into `build/web/canvaskit/` so everything is served from your own host. (During `flutter run` CanvasKit is always served locally — the flag matters for release builds.)
- **Login shows an offline hint** (crossed-out network icon) when the Appwrite backend is unreachable; the app itself stays usable — e.g. the demo mode runs entirely in memory.
- Remaining caveat: glyphs missing from Inter/Material Icons (e.g. emoji) normally come from Google's Noto fallback fonts at runtime; offline they simply don't render. Bundle extra fonts if you need them.

Windows/Linux release builds: `flutter build windows --release` / `flutter build linux --release` (CI builds all three — see `.github/workflows/ci.yml`).

> **Windows note:** if your checkout lives in a deeply nested folder, MSBuild can fail with `MSB3491 … exceeds the maximum path limit` (260 chars, triggered by plugin build files). Clone the repo at a shorter path (e.g. `C:\dev\myapp`) or enable long path support: `reg add HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1`.

## 7. Premium licensing / monetization (optional)

The template ships a complete, opt-in premium flow for selling a **one-time
"lifetime" upgrade** (e.g. premium support) as a solo developer:

```
App ──"Buy Premium"──▶ Lemon Squeezy hosted checkout (email + userId pre-filled)
                              │ payment (PayPal/card; LS is Merchant of Record → handles VAT & invoices)
                              ▼
                LS webhook `order_created` (HMAC-signed)
                              ▼
                Appwrite Function `lemonsqueezy-webhook` (verifies signature)
                              ▼
                table `entitlements` (row ID = user ID, READ-only for the user)
                              ▲
App ──login / "Check purchase"┘  premiumStatusProvider → isPremiumProvider → PremiumGate
```

**Why this shape:** the client never decides about premium — the existence of
an `entitlements` row (writable only by the webhook function via API key) IS
the entitlement. A Merchant of Record (Lemon Squeezy, Paddle, Polar) acts as
the seller, so EU VAT, invoices and refunds are their problem, not yours. No
secret ever ships in the app: the checkout link is a public URL, the signing
secret and API key live only in the function.

Setup:

1. **Appwrite:** create table `entitlements` with String columns `plan`,
   `orderId`, `purchasedAt`, `email`. Enable row security. Do **not** grant
   any table-level permissions to Users — only the function writes rows.
2. **Function:** deploy `functions/lemonsqueezy-webhook/` (Node 18+ runtime,
   entrypoint `src/main.js`, HTTP trigger, public execute access). Set env
   vars `LS_SIGNING_SECRET` and `APPWRITE_API_KEY` (scopes: `rows.read`,
   `rows.write`, `users.read`).
3. **Lemon Squeezy:** create a product (one-time purchase), copy its "buy
   link" into `PREMIUM_CHECKOUT_URL` in `config/app_config.json`, and add a
   webhook (event `order_created`) pointing at the function's URL with the
   same signing secret.
4. **Test the webhook without paying** (replace secret/URL):
   ```sh
   BODY='{"meta":{"event_name":"order_created","custom_data":{"user_id":"<APPWRITE_USER_ID>"}},"data":{"id":"1","attributes":{"identifier":"test-1","user_email":"user@example.com","created_at":"2026-01-01T00:00:00Z"}}}'
   SIG=$(printf '%s' "$BODY" | openssl dgst -sha256 -hmac "<LS_SIGNING_SECRET>" -hex | sed 's/^.* //')
   curl -X POST "<FUNCTION_URL>" -H "X-Signature: $SIG" -H "Content-Type: application/json" -d "$BODY"
   ```
   Then press **"Check purchase"** on the profile page — the account flips
   to premium.

In the app: the profile page shows the premium card (status / buy / check),
`isPremiumProvider` exposes the flag, and wrapping any widget in
`PremiumGate(child: ...)` locks it for free users. Demo mode simulates a
premium user (see `DemoLicenseService`). Remember: UI gating protects access
to services (support, server features) — a web client's code itself cannot
be copy-protected.

## 8. Project structure

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
│   ├── shell/           #   app_shell (page header) + app_sidebar (dark rail)
│   ├── home/ settings/ profile/ about/ help/ logs/ splash/
├── widgets/             # reusable loading / error / empty / snackbar / avatar
├── utils/               # redactEmail, mapAuthError
└── l10n/                # app_en.arb, app_de.arb (+ generated localizations)
```

**Rule of thumb:** a *controller* holds the logic of **one view**; a *service* holds logic **shared by many views** (DB, theme, config, logging) and is a keepAlive singleton provider.

## 9. Coding conventions

> This template intentionally favors explicit, verbose, beginner-friendly Dart over concise expert-style code, follows the official Dart naming guidelines, and documents all public APIs, so an average Flutter developer can read, modify and learn from it without prior Riverpod/Freezed experience.

Hard rules (enforced across the whole codebase):

- **No `StatefulWidget` / `ConsumerStatefulWidget`.** `StatelessWidget` only for logic-free UI; anything with state uses `ConsumerWidget` or `HookConsumerWidget` plus a paired `@riverpod` controller.
- **`TextEditingController`s live in the view** via `useTextEditingController()` (auto-disposed by hooks); controllers receive **plain Strings only** and **never a `BuildContext`**. UI-only flags (password visibility toggle, checkbox state) stay in the view as hooks; domain logic goes into the controller.
- View logic lives in **controllers**, shared logic in **services**; controllers call services, **never the raw Appwrite client** — that keeps them mockable (see `test/fakes/`).
- Long-lived services are `@Riverpod(keepAlive: true)`; everything else auto-disposes (Riverpod 3 default).
- All models are **`@freezed`** with `fromJson`/`toJson`.
- All async work is exposed as **`AsyncValue`**; views render it with the shared loading/error/empty widgets and react to results via `ref.listen` (snackbars, navigation).
- **All logging via Talker** (`LoggerService`) — no `print`/`debugPrint`; log exceptions once, where they are handled, with context; **never log secrets or PII** (redact emails etc.).
- **Style:** explicit types, block bodies over multi-step `=>`, `if`/`else` over nested ternaries, named intermediate variables over long call chains, `_buildXxx()` helpers for big widget trees, consistent newline placement (`trailing commas + dartfmt`).

### Documented deviations from common older guides

- **TablesDB instead of the legacy `Databases` API** — Appwrite 1.9+ presents databases → *tables* → *rows*; the older collections/documents API still exists but is marked legacy.
- **`riverpod_lint` runs as a native analyzer plugin** (3.1+): configured via the `plugins:` block in `analysis_options.yaml`; findings appear in `flutter analyze`. `custom_lint` is no longer needed.
- **No `runZonedGuarded`** around `runApp`: `PlatformDispatcher.instance.onError` already catches uncaught async errors on all targets and avoids zone-mismatch issues (current Flutter guidance).
- **Appwrite session persistence is SDK-managed** (cookies/internal store). `flutter_secure_storage` is included as the sanctioned place for any *future* secrets (`SecureStorageService`), not for session tokens.

## 10. Tests

```sh
flutter test
```

- `test/views/login_view_test.dart` — widget tests: form renders, register-mode toggle, password eye toggle.
- `test/controllers/login_controller_test.dart` — controller tests against hand-written fakes (`test/fakes/fake_services.dart`) via provider overrides; no network involved.

---

## 11. Tutorial: Building your own app from this template

This section walks you through transforming this empty shell into your own application — step by step. It's aimed at **intermediate Flutter developers** who want to use the template as a starting point for a tool, utility app, or small project.

> **Reference implementation:** the [moru](https://github.com/Cocotus/moru) project is a real-world example built from this template.

---

### Step 0 — Prerequisites

- Flutter SDK installed (Dart ≥ 3.12)
- An editor (VS Code or Android Studio / IntelliJ)
- Access to an [Appwrite Cloud](https://appwrite.io/) project (or local instance), if you use auth/database features

---

### Step 1 — Create your repository

1. Create a new empty GitHub repository (e.g. `my-tool`).
2. Clone this template locally:
   ```bash
   git clone https://github.com/Cocotus/flutter_template_appwrite my-tool
   cd my-tool
   ```
3. Change the Git remote to your new repo:
   ```bash
   git remote set-url origin https://github.com/YOUR_USER/my-tool
   git push -u origin main
   ```

---

### Step 2 — Rename the app and package ID

These references must be updated **everywhere** in the project:

| File | What to change |
|---|---|
| `pubspec.yaml` | `name:` (e.g. `my_tool`) and `description:` |
| `lib/` — all `import` statements | Package name in import paths (`flutter_template_appwrite` → `my_tool`) |
| `android/app/build.gradle` | `applicationId` |
| `windows/runner/Runner.rc` | `ProductName`, `FileDescription` |
| `web/index.html` | `<title>` |
| `web/manifest.json` | `"name"` and `"short_name"` |

**Tip:** Use a global find & replace (`flutter_template_appwrite` → `my_tool`) across the entire project folder, then run:
```bash
flutter pub get
```

---

### Step 3 — App title (window title / AppBar title)

The title that appears in the AppBar and the OS window title comes from two places:

1. **`lib/app.dart`** — where `MaterialApp.router` or `title:` is set.
2. **Translation files** (see Step 5) — the title comes from the localization key `appTitle`.

Update both ARB files:
```jsonc
// lib/l10n/app_en.arb
"appTitle": "My Tool"

// lib/l10n/app_de.arb
"appTitle": "Mein Tool"
```

---

### Step 4 — Replace the logo / app icon

The template uses **a single source image** for all platform icons:

```
assets/images/logo.png   ← place your logo here (1024×1024 px, PNG)
```

Then run once:
```bash
dart run flutter_launcher_icons
```

This automatically regenerates all platform-specific icons (Windows `.ico`, Web `favicon.png`, etc.). Configuration is at the bottom of `pubspec.yaml` under `flutter_launcher_icons:`.

**Note:** Linux desktop icons are not covered by this tool. For Linux, the icon must be set separately via a `.desktop` file during packaging.

The logo image is also displayed in the app itself (e.g. splash screen or login page):
```dart
Image.asset('assets/images/logo.png')
```

---

### Step 5 — Localization: adding new text strings

All user-facing text belongs **in the translation files**, never as string literals in widget code.

**Which files to edit?**
- `lib/l10n/app_en.arb` — English texts (the template file)
- `lib/l10n/app_de.arb` — German texts

**Never edit** the `.dart` files in the `l10n` folder! `app_localizations.dart`, `app_localizations_de.dart`, and `app_localizations_en.dart` are **auto-generated** and overwritten on every build. They should ideally be added to `.gitignore`.

**Example — adding a new text:**
```jsonc
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "My Tool",
  "patchButtonLabel": "Apply Patch",
  "@patchButtonLabel": {
    "description": "Label on the main patch action button"
  },
  "patchSuccess": "Patch applied successfully!",
  "@patchSuccess": {}
}
```
```jsonc
// lib/l10n/app_de.arb
{
  "@@locale": "de",
  "appTitle": "Mein Tool",
  "patchButtonLabel": "Patch anwenden",
  "patchSuccess": "Patch erfolgreich angewendet!"
}
```

After editing, run `flutter pub get` (or just save — VS Code triggers the generation automatically). Use the texts in code:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Inside a build() method:
final AppLocalizations l10n = AppLocalizations.of(context)!;
Text(l10n.patchButtonLabel)
```

---

### Step 6 — Change the default accent color

The template starts with a blue shade as the default color. The **only place** you need to change is:

```dart
// lib/theme/app_theme.dart — around line 24
static const Color defaultSeedColor = Color(0xFF3D5AFE); // ← your color here
```

This automatically derives the entire Material 3 color scheme (light, dark, sidebar, buttons, etc.) — you don't need to adjust anything else in the theme.

**Tip:** The list of accent colors offered in Settings is in `lib/theme/accent_colors.dart`. The first entry should point to `AppTheme.defaultSeedColor`:
```dart
// Good: no duplicate color value
AccentColor(name: 'My Color', color: AppTheme.defaultSeedColor),
```

---

### Step 7 — Create a new view (page)

A new page consists of at least two files:

```
lib/views/my_page/
  my_page_view.dart       ← the widget (ConsumerWidget, no StatefulWidget)
  my_page_controller.dart ← Riverpod notifier (optional, for custom logic)
```

**Example — minimal new view:**
```dart
// lib/views/patch/patch_view.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatchView extends ConsumerWidget {
  const PatchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patch')),
      body: const Center(child: Text('Patcher goes here')),
    );
  }
}
```

**Then register in `lib/router/app_router.dart` (Step 8).**

---

### Step 8 — Add a new route with go_router

All routes are defined centrally in `lib/router/app_router.dart`.

**8a) Add a path constant** (in the `AppRoutes` class):
```dart
/// The main patcher page.
static const String patch = '/patch';
```

**8b) Register the route in the router:**

If the page should appear **inside the authenticated shell** (with sidebar):
```dart
// In the StatefulShellRoute.indexedStack list:
_buildBranch(talker, AppRoutes.patch, const PatchView()),
```

If the page should appear **outside the shell** (e.g. a fullscreen dialog):
```dart
// Outside StatefulShellRoute, at the same level as GoRoute(path: AppRoutes.login):
GoRoute(
  path: AppRoutes.patch,
  builder: (BuildContext context, GoRouterState state) {
    return const PatchView();
  },
),
```

**8c) Navigate:**
```dart
// From anywhere in the code (no BuildContext passing needed):
context.go(AppRoutes.patch);
// or
context.push(AppRoutes.patch);   // adds to the stack (back button works)
```

**8d) Sidebar navigation entry** (if shell route):
The sidebar is defined in `lib/views/shell/app_sidebar.dart`. Add a `_NavItem` to one of the grouped `_NavSection` lists there, with `branchIndex` matching the position of your branch in the router's `branches` list.

---

### Step 9 — Configure the Appwrite backend

If you use auth or database features:

1. Create a project on [appwrite.io](https://appwrite.io/).
2. Enter the endpoint and project ID in the config file:
   ```
   config/app_config.json   (or as named in the template)
   ```
3. For the web platform: add a web platform in Appwrite under *Platforms* with your domain (e.g. `localhost`).

---

### Step 10 — Run code generation

After any change to `@freezed` models or `@riverpod` providers:
```bash
dart run build_runner build --delete-conflicting-outputs
```

During development, it's more convenient to run continuously (regenerates on save):
```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

### Checklist: New app from template

- [ ] Package name globally replaced (`flutter_template_appwrite` → your name)
- [ ] `pubspec.yaml`: `name` and `description` adjusted
- [ ] `app_en.arb` and `app_de.arb`: `appTitle` set
- [ ] `assets/images/logo.png` replaced (1024×1024 px)
- [ ] `dart run flutter_launcher_icons` executed
- [ ] `AppTheme.defaultSeedColor` in `app_theme.dart` adjusted
- [ ] Default `AccentColor` entry in `accent_colors.dart` points to `AppTheme.defaultSeedColor`
- [ ] New views and routes created
- [ ] Appwrite credentials entered (if used)
- [ ] Generated `app_localizations*.dart` files added to `.gitignore`
- [ ] `dart run build_runner build` executed
- [ ] `flutter analyze` passes without errors

---

### Common pitfalls

#### Generated files in the l10n folder

`lib/l10n/app_localizations.dart`, `app_localizations_de.dart`, and `app_localizations_en.dart` are **auto-generated** and should not be manually edited or permanently checked into Git. Only `app_en.arb` and `app_de.arb` are real source files.

Recommendation — add to `.gitignore`:
```
lib/l10n/app_localizations.dart
lib/l10n/app_localizations_de.dart
lib/l10n/app_localizations_en.dart
```

#### Accent color: only change in one place

The default color value (`0xFF3D5AFE`) exists in the template at two locations (`app_theme.dart` and `accent_colors.dart`) — that's redundant. When customizing, **keep both places in sync** until the template consolidates this.

---

## License

[MIT](LICENSE)
