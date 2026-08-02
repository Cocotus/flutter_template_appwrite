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
- **Offline / intranet ready**: no Google Fonts or other runtime CDN fetches required (see ["Offline / intranet deployments"](#offline--intranet-deployments) below)
- **Optional premium licensing**: a one-time-purchase flow (Lemon Squeezy checkout → webhook → Appwrite `entitlements` table) with a ready-made `PremiumGate` widget — see [§7, "Premium licensing / monetization"](#7-premium-licensing--monetization-optional) below

The app itself is an *empty but complete* shell — login/register, home, settings, profile, about, help and a developer log view — meant to be cloned and extended.

**This README is the human setup and tutorial guide** — dev environment,
configuration, hosting, monetization, and the step-by-step tutorial for
turning this shell into your own app. The project also ships an
**`AGENTS.md`**, a separate rulebook whose only job is keeping AI coding
assistants (Claude, Cursor, Copilot, ...) consistent with this template's
architecture and conventions instead of drifting into ad-hoc patterns when
they work in this codebase — see [§9, "Coding conventions"](#9-coding-conventions) for how the two documents relate. You
never need to read `AGENTS.md` yourself unless you're curious; it changes
nothing about how you use the template as a human.

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
2. **Add a Web platform** to the project (Appwrite console → your project → *Overview* → *Add platform* → *Web*) and register the hostname you serve the app from — `localhost` for development. For production, if you're deploying via GitHub Pages ([§11](#11-hosting-on-github-pages)), that's `<owner>.github.io` — Appwrite platforms are registered by hostname only, without a path, so the `/<repo>/` subpath doesn't need to be (and can't be) included. The console also asks you to pick a **framework** (React, Next.js, etc.) for its quickstart snippet — pick **JavaScript** (vanilla); Flutter isn't in that list, the choice has no effect on the platform/CORS config you just set, and you'll be using the Flutter SDK instead of whatever snippet it shows next anyway. Keep this list to exactly the origins you actually serve the app from — `localhost` plus your production domain, nothing else, and no wildcard — since every registered platform is an origin Appwrite trusts for CORS/OAuth; check *Overview* → *Platforms* occasionally and remove anything you no longer use.
3. Make sure **Email/Password** authentication is enabled (*Auth* → *Settings*). Leave the other auth methods listed there (**Anonymous**, **Invites**, **Magic URL**, **Email OTP**, **Phone**, **JWT**, and any **OAuth2** provider) switched off — this template only calls the email/password session API, so none of them are used, and each one left on is unused attack surface for no benefit (Anonymous in particular lets any unauthenticated client create a session by itself).
4. **User settings: nothing to create.** Theme, language, accent, developer mode
   and the display name live in the user's **account preferences** — a JSON
   object Appwrite keeps on the account itself
   (`account.getPrefs()` / `account.updatePrefs()`). No table, no columns, no
   permissions, and adding a new setting never touches the Appwrite console.
   The limit is **64 kB per user**. See
   [`CloudSyncService`](lib/services/cloud_sync_service.dart).
5. **User data: create a Storage bucket** `user_data` (*Storage* → *Create
   bucket*), for everything the user *creates* — which is unbounded and will
   eventually outgrow 64 kB. See [`UserData`](lib/models/user_data.dart).
   - **Permissions:** enable **file security**, and grant **Create** to role
     **Users**. Do not grant bucket-level read/update/delete — the app sets the
     owner on each file it creates, so a user can only reach their own.
   - The app stores **one file per user whose file ID equals the Appwrite user
     ID**, so reading it back is a direct fetch with no query.
   - Allowed file extensions: add `json`, or leave the list empty to allow any.
   - Optional but recommended: turn **compression** on (the document is JSON and
     compresses well) and leave encryption at its default.
6. Create a **Database** (default ID used by this template: `app`) only if you
   want the optional features below. Settings and user data do not need one.
7. *(Optional, for remote logging)* create a table `logs` with columns `level` (String), `message` (String), `stackTrace` (String, size ~16384), `timestamp` (String), `userId` (String), and grant **Create** to role **Users**.
8. *(Optional, for premium licensing)* create a table `entitlements` — see [section 7, "Premium licensing / monetization"](#7-premium-licensing--monetization-optional) below for columns, permissions and the webhook function.
9. *(Optional, for calling external REST APIs from Flutter Web without hitting CORS)* deploy the `web-api-proxy` Appwrite Function — see [section 12, "Calling external REST APIs from Flutter Web (CORS proxy demo)"](#12-calling-external-rest-apis-from-flutter-web-cors-proxy-demo) below for setup and how it works.
10. **Password reset is already built in.** `account.createRecovery(...)`
   sends the reset email, and the app's own `/reset-password` route
   completes it via `account.updateRecovery(...)` — see
   [`ResetPasswordView`](lib/views/reset_password/reset_password_view.dart)
   and the ["Password reset"](#password-reset) section right below. You only need to set
   `PASSWORD_RECOVERY_URL` to match wherever you serve the app, and register
   that origin as a Web platform in the Appwrite console.

### Password reset

Fully implemented end to end — nothing left to build:

```
Login page "Forgot password?" ──▶ account.createRecovery(email, url: PASSWORD_RECOVERY_URL)
                                          │ Appwrite emails a link (valid 1 hour):
                                          │   PASSWORD_RECOVERY_URL?userId=...&secret=...
                                          ▼
                        App's own /reset-password route (ResetPasswordView)
                                          │ reads userId/secret from the URL,
                                          │ user enters a new password
                                          ▼
                        account.updateRecovery(userId, secret, password)
```

- The `/reset-password` route is registered outside the authenticated shell
  and is exempt from the router's auth guard (see `AppRouter`) — whoever
  clicks the emailed link may not have a session on this device at all.
- Missing or empty `userId`/`secret` (someone opening the bare URL, or an
  already-used link with the parameters stripped) shows an "invalid or
  expired link" message instead of a broken form.
- An expired or already-used link fails at submit time with an
  `AppwriteException` (code `401`), shown as the same "invalid or expired"
  message rather than a generic error.
- **Set `PASSWORD_RECOVERY_URL` to match wherever you actually serve the
  app**, e.g. `https://your-domain.com/reset-password` or
  `https://<user>.github.io/<repo>/reset-password` for a GitHub Pages
  deployment ([§11](#11-hosting-on-github-pages)) — and register that origin as a Web platform in the
  Appwrite console, or the email link will 400.

## 2. Configure the project

Copy the example config and fill in your values:

```sh
cp config/app_config.example.json config/app_config.json
```

> **Important:** the app only ever reads `config/app_config.json` — via
> `--dart-define-from-file=config/app_config.json` (see the launch configs in
> `.vscode/launch.json` and `lib/config/app_config.dart`). Editing
> `app_config.example.json` itself has no effect on a running app; always
> make your changes in the copy **without** `.example` in the name.
> `config/app_config.json` is **gitignored** — no secrets are ever committed.
>
> **Tip — no local checkout?** If you're only setting this up for a GitHub
> Pages deployment ([§11](#11-hosting-on-github-pages)) and haven't cloned the
> repo locally, you can create this file straight from the GitHub web UI:
> open the `config/` folder in your repo → **Add file → Create new file** →
> name it `app_config.json` → paste in the JSON below with your real values →
> commit directly to `main`. Committing it this way still tracks it in git
> normally — `.gitignore` only stops it from being picked up by a broad
> `git add`, it doesn't block an explicit add/commit of that exact path —
> and the GitHub Actions workflow needs it committed to build from it, since
> a gitignored file that was never committed simply doesn't exist in the
> checkout CI runs from.

```json
{
  "HAS_LOGIN": true,
  "HAS_PREMIUM": true,
  "DEMO_MODE_ALLOWED": false,

  "APPWRITE_ENDPOINT": "https://cloud.appwrite.io/v1",
  "APPWRITE_PROJECT_ID": "your-project-id",
  "APPWRITE_DATABASE_ID": "app",
  "APPWRITE_USER_DATA_BUCKET_ID": "user_data",
  "PASSWORD_RECOVERY_URL": "http://localhost:8080/reset-password",

  "APPWRITE_ENTITLEMENTS_TABLE_ID": "entitlements",
  "PREMIUM_CHECKOUT_URL": "",
  "BUY_ME_COFFEE_USERNAME": "",

  "REMOTE_LOGGING_ENABLED": false,
  "APPWRITE_LOGS_TABLE_ID": "logs"
}
```

The fields are grouped by which switch they depend on, not alphabetically — read a group's switch first; it tells you whether the rest of that group matters at all.

### Master switches

| Key | Default | Effect |
|---|---|---|
| `HAS_LOGIN` | `true` | `false` makes the entire *Appwrite connection* group below irrelevant: no Appwrite call is ever made, there is no login screen, and user settings/data live only in `shared_preferences` on the device. |
| `HAS_PREMIUM` | `true` | Picks one half of the *Premium / donate* group: `true` → the checkout fields apply; `false` → only `BUY_ME_COFFEE_USERNAME` applies. Mutually exclusive on purpose — a shipped app either sells something or asks for tips, never both. |
| `DEMO_MODE_ALLOWED` | `false` | Compile-time kill switch for demo mode (fake auth + in-memory data, no backend required). Only meaningful when `HAS_LOGIN` is `true`. Debug builds allow it regardless of this value. |

### Appwrite connection

Ignored entirely when `HAS_LOGIN` is `false` — leave these at their defaults in that case.

| Key | Default | Purpose |
|---|---|---|
| `APPWRITE_ENDPOINT` | Appwrite Cloud | Your Appwrite API endpoint (Cloud or self-hosted). |
| `APPWRITE_PROJECT_ID` | — | Your project ID from the Appwrite console. Required whenever `HAS_LOGIN` is `true` — the app shows a clear runtime error if left empty in that case. |
| `APPWRITE_DATABASE_ID` | `app` | The database holding this app's tables (logs, entitlements below). |
| `APPWRITE_USER_DATA_BUCKET_ID` | `user_data` | Storage bucket holding one user-data file per signed-in user. User *settings* need no bucket — they live in the Appwrite account-preferences object instead. |
| `PASSWORD_RECOVERY_URL` | `http://localhost:8080/reset-password` | URL Appwrite embeds in password-recovery e-mails — must point at this app's own `/reset-password` route (already implemented, see [§1, "Password reset"](#password-reset) section), just at whatever origin you actually serve the app from. The default here is the local-dev value; for a GitHub Pages deployment ([§11](#11-hosting-on-github-pages)) use `https://<owner>.github.io/<repo>/reset-password` instead. That origin must be registered as a Web platform in the Appwrite console, otherwise recovery fails with a 400 error. |

### Premium / donate

Which half applies depends on `HAS_PREMIUM` above ([§7, "Premium licensing / monetization"](#7-premium-licensing--monetization-optional) covers the premium feature in full).

| Key | Default | Purpose |
|---|---|---|
| `APPWRITE_ENTITLEMENTS_TABLE_ID` | `entitlements` | Table holding one premium-entitlement row per paying user, written by your payment webhook function. Used only when `HAS_PREMIUM` is `true`. |
| `PREMIUM_CHECKOUT_URL` | *(empty)* | Hosted checkout URL for your premium product (e.g. a Lemon Squeezy "buy" link). Not a secret — only the account e-mail and user ID are appended as query parameters. Empty disables the buy button and shows a configuration hint instead. |
| `BUY_ME_COFFEE_USERNAME` | *(empty)* | Your Buy Me a Coffee account slug (the part after `buymeacoffee.com/`). Used only when `HAS_PREMIUM` is `false`; empty hides the donate button entirely. |

### Remote logging

Independent of the switches above, but the table it writes to still lives in Appwrite, so it also needs `HAS_LOGIN: true` to actually reach anything.

| Key | Default | Purpose |
|---|---|---|
| `REMOTE_LOGGING_ENABLED` | `false` | Forwards error/fatal logs to `APPWRITE_LOGS_TABLE_ID` in addition to local logging, which always happens regardless of this flag. |
| `APPWRITE_LOGS_TABLE_ID` | `logs` | Table that receives remote log entries. Used only when `REMOTE_LOGGING_ENABLED` is `true`. |

## 3. Code generation & first run

Generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_localizations*.dart`) **are committed**, so the template builds out of the box — and they should stay committed in your app too. Never edit these files by hand; regenerate them instead. After changing models, providers or ARB files:

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

## 3b. Optional AI-assisted translation workflow (`arb_ai`)

If you want lightweight translation automation for a private repository, this template can use [`arb_ai`](https://pub.dev/packages/arb_ai).

### Cost / Gemini note

- This template config (`arb_ai.yaml`) is set up to use **Gemini** as provider.
- `arb_ai` provider support evolves; check the upstream package docs for the current provider list/version details: <https://pub.dev/packages/arb_ai>.
- Gemini is **not included** automatically: you must provide your own API key.
- Depending on your Google account/project, you may have a free tier, but usage limits and billing rules are controlled by Google and can change.

### Repo setup (already prepared here)

This repo includes `arb_ai.yaml` at the root, configured for:
- source ARB: `lib/l10n/app_en.arb`
- target languages: `de`, `pl`, `es`, `fr`, `th`
- provider: `gemini`
- key env var: `ARB_AI_API_KEY`

Model override is optional. This template leaves `model` unset so `arb_ai` can use its default. If you want to pin a specific Gemini model, set `model: ...` in `arb_ai.yaml` and verify availability in your account/project using the Gemini API model docs: <https://ai.google.dev/gemini-api/docs/models>.

### One-time local setup

```sh
dart pub global activate arb_ai
```

### Translate missing/changed keys

```sh
# preview only (no writes, no API calls)
dart pub global run arb_ai --dry-run

# generate/update target ARB files
ARB_AI_API_KEY=your_key_here dart pub global run arb_ai

# regenerate Flutter localization Dart files afterwards
flutter gen-l10n
```

### Suggested private-repo workflow

Prerequisite: add repository secret `ARB_AI_API_KEY`.

1. Developers add new keys in `lib/l10n/app_en.arb`.
2. After adding keys, run the manual workflow from GitHub **Actions** tab → **AI Translate ARB** → **Run workflow** (or run `arb_ai` locally).
3. If you used the workflow, review and merge the generated translation PR. If you ran locally, commit updated ARBs + generated `app_localizations*.dart`.
4. CI continues with `flutter analyze`.

This avoids monthly translation platforms and keeps all strings versioned in Git PRs.

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

### Release workflow (desktop builds)

`.github/workflows/release.yml` builds a **Linux and a Windows release in
parallel**, packages each as a self-contained ZIP, and creates a
**GitHub Release** with both ZIPs attached and auto-generated release notes
(derived from merged pull requests and commits since the previous tag).

**How to trigger:**
GitHub → **Actions** tab → **Release** → **Run workflow** → enter the version
number (e.g. `1.0.1`) → optionally check **"Mark as pre-release"** → click
**Run workflow**. No other setup is needed once the file exists in `main`.

**Artifact naming** is derived automatically from the repository name, so a
fork gets its own artifact names without editing the workflow:

- `<repo-name>-linux-v<version>.zip`
- `<repo-name>-windows-v<version>.zip`

**`config/app_config.json` must be committed** (or the
`--dart-define-from-file` flag on both build steps must be adapted). This is
the same requirement as for `gh-pages.yml` — see [§11](#11-hosting-on-github-pages) for the
same caveat and the two options for handling it.

**Permissions:** the workflow declares `permissions: contents: write` so the
publish job can create the release tag and attach files using the built-in
`GITHUB_TOKEN`. No personal access token is needed.

**Install scripts:** if your fork ships an `install.sh` (Linux) or
`install.bat` (Windows) helper, add a copy step immediately before the zip
command in the corresponding job — the workflow contains a comment pointing
here. The template omits those steps because they are app-specific.

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
2. **Function:** deploy `functions/lemonsqueezy-webhook/`. **Do not use the
   Appwrite console's Functions → Templates → "Payments with Lemon
   Squeezy"** instead — it's a different, unrelated implementation (its own
   `orders` collection schema, its own env var names, and it also creates
   checkout sessions server-side) that this app's
   `PremiumGate`/`isPremiumProvider`/`DemoLicenseService` don't read from.
   Deploy this repo's own function, not the marketplace one. Console setup:
   - **Create function** → manual/blank creation, not a template.
   - **Runtime:** Node.js, pick the **highest version offered**, not
     specifically 18.0 — "Node 18+" is a floor, not a target. The code is a
     plain ES module (`node:crypto` + the `node-appwrite` SDK) with nothing
     tying it to an old runtime.
   - **Entrypoint:** `src/main.js`.
   - **Execute access:** **Any** (public). This has to be public — Lemon
     Squeezy's webhook call carries no Appwrite session, only the
     `X-Signature` HMAC header that `main.js` itself verifies. Restricting
     execute access to Users/Guests would make Appwrite reject the webhook
     before the function ever runs; the signature check inside the function
     is the real security boundary, not Appwrite's execute permissions.
   - **Connect to Git:** point it at your repo, branch `main`, and set
     **Root directory** to `functions/lemonsqueezy-webhook` — this is a
     monorepo, the repo root has the Flutter app, not this function's
     `package.json`, so the deploy fails without it.
   - **Variables** (Settings → Environment variables, after creation): set
     `LS_SIGNING_SECRET` and `APPWRITE_API_KEY` (scopes: `rows.read`,
     `rows.write`, `users.read`).
   - After the first deploy, grab the function's public URL from the
     **Domains** tab for the Lemon Squeezy webhook config in step 3 below.
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
│   ├── lemonsqueezy-webhook/  # turns LS `order_created` webhooks into entitlement rows
│   └── web-api-proxy/        # server-side fetch so web can call external REST APIs (§12)
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
| `lib/l10n/app_en.arb`, `app_de.arb` | `appTitle` ([Step 3](#step-3--app-title-window-title--appbar-title)) — and see the warning below |

This template targets **Web, Windows and Linux only** (see [§1, "Dev environment setup"](#1-dev-environment-setup)) — there is no `android/`/`ios/` folder to rename.

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
> That is harmless if you retire the demo home ([Step 8](#step-8--add-a-new-route-with-go_router)), but fix or delete the
> key if you keep it.

Two more placeholders are **not** package-name occurrences, so the replace above will not catch them:

| File | What to change |
|---|---|
| `lib/views/shell/app_shell.dart` | `githubUrl` — `https://github.com/your-org/your-repo`, used by the header link *and* the About page |
| `lib/views/help/help_view.dart` | `editUrlBase` — the "Edit on GitHub" link of the Help page |
| `docs/help_en.md` / `help_de.md` | the "full README" link in the "Getting started with this template" chapter — plain Markdown text, not a Dart constant, so the global package-name replace above will not touch it |

Consider moving both into `lib/config/app_config.dart` so the repository URL exists in exactly one place.

---

### Step 3 — App title (window title / AppBar title)

The title that appears in the AppBar and the OS window title comes from two places:

1. **`lib/app.dart`** — where `MaterialApp.router` or `title:` is set.
2. **Translation files** (see [Step 5](#step-5--localization-adding-new-text-strings)) — the title comes from the localization key `appTitle`.

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

**Also rewrite: the README, the in-app help manual, and the About page text.**
The logo is the obvious thing to replace, but three text artifacts are just as
visible to a real user and are easy to leave untouched simply because nothing
forces you to look at them:

- **`README.md`** (this file) — ships describing the *template*, not your
  app. Once you have a real product, replace it with documentation of what
  your app actually does and how to configure it, and link back to this
  template's README/`AGENTS.md` for the generic Flutter/Appwrite mechanics
  instead of duplicating them — see how [`camex`](https://github.com/Cocotus/camex)
  (a real app built from this template) restructured its own README this way.
- **`docs/help_en.md` / `help_de.md`** — the in-app Help page renders these
  verbatim. Left alone, a real user opens Help and reads the template's own
  placeholder text ("This is the placeholder user manual of the starter
  template...") instead of anything about your app.
- **`aboutDescription`** in `app_en.arb` / `app_de.arb` — shown on the About
  page. Left alone, it reads "A starter template built with Riverpod 3,
  Freezed, go_router, Talker and Appwrite Cloud" instead of describing your
  app.

None of these three cause a build error or an analyzer warning if skipped —
which is exactly why they're easy to ship by accident. Add them to your own
checklist alongside the logo.

---

### Step 5 — Localization: adding new text strings

All user-facing text belongs **in the translation files**, never as string literals in widget code.

**Which files to edit?**
- `lib/l10n/app_en.arb` — English texts (the template file)
- `lib/l10n/app_de.arb` — German texts

**Never edit** the `.dart` files in the `l10n` folder! `app_localizations.dart`, `app_localizations_de.dart`, and `app_localizations_en.dart` are **auto-generated** and overwritten on every build. Keep them committed, though — see [§3, "Code generation & first run"](#3-code-generation--first-run).

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

**Then register in `lib/router/app_router.dart` ([Step 8](#step-8--add-a-new-route-with-go_router)).**

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
2. Enter the endpoint and project ID in the config file (see [§2, "Configure the project"](#2-configure-the-project)). The path is exact — it is what `--dart-define-from-file` and both launch configurations reference:
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

> Older guides pass `--delete-conflicting-outputs` here. With `build_runner` ≥ 2.15 the flag is obsolete and ignored — see [§3, "Code generation & first run"](#3-code-generation--first-run).

---

### Checklist: New app from template

- [ ] Package name globally replaced (`flutter_template_appwrite` → your name), including `windows/`, `linux/` and `LICENSE`
- [ ] `pubspec.yaml`: `name` and `description` adjusted
- [ ] `app_en.arb` and `app_de.arb`: `appTitle` set, `homeStepRename` fixed or removed
- [ ] `githubUrl` in `app_shell.dart` and `editUrlBase` in `help_view.dart` point at your repository
- [ ] The `https://github.com/your-org/your-repo#readme` link in `docs/help_en.md` / `help_de.md` points at your repository too
- [ ] `LICENSE` copyright line updated
- [ ] `assets/images/logo.png` replaced (1024×1024 px)
- [ ] `dart run flutter_launcher_icons` executed
- [ ] `README.md`, `docs/help_en.md`/`help_de.md` and `aboutDescription` rewritten for your app — none of these fail a build or `flutter analyze` if left as template placeholder text, so nothing else will catch it for you ([Step 4](#step-4--replace-the-logo--app-icon))
- [ ] `AppTheme.defaultSeedColorValue` in `app_theme.dart` adjusted (the single Dart source of truth)
- [ ] `theme_color` in `web/manifest.json` matches it — not covered by the const
- [ ] Default `AccentColor` entry in `accent_colors.dart` points to `AppTheme.defaultSeedColor`
- [ ] Demo home page replaced or consciously kept ([Step 8f](#step-8--add-a-new-route-with-go_router))
- [ ] New views and routes created; branch order consistent across all four locations ([Step 8e](#step-8--add-a-new-route-with-go_router))
- [ ] Appwrite credentials entered (if used)
- [ ] `.claude/launch.json` passes `--dart-define-from-file`, if you use it
- [ ] `dart run build_runner build` executed
- [ ] `flutter analyze` passes without errors
- [ ] Premium licensing removed or configured ([§7](#7-premium-licensing--monetization-optional)) — decide before shipping

---

### Common pitfalls

#### Generated files in the l10n folder

`lib/l10n/app_localizations*.dart` files are **auto-generated** and must not be edited by hand.
`lib/l10n/app_*.arb` files are the source files (with `app_en.arb` as the template/base locale).
Generated localization Dart files **are** checked into Git in this template. Regenerate them with `flutter gen-l10n` and commit the result after ARB changes.

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

#### Dead placeholder URLs

`https://github.com/your-org/your-repo` ships in three places: `lib/views/shell/app_shell.dart` (`githubUrl`, used by the header **and** the About page), `lib/views/help/help_view.dart` (`editUrlBase`), and as a plain Markdown link inside `docs/help_en.md` / `help_de.md`'s "Getting started with this template" chapter. All three are on the checklist above.

---

## 11. Hosting on GitHub Pages

`.github/workflows/gh-pages.yml` publishes a live, backend-free demo of the
template itself to GitHub Pages — useful for showing off a fork before
anyone sets up their own Appwrite project.

This template's own defaults are `HAS_LOGIN=true` / `HAS_PREMIUM=true` (see [§2](#2-configure-the-project)) — it ships expecting a real backend, unlike a freeware fork that sets
`HAS_LOGIN=false`. Rather than change those defaults, the workflow adds one
build-time flag on top: `--dart-define=DEMO_MODE_ALLOWED=true`. Visitors
land on the real login screen and flip its **Demo mode** switch, which
swaps in the in-memory fakes under `lib/services/demo/` — no Appwrite
project, no database, no server, and no secrets in the workflow. The
premium-checkout card still renders (`HAS_PREMIUM=true`), just with its buy
button disabled, since `PREMIUM_CHECKOUT_URL` is empty by default ([§7](#7-premium-licensing--monetization-optional)); the
donate button stays hidden for the same reason it's hidden in a normal
build — it only shows when `HAS_PREMIUM=false`.

### One-time repo setup

1. GitHub repo → **Settings → Pages → Build and deployment → Source** →
   select **GitHub Actions**. Nothing else to configure; the workflow
   provisions the rest.
2. Push to `main` (or run the workflow manually from the **Actions** tab →
   **Deploy web to GitHub Pages** → **Run workflow**).
3. The site appears at `https://<owner>.github.io/<repo>/`.

### What the workflow does, and why

- **`--base-href=/${{ github.event.repository.name }}/`** — Pages serves a
  project site from a `/<repo>/` subpath, not `/`; Flutter's web output
  needs to know that at build time. Derived from the repo name, so it keeps
  working automatically if you rename your fork.
- **`.nojekyll`** — GitHub Pages runs Jekyll by default, which ignores
  dotfile/underscore paths. Cheap insurance even though this build has none
  that are load-bearing.
- **`404.html` = a copy of `index.html`** — `main.dart` calls
  `usePathUrlStrategy()` for clean URLs (`/settings`, not `/#/settings`),
  which needs the host to fall back to `index.html` for unknown paths (see
  [§6](#6-build--release-web)). GitHub Pages has no rewrite rules, but it does serve a custom
  `404.html` for any unmatched path, so copying the built `index.html`
  there lets `go_router` take over client-side once the app has loaded.
- Uses `actions/upload-pages-artifact` + `actions/deploy-pages` (the
  current GitHub-native flow) instead of pushing to a `gh-pages` branch.

### Custom domain (optional)

Add a `web/CNAME` file containing the domain. Flutter copies everything
under `web/` verbatim into the build output, so it ships with every
deploy; point the domain's DNS at GitHub Pages as usual.

### If your fork is a freeware/public app (`HAS_LOGIN=false`)

Skip demo mode entirely: replace `--dart-define=DEMO_MODE_ALLOWED=true` in
the workflow with `--dart-define=HAS_LOGIN=false` (plus
`--dart-define=HAS_PREMIUM=false` and, if wanted,
`--dart-define=BUY_ME_COFFEE_USERNAME=yourslug` for the donate button) — the
router then skips the login page entirely, exactly like the demo-free setup
described in `morpatcher_flutter`'s README, a public app built from this
template.

### If you want the real backend on the public site instead

> **Trap:** editing `config/app_config.json` by itself has **no effect** on
> a GitHub Pages deploy. The build step in `.github/workflows/gh-pages.yml`
> passes its own hardcoded `--dart-define=DEMO_MODE_ALLOWED=true` and never
> reads that file at all — so changing `HAS_LOGIN`, your Appwrite project
> ID, or anything else in the JSON silently does nothing until the workflow
> itself is edited to actually pick those values up.

Two ways to fix the workflow, depending on whether the file has secrets in it:

- **If `config/app_config.json` is committed to your repo and contains no
  secrets** (true for every value this template ships — see the note on
  [§2](#2-configure-the-project)'s gitignore tip — since API keys and
  signing secrets only ever live in Appwrite Function environment
  variables, never in this file): simplest fix is to replace
  `--dart-define=DEMO_MODE_ALLOWED=true` in the `flutter build web` step
  with `--dart-define-from-file=config/app_config.json`, so the workflow
  builds from the exact same file you already maintain locally.
- **If you'd rather not commit the file at all** (e.g. this is still the
  public template showcase, not your own product fork): drop
  `--dart-define=DEMO_MODE_ALLOWED=true` and add the individual
  `--dart-define`s from [§2](#2-configure-the-project) sourced from
  repository secrets/variables instead. Registering the Pages origin as a
  Web platform in Appwrite is required either way.

---

## 12. Calling external REST APIs from Flutter Web (CORS proxy demo)

The Home page ships with a third demo card, **"External REST API"**, right
next to the getting-started steps and the base-widgets demo. It fetches
`example.com` and shows the page title it finds. This section explains why
it exists, what it's teaching, and how to point the same pattern at your own
API — written for a developer who has never hit this problem before.

### The problem this demo exists to show you

Run the app on desktop or mobile (`flutter run -d windows`, `-d linux`,
`-d chrome` isn't one of these — see below) and the card just works,
immediately, no setup. Build for the web instead and it shows a "this needs
a small setup step" message. That's not a bug in this template — it's a
browser security rule called **CORS** (Cross-Origin Resource Sharing), and
almost every Flutter Web app that talks to a third-party REST API or scrapes
a plain web page runs into it sooner or later.

A browser refuses to hand a web page the response of a cross-origin request
unless the **server being called** sends back permission headers saying
"yes, this origin may read my response." Most REST APIs (and virtually all
plain web pages, including `example.com`) send no such headers. Nothing
about *this app's* code can change that — CORS is enforced by the browser
itself, identically no matter which host serves the built web app. Desktop
and mobile builds never hit this at all: there is no browser sandbox
involved, so they can call `example.com` directly, exactly like `curl`
would — which is exactly what `WebApiProxyService` does on those platforms.

### The fix: a tiny server you control in the middle

```
Flutter Web ──(blocked by CORS)──✗──▶ example.com / your-api.com / ...
Flutter Web ──createExecution()───▶ Appwrite Function "web-api-proxy" ──▶ example.com / ...
                                       (runs server-side; not a browser;
                                        CORS does not apply to it at all)
```

`functions/web-api-proxy/` is an Appwrite Function — a small piece of
server-side code, deployed separately from the Flutter app, that fetches a
URL on the app's behalf and hands the response straight back. Because it
runs on Appwrite's servers and not inside a browser, it can call anything
exactly like `curl` or the desktop build already can.

The Flutter app calls this function using the Appwrite SDK's
`Functions.createExecution(...)` (see `WebApiProxyService`) — a normal
request to Appwrite's own REST API, the same one your login already uses.
That's why the function itself needs **no CORS configuration of any kind**:
the browser's permission check happens against Appwrite's API, and that's
already allowed for your app's origin the moment you register it as a "Web"
platform in the Appwrite console — the same step your login flow already
requires, if this build has login enabled.

### Setup (~5 minutes)

1. **Appwrite Console → Functions → Create function.**
   - Runtime: **Node.js 18+** (the function uses the built-in `fetch`, no
     dependencies needed).
   - Entrypoint: `src/main.js`.
   - Deploy the `functions/web-api-proxy/` folder from this repo
     (drag-and-drop upload, connect a Git repo, or the Appwrite CLI —
     whichever the console offers you).
2. **Permissions:** set "Execute Access" to **Any** (public/unauthenticated).
3. **Copy the function's ID** (shown in the console, right under its name)
   into `WEB_API_PROXY_FUNCTION_ID` in `config/app_config.json`:
   ```json
   "WEB_API_PROXY_FUNCTION_ID": "68f0a1b2c3d4e5f6a7b8"
   ```
4. Rebuild for web (`flutter build web --release`, or `flutter run -d
   chrome` during development). The demo card now fetches through the
   function instead of showing the setup hint.

### Test it without the Flutter app

```sh
curl -X POST "https://cloud.appwrite.io/v1/functions/<FUNCTION_ID>/executions" \
  -H "X-Appwrite-Project: <YOUR_PROJECT_ID>" \
  -H "Content-Type: application/json" \
  -d '{"path": "/?url=https%3A%2F%2Fexample.com", "method": "GET"}'
```

A response body containing `example.com`'s HTML (rather than an Appwrite
error) means the function is deployed, reachable, and correctly allowlisting
the host you asked it to fetch.

### Adapting this to your own API

This demo is deliberately built as a *pattern*, not a one-off — swap it for
your real API in three small steps:

1. **`lib/services/web_api_proxy_service.dart`:** change `demoTarget` to
   your API's URL, and change how `fetchDemoPageTitle` parses the response
   (e.g. `jsonDecode` for a JSON API, instead of the `<title>` regex used
   for scraping a plain HTML page).
2. **`functions/web-api-proxy/src/main.js`:** add your API's hostname to the
   `ALLOWED_HOSTS` environment variable (Appwrite console → this function →
   Settings → Environment variables) — the function itself never needs
   further changes, since it only forwards the response, never interprets
   it.
3. Rename the card/service/controller to match your feature if you're
   keeping it around long-term (`homeApiDemo*` ARB keys, `WebApiProxyService`,
   `WebApiDemoController`) — or delete all three (the function, the
   service+controller, and the Home page card) if you only needed this to
   learn the pattern.

**Security note:** never remove the `ALLOWED_HOSTS` allowlist check in the
function, and never widen it to "allow everything." Without it, the
function would fetch *any* URL a caller passed it — an open proxy anyone on
the internet could use to make requests appear to come from your Appwrite
project (this class of bug is called SSRF: Server-Side Request Forgery).

---

## License

[MIT](LICENSE)
