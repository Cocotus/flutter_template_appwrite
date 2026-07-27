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
- **Optional premium licensing**: a one-time-purchase flow (Lemon Squeezy checkout → webhook → Appwrite `entitlements` table) with a ready-made `PremiumGate` widget — see the monetization section below

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
   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev libsecret-1-dev libwebkit2gtk-4.1-dev
   ```
   `libsecret-1-dev` is required by `flutter_secure_storage`; at runtime a keyring service (e.g. `gnome-keyring`) must be available. `libwebkit2gtk-4.1-dev` is required by `flutter build linux` — note the **4.1**, not 4.0, on Ubuntu 24.04 (Noble). This list matches the one the Linux CI job installs (`.github/workflows/ci.yml`).

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
7. *(Optional, for premium licensing)* create a table `entitlements` — see section 7 "Premium licensing / monetization" below for columns, permissions and the webhook function.
8. **Password reset (TODO for your app):** this template calls `account.createRecovery(...)` to send the reset email. The page that *completes* the reset (reads the `userId`/`secret` URL parameters and calls `account.updateRecovery(...)`) is **not implemented** in this template — you must add it. The `PASSWORD_RECOVERY_URL` in the config is a placeholder.

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
  "APPWRITE_ENTITLEMENTS_TABLE_ID": "entitlements",
  "PREMIUM_CHECKOUT_URL": "",
  "PASSWORD_RECOVERY_URL": "http://localhost:8080/reset-password",
  "REMOTE_LOGGING_ENABLED": false,
  "DEMO_MODE_ALLOWED": false
}
```

`APPWRITE_ENTITLEMENTS_TABLE_ID` and `PREMIUM_CHECKOUT_URL` are only needed if you use the premium licensing feature (section 7); leave `PREMIUM_CHECKOUT_URL` empty to keep the buy button disabled.

`config/app_config.json` is **gitignored** — no secrets are ever committed. The values are injected at build time via `--dart-define-from-file` (see `lib/config/app_config.dart`).

## 3. Code generation & first run

Generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_localizations*.dart`) **are committed**, so the template builds out of the box — and they should stay committed in your app too. The CI `analyze` job does not run `flutter gen-l10n`, so ignoring the localization output breaks CI. Never edit these files by hand; regenerate them instead. After changing models, providers or ARB files:

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

VS Code users: ready-made launch configurations are in `.vscode/launch.json`. Claude Code users: `.claude/launch.json` serves the same purpose for the in-app browser preview — make sure any configuration you add there also passes `--dart-define-from-file=config/app_config.json`, otherwise the app starts silently on the built-in fallback configuration.

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
flutter_template_appwrite/
├── lib/
│   ├── main.dart          # bootstrap: URL strategy, error hooks → Talker, ProviderScope
│   ├── app.dart            # MaterialApp.router: theme, locale, localization delegates
│   ├── config/             # AppConfig (--dart-define), no secrets in code
│   ├── models/              # Freezed models: UserSettings, RemoteLogEntry, Entitlement
│   ├── services/            # shared/cross-cutting logic as keepAlive providers:
│   │                        #   Appwrite client, Auth, Database (TablesDB), License,
│   │                        #   Logger, RemoteLogSink, Preferences, SecureStorage,
│   │                        #   UserSettings, Theme, Locale, AppVersion
│   │   └── demo/            # in-memory fakes backing demo mode (no Appwrite needed)
│   ├── router/              # go_router: auth guard + StatefulShellRoute shell
│   ├── views/               # one folder per feature: view (+ paired controller)
│   │   ├── login/           #   login_view.dart + login_controller.dart
│   │   ├── shell/           #   app_shell (page header) + app_sidebar (dark rail)
│   │   ├── home/            #   home_view.dart + home_controller.dart + home_state.dart
│   │   └── settings/ profile/ about/ help/ logs/ splash/
│   ├── widgets/             # reusable widgets, shared across views
│   │   ├── buttons/         #   AppPrimaryButton / AppSecondaryButton
│   │   ├── forms/           #   AppTextField, AppPasswordField, AppSwitchTile, AppDropdownField
│   │   └── (root)           #   section_header, markdown_page, premium_gate, snackbar, avatar, ...
│   ├── theme/                # AppTheme (single source for all styling) + accent_colors
│   ├── utils/                # redactEmail, mapAuthError
│   └── l10n/                 # app_en.arb, app_de.arb (+ generated localizations)
├── docs/                    # Markdown shown in-app by the Help page (docs/help_<locale>.md)
├── functions/               # Appwrite Functions deployed separately from the Flutter app
│   └── lemonsqueezy-webhook/  # turns LS `order_created` webhooks into entitlement rows
└── config/                  # app_config.example.json (template) + your gitignored app_config.json
```

**Rule of thumb:** a *controller* holds the logic of **one view**; a *service* holds logic **shared by many views** (DB, theme, config, logging) and is a keepAlive singleton provider.

## 9. Coding conventions

> This template intentionally favors explicit, verbose, beginner-friendly Dart over concise expert-style code, follows the official Dart naming guidelines, and documents all public APIs, so an average Flutter developer can read, modify and learn from it without prior Riverpod/Freezed experience.

Hard rules (enforced across the whole codebase):

- **No `StatefulWidget` / `ConsumerStatefulWidget`.** `StatelessWidget` only for logic-free UI; anything with state uses `ConsumerWidget` or `HookConsumerWidget` plus a paired `@riverpod` controller.
- **`TextEditingController`s live in the view** via `useTextEditingController()` (auto-disposed by hooks); controllers receive **plain Strings only** and **never a `BuildContext`**. UI-only flags (password visibility toggle, checkbox state) stay in the view as hooks; domain logic goes into the controller.
- View logic lives in **controllers**, shared logic in **services**; controllers call services, **never the raw Appwrite client** directly — that keeps the service layer the single place that talks to Appwrite.
- Long-lived services are `@Riverpod(keepAlive: true)`; everything else auto-disposes (Riverpod 3 default).
- All models are **`@freezed`** with `fromJson`/`toJson`.
- All async work is exposed as **`AsyncValue`**; views render it with the shared loading/error/empty widgets and react to results via `ref.listen` (snackbars, navigation).
- **All logging via Talker** (`LoggerService`) — no `print`/`debugPrint`; log exceptions once, where they are handled, with context; **never log secrets or PII** (redact emails etc.).
- **No cascade operators (`..`)** and no multi-step arrow (`=>`) method bodies — resolve them into explicit statements on a named `final` variable instead. Readability over brevity throughout.
- **Style:** explicit types, block bodies over multi-step `=>`, `if`/`else` over nested ternaries, named intermediate variables over long call chains, `_buildXxx()` helpers for big widget trees, consistent newline placement (`trailing commas + dartfmt`).
- **Reusable UI elements live in `lib/widgets/`** (buttons, form fields, section headers, ...) — never restyle a raw Material widget inline in a view; add a wrapper there instead so the look stays consistent app-wide. Colors/typography/radii themselves stay centralized in `lib/theme/app_theme.dart`.

### Documented deviations from common older guides

- **TablesDB instead of the legacy `Databases` API** — Appwrite 1.9+ presents databases → *tables* → *rows*; the older collections/documents API still exists but is marked legacy.
- **`riverpod_lint` runs as a native analyzer plugin** (3.1+): configured via the `plugins:` block in `analysis_options.yaml`; findings appear in `flutter analyze`. `custom_lint` is no longer needed.
- **No `runZonedGuarded`** around `runApp`: `PlatformDispatcher.instance.onError` already catches uncaught async errors on all targets and avoids zone-mismatch issues (current Flutter guidance).
- **Appwrite session persistence is SDK-managed** (cookies/internal store). `flutter_secure_storage` is included as the sanctioned place for any *future* secrets (`SecureStorageService`), not for session tokens.

### Which document wins

Three files describe how to work in this repository. When they disagree:

1. **`AGENTS.md`** — the authoritative rulebook for humans and coding agents alike. It expands the rules above with rationale and worked examples.
2. **This README** — setup, tutorial and the customization checklist.
3. **`AIInstructions.md`** — the original prompt this template was generated from, kept for provenance. It is *not* maintained against the current code and contradicts `AGENTS.md` in places (most visibly on testing). Treat it as history, not as instructions.

---

## 10. Tutorial: Building your own app from this template

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
| `windows/runner/Runner.rc` | `ProductName`, `FileDescription`, `InternalName`, `OriginalFilename` |
| `windows/CMakeLists.txt` | `project()` and `BINARY_NAME` |
| `windows/runner/main.cpp` | the window title passed to `CreateAndShow` |
| `linux/CMakeLists.txt` | `BINARY_NAME` **and** `APPLICATION_ID` |
| `linux/runner/my_application.cc` | both `gtk_*_set_title` calls |
| `web/index.html` | `<title>` |
| `web/manifest.json` | `"name"` and `"short_name"` |
| `LICENSE` | the copyright line |
| `lib/l10n/app_en.arb`, `app_de.arb` | `appTitle` (Step 3) — and see the warning below |

This template targets **Web, Windows and Linux only** (see section 1) — there is no `android/`/`ios/` folder to rename.

**Do this with a scripted replace, not by hand.** `lib/` alone contains 161 occurrences across 43 files:

```bash
# from the project root — bash / git-bash / WSL
grep -rl flutter_template_appwrite . --exclude-dir=.git \
  | xargs sed -i 's/flutter_template_appwrite/my_tool/g'
flutter pub get
```

```powershell
# PowerShell equivalent
Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  ForEach-Object {
    $c = Get-Content $_.FullName -Raw
    if ($c -match 'flutter_template_appwrite') {
      $c -replace 'flutter_template_appwrite', 'my_tool' | Set-Content $_.FullName -Encoding utf8
    }
  }
flutter pub get
```

> ⚠️ **The global replace also rewrites one user-visible string.** The ARB key
> `homeStepRename` in `lib/l10n/app_en.arb` / `app_de.arb` contains the literal
> `flutter_template_appwrite` inside a sentence rendered on the demo home page.
> After the replace it will read "find & replace my_tool with your app name".
> That is harmless if you retire the demo home (Step 8), but fix or delete the
> key if you keep it.

Two more placeholders are **not** package-name occurrences, so the replace above will not catch them:

| File | What to change |
|---|---|
| `lib/views/shell/app_shell.dart` | `githubUrl` — `https://github.com/your-org/your-repo`, used by the header link *and* the About page |
| `lib/views/help/help_view.dart` | `editUrlBase` — the "Edit on GitHub" link of the Help page |

Consider moving both into `lib/config/app_config.dart` so the repository URL exists in exactly one place.

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

**Never edit** the `.dart` files in the `l10n` folder! `app_localizations.dart`, `app_localizations_de.dart`, and `app_localizations_en.dart` are **auto-generated** and overwritten on every build. Keep them committed, though — see section 3.

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
// Import from your own package — the synthetic `package:flutter_gen/...`
// import no longer exists in current Flutter versions.
import 'package:my_tool/l10n/app_localizations.dart';

// Inside a build() method:
final AppLocalizations l10n = AppLocalizations.of(context)!;
Text(l10n.patchButtonLabel)
```

---

### Step 6 — Change the default accent color

The template starts with a blue shade as the default color. The primary place to change is:

```dart
// lib/theme/app_theme.dart
static const int defaultSeedColorValue = 0xFF3D5AFE; // ← your color here
```

That is the **only** Dart edit. `defaultSeedColor` derives from it, `accent_colors.dart` references `AppTheme.defaultSeedColor`, and `user_settings.dart` uses `@Default(AppTheme.defaultSeedColorValue)` — so the theme, the palette in Settings and the persisted per-user default can no longer drift apart. Changing this one line derives the entire Material 3 color scheme (light, dark, sidebar, buttons, etc.).

Run `dart run build_runner build` afterwards: the model default is baked into `user_settings.freezed.dart`, so the new value only reaches the generated code once you regenerate.

> The value is exposed as an `int` *and* a `Color` on purpose. A Freezed
> `@Default(...)` needs a compile-time constant of the field's type, and
> `accentColorValue` is stored as an ARGB `int` so it serializes cleanly to
> Appwrite — an annotation cannot reference a `Color`.

**One place is outside Dart and needs a second edit:** `web/manifest.json` sets the browser theme color for the installed PWA and the mobile address bar. It is JSON, so it cannot reference the const:

```jsonc
// web/manifest.json
"background_color": "#1A1C2E",   // tracks AppTheme._brandNavyBase
"theme_color": "#3D5AFE"         // ← keep in sync with defaultSeedColorValue
```

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

**8e) Keep all four branch-order locations in sync.** Branch order is positional and there is no compile-time check — get it wrong and the app renders the wrong header with no error anywhere:

1. `AppRoutes` — the path constant (8a)
2. `app_router.dart` — the position in the `branches:` list (8b)
3. `app_sidebar.dart` — `_NavItem.branchIndex` (8d)
4. **`lib/views/shell/app_shell.dart`** — the hardcoded, index-positional `titles` list used for the page header

**8f) Replacing the demo home page.** `lib/views/home/` is a getting-started page plus a live widget demo. Every real app has to retire it; pick one:

- **Replace it** — register your own view at `AppRoutes.home` (branch 0) and delete `lib/views/home/`. Also remove the now-unused `homeStep*` / `homeIntro` ARB keys. Keep the widget demo open in a diff while you build your first page — it is the best reference for the base widgets in `lib/widgets/`.
- **Keep it and add a branch** — fine for a dashboard-style app where the landing page stays generic.

---

### Step 9 — Configure the Appwrite backend

If you use auth or database features:

1. Create a project on [appwrite.io](https://appwrite.io/).
2. Enter the endpoint and project ID in the config file (see section 2). The path is exact — it is what `--dart-define-from-file` and both launch configurations reference:
   ```
   config/app_config.json
   ```
3. For the web platform: add a web platform in Appwrite under *Platforms* with your domain (e.g. `localhost`).

---

### Step 10 — Run code generation

After any change to `@freezed` models or `@riverpod` providers:
```bash
dart run build_runner build
```

During development, it's more convenient to run continuously (regenerates on save):
```bash
dart run build_runner watch
```

> Older guides pass `--delete-conflicting-outputs` here. With `build_runner` ≥ 2.15 the flag is obsolete and ignored — see section 3.

---

### Checklist: New app from template

- [ ] Package name globally replaced (`flutter_template_appwrite` → your name), including `windows/`, `linux/` and `LICENSE`
- [ ] `pubspec.yaml`: `name` and `description` adjusted
- [ ] `app_en.arb` and `app_de.arb`: `appTitle` set, `homeStepRename` fixed or removed
- [ ] `githubUrl` in `app_shell.dart` and `editUrlBase` in `help_view.dart` point at your repository
- [ ] `LICENSE` copyright line updated
- [ ] `assets/images/logo.png` replaced (1024×1024 px)
- [ ] `dart run flutter_launcher_icons` executed
- [ ] `AppTheme.defaultSeedColorValue` in `app_theme.dart` adjusted (the single Dart source of truth)
- [ ] `theme_color` in `web/manifest.json` matches it — not covered by the const
- [ ] Default `AccentColor` entry in `accent_colors.dart` points to `AppTheme.defaultSeedColor`
- [ ] Demo home page replaced or consciously kept (Step 8f)
- [ ] New views and routes created; branch order consistent across all four locations (Step 8e)
- [ ] Appwrite credentials entered (if used)
- [ ] `.claude/launch.json` passes `--dart-define-from-file`, if you use it
- [ ] `dart run build_runner build` executed
- [ ] `flutter analyze` passes without errors
- [ ] Premium licensing removed or configured (section 7) — decide before shipping

---

### Common pitfalls

#### Generated files in the l10n folder

`lib/l10n/app_localizations.dart`, `app_localizations_de.dart`, and `app_localizations_en.dart` are **auto-generated** and must not be edited by hand — only `app_en.arb` and `app_de.arb` are real source files. They **are** checked into Git, deliberately: the CI `analyze` job does not run `flutter gen-l10n`, so a build from a clean checkout needs them present. Regenerate with `flutter gen-l10n` and commit the result.

#### Accent color: one Dart const, plus the web manifest

The Dart side is consolidated: `AppTheme.defaultSeedColorValue` is the one literal, and everything else derives from it.

| File | Occurrence | Needs editing? |
|---|---|---|
| `lib/theme/app_theme.dart` | `defaultSeedColorValue` | **yes — this is the source of truth** |
| `lib/theme/app_theme.dart` | `defaultSeedColor` | no, derived |
| `lib/theme/accent_colors.dart` | first `AccentColor` entry | no, references `defaultSeedColor` |
| `lib/models/user_settings.dart` | `@Default(AppTheme.defaultSeedColorValue)` | no, references the const |
| `web/manifest.json` | `theme_color` | **yes — JSON, cannot reference Dart** |

Two things still bite:

- **`web/manifest.json` is not covered by the const** and is the one place people forget. The PWA then installs with the old brand color while the app itself uses the new one.
- **Regenerate after changing it.** `user_settings.freezed.dart` bakes the default in at generation time, so the value only takes effect in the model once `dart run build_runner build` has run.

#### Two dead placeholder URLs

`https://github.com/your-org/your-repo` ships in `lib/views/shell/app_shell.dart` (`githubUrl`, used by the header **and** the About page) and `lib/views/help/help_view.dart` (`editUrlBase`). Both are on the checklist above.

---

## License

[MIT](LICENSE)
