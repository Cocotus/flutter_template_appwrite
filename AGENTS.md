# AGENTS.md — Conventions for Flutter Projects (Riverpod + Freezed)

*(Also readable as `CLAUDE.md` — same content, for tools that look for that
filename instead.)*

General instructions for AI assistants working on **any** Flutter project of
this kind. This is the **common denominator** across similar apps — not tied
to a specific backend or feature set. Copy this file into the root of a
Flutter project and extend it with project-specific notes (backend, data
model, deployment) in its own section, or in a separate `AGENTS.md`.

**If a concrete project rule conflicts with a rule here, the project's own
documents win.** Otherwise everything below applies.

**Documentation language: English.** This file, all code comments and
`///` doc comments, and the localization base locale (§11) are written in
English — regardless of which language the assistant and user converse in
during a session. See §1 and §11 for specifics.

---

## Table of contents

- [Scope — recommendations, binding for new code](#scope--recommendations-binding-for-new-code)
- [0. Guiding principle](#0-guiding-principle)
- [1. Code style (applies to ALL code)](#1-code-style-applies-to-all-code)
- [2. Architecture — View / Controller / Service / Model](#2-architecture--view--controller--service--model)
- [3. State management — Riverpod (code-gen) + Hooks](#3-state-management--riverpod-code-gen--hooks)
- [4. Widgets & reuse](#4-widgets--reuse)
- [5. Theming](#5-theming)
- [6. Models](#6-models)
- [7. Navigation](#7-navigation)
- [8. Testing](#8-testing)
- [9. Logging](#9-logging)
- [10. Config & secrets](#10-config--secrets)
- [11. Localization](#11-localization)
- [12. Hooks & reactive pitfalls](#12-hooks--reactive-pitfalls)
- [13. Workflow expectations for the assistant](#13-workflow-expectations-for-the-assistant)
- [14. Persistence — user settings vs. user data](#14-persistence--user-settings-vs-user-data)
- [15. Web CORS proxy demo (external REST APIs)](#15-web-cors-proxy-demo-external-rest-apis)
- [Short DON'T list](#short-dont-list)

---

## Scope — recommendations, binding for new code

The rules below are **recommendations / best practices** and are **binding
primarily for new additions** (a new controller, a new view, a new widget, a
new service). Concretely:

- **New code MUST comply.** Example: a new view/controller is written
  **without `StatefulWidget`/`ConsumerStatefulWidget`** (§3), without cascades
  (§1), using the intended layers and names.
- **Existing code stays as-is — flagged, not silently rewritten.** If you
  work on existing files that violate these rules (e.g. an existing
  `StatefulWidget`, a cascade, a `TextEditingController` inside a Riverpod
  controller), **flag it with a short note**, but do **not** refactor it
  unprompted. A migration only happens on explicit instruction and within a
  tightly scoped boundary.
- **Rule of thumb:** new code follows these rules cleanly; existing code is
  respected and merely flagged. This lets the project grow into the
  conventions incrementally, without unplanned mass refactors tearing up
  existing code.

---

## 0. Guiding principle

Code in these projects should be **readable, understandable, and extensible**
by an **advanced Flutter developer** — someone who has solid Dart/Flutter
fundamentals and has shipped apps before, but is *not* an expert and *not*
always current on the latest language shorthand.

> **Prefer explicit, verbose, "boring" code over clever/terse code.
> Readability beats brevity — every time.**

If you notice you're writing something that requires deep Dart knowledge to
understand, rewrite it the plain way and add a short comment.

---

## 1. Code style (applies to ALL code)

### DO — explicit, readable

- **Explicit types** on variables, fields, parameters, return values
  (`final String email = ...;`, `Future<void> login() async { ... }`). Don't
  rely on `var`/type inference when a spelled-out type reads more clearly.
- **Full block bodies** with `{ ... }` and `return` — no multi-step `=>`.
- **Step-by-step logic** with clearly named intermediate variables instead of
  chaining everything into a single expression.
- Clear **`if / else`** instead of ternary chains, wherever it improves
  readability.
- Short comments that explain **why**, not what.
- Break `build` methods into small, named **`Widget _buildXxx()`** helpers so
  the tree stays easy to follow.
- Descriptive, spelled-out names (`isPasswordVisible`, not `pwv`).
- Explicit **`try / catch`** that clearly logs and returns/rethrows.

### AVOID — too clever / expert-only

- ❌ **Arrow bodies (`=>`) for anything non-trivial.** A one-line `=>` is fine
  only for a genuinely trivial getter/callback
  (`onPressed: () => controller.submit()`). Never write multi-step logic or
  whole methods as an arrow expression.
- ❌ **Cascade operators (`..`).** They return the *receiver object* instead
  of the method's result, which confuses non-experts. **Resolve every cascade
  into explicit statements on a named `final` variable** (example below).
- ❌ Long single-line method chains (`list.where(...).map(...).toList()..sort()`).
  Break them into steps with named variables.
- ❌ **Spread operators (`...`) and collection `if`/`for` in widget lists**
  (`if (cond) ...<Widget>[a, b]`, `for (final x in xs) ...buildRow(x)`).
  Instead, build a **`final List<Widget> children = [...]` variable
  explicitly** via an `if`/`for` block and `.add()`/`.addAll()`, and pass it
  to `children:` (example below). Same applies to map/set merges
  (`<K,V>{...other, 'k': v}`) — copy via a loop over `.entries` instead.
- ❌ Nested ternaries, dense collection `if`/`for` in large widget trees.
- ❌ Excessive `extension`s, records, pattern matching, or brand-new syntax
  used purely for cleverness. Only use a modern feature if it genuinely makes
  the code *simpler* for non-experts, and comment it in case it might be
  unfamiliar.
- ❌ Deeply nested anonymous inline functions.

### Example — block body instead of arrow

```dart
// ❌ Too terse / expert style:
Future<void> login(String e, String p) async =>
    state = await AsyncValue.guard(() => _auth.login(email: e, password: p));

// ✅ Explicit, documented:
/// Logs the user in with [email] and [password].
Future<void> login({required String email, required String password}) async {
  state = const AsyncValue<void>.loading();
  try {
    await _auth.login(email: email, password: password);
    state = const AsyncValue<void>.data(null);
  } catch (error, stackTrace) {
    state = AsyncValue<void>.error(error, stackTrace);
  }
}
```

### Example — resolving a cascade

```dart
// ❌ Cascade (`..` returns the object, not the method's result):
ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(snackBar);

// ✅ Explicit statements on a named variable:
final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
messenger.hideCurrentSnackBar();
messenger.showSnackBar(snackBar);
```

### Example — resolving a spread in a widget list

```dart
// ❌ Spread + collection-if (unclear what ends up in the list):
return Column(
  children: <Widget>[
    const Icon(Icons.info),
    if (message != null) ...<Widget>[
      const SizedBox(height: 8),
      Text(message),
    ],
  ],
);

// ✅ Explicit list, built step by step:
final List<Widget> children = <Widget>[
  const Icon(Icons.info),
];
if (message != null) {
  children.add(const SizedBox(height: 8));
  children.add(Text(message));
}
return Column(children: children);
```

### Naming & documentation (official Dart style)

- **Every public API** (public class/method/function/field, every provider,
  every top-level member) has a `///` doc comment starting with a one-sentence
  summary.
- **Private members (`_name`)** don't need a doc comment, but add a short
  `//` where the intent isn't obvious.
- **Write all comments and doc comments in English** — this is the
  documentation language for code, independent of the language used in
  conversation with the assistant (see the note at the top of this file).
- `UpperCamelCase` for types; `lowerCamelCase` for members & constants (NOT
  `SCREAMING_CAPS`); `lowercase_with_underscores` for files/folders.
- Booleans read as positive statements (`isLoading`, `hasError`, `isDarkMode`).
- Prefer `final` over `var` when the value doesn't change.
- Member order: constructors → public fields → public methods → private
  helpers. One primary public class per file, where sensible.

---

## 2. Architecture — View / Controller / Service / Model

### File naming convention

**Dart files MUST be named after one of their public classes.** A file contains
exactly one public class, which is the filename in `snake_case`. Examples:

- Class `AppPrimaryButton` → file `app_primary_button.dart`
- Class `UserSettings` → file `user_settings.dart`
- Class `LoginController` → file `login_controller.dart`

**Generated files** (`.freezed.dart`, `.g.dart`, `.config.dart`) are excluded
from this rule — they follow the source file's name automatically via `part`
statements.

**Models (data/entity classes) belong in `lib/models/`** — even if they're
referenced only in one place. This includes all Freezed classes and plain data
classes. Do NOT scatter models across services or widgets. Examples:

- ✅ Class `UserData` → `lib/models/user_data.dart` (or
  `lib/models/user_data/user_data.dart` if UserData has related types)
- ✅ Class `LanguageOption` → `lib/models/language_option.dart`
- ❌ NOT in `lib/widgets/` even if only a widget uses it initially

---

Four layers under `lib/`:

- **`lib/models/`** — immutable data models only (Freezed + `fromJson`/`toJson`,
  and plain data classes). See below for folder structure.
- **`lib/views/`** — UI widgets, one subfolder per feature (`views/login/`, …).
  UI + wiring only, **no business logic**.
- **`lib/controllers/`** (or an `xyz_controller.dart` sitting next to its
  view) — **logic for EXACTLY ONE view**: that view's state, validation,
  loading/error handling, and calls into services.
- **`lib/services/`** — **logic shared across many views** (auth, data,
  theme, logging, config, cross-cutting state), provided as Riverpod
  providers, as singletons where sensible.
- **`lib/widgets/`** — reusable, shared widgets (see §4). These are **pure
  UI components, not data models**; any data they need comes from parameters.
- **`lib/theme/`** — centralized theming (see §5).

**Rule of thumb:** *Controller* = logic **for one view**. *Service* = logic
**shared across many views**.

**Layering rule:** Controllers depend on **service interfaces**, never
directly on a raw backend client (SDK, HTTP, DB) — this keeps layers cleanly
separated and easily swappable (e.g. demo mode, see `services/demo/` and
§8). A **stateless service is a plain class**, provided via a `keepAlive`
function provider. Only make it a notifier class if it actually holds state.

---

### Grouping related files into subfolders

`lib/models/` and `lib/services/` start flat (one file per concern) and stay
that way as long as one file is enough. **The moment a file declares more than
one top-level `class`/`abstract class`/`enum`, split it**: one file per type,
grouped into a subfolder named after the concern. Apply this consistently —
do not keep a multi-type file around because the extra type is "small" or
"only used in one place"; a reader should never have to scroll past an
unrelated class to find the one they came for.

- **Models.** A model file with one `@freezed` class stays a single file
  (`models/user_settings.dart`). The moment it declares a second type —
  another `@freezed` class, or an `enum` that isn't a single class's own
  companion — give it a folder: `models/user_data/` containing `user_data.dart`
  (the root document) plus one file per entity. Each file keeps its own
  `part '....freezed.dart'` / `part '....g.dart'`. A free top-level function
  that belongs conceptually to one type lives in that type's file, not in a
  separate one.

- **Services.** The same threshold applies: the moment a service file declares
  a second class, split it into a subfolder — `services/auth/` with
  `auth_service.dart` (the plain Appwrite wrapper) and `current_user.dart` (the
  stateful controller that watches it); `services/license/` with
  `license_service.dart` and `premium_status.dart`; `services/remote_log/` with
  `remote_log_sink.dart` (the interface), `appwrite_log_sink.dart` and
  `remote_log_talker_observer.dart`; `services/cloud_sync/` with
  `cloud_sync_service.dart` and `cloud_sync_controller.dart`. The same applies
  to a family of implementations behind one interface.

  A generated `*.g.dart` / `*.freezed.dart` companion is not a second file for
  this purpose — it is build output, not something anyone reads or maintains
  by hand.

- **Don't introduce a barrel file.** Splitting a model or service into a
  folder means every import site names the specific file it needs
  (`package:app/models/user_data/favorite_entry.dart`), not a single
  re-exporting `user_data.dart` that hides which file actually defines what.
  That indirection is exactly the kind of abstraction §0 asks you to avoid
  adding without a real need.

## 3. State management — Riverpod (code-gen) + Hooks

- **Riverpod with code generation** (`@riverpod` / `riverpod_annotation` +
  `riverpod_generator`) is the only state-management framework. Do NOT add a
  second one (BLoC/GetX/plain Provider), and do NOT use the deprecated
  `StateNotifier`/`ChangeNotifier`.
- **No `StatefulWidget` and no `ConsumerStatefulWidget`.** Allowed widget
  types:
  - **`StatelessWidget`** — pure presentation, no logic, no mutable state.
  - **`ConsumerWidget`** — reads providers / needs state.
  - **`HookConsumerWidget`** / **`HookWidget`** — needs widget-bound objects
    (e.g. `TextEditingController`) or pure UI state via `flutter_hooks`. This
    is the sanctioned way to have widget-lifecycle objects without a
    StatefulWidget.
- For every view with logic or mutable state: pair it with an
  **`@riverpod` controller**: `xyz_view.dart` (UI) + `xyz_controller.dart`
  (logic).
- **All view-local business state lives in the controller** — never in
  widget fields. Pure UI flags (password visibility, expand/collapse) may
  use `useState`.
- AVOID storing a `TextEditingController` (or any other widget-lifecycle
  object) as a field in an `@riverpod` controller — auto-dispose will yank it
  out from under the UI. Keep it in the view via `useTextEditingController()`;
  the controller receives plain **`String`s**. Existing Riverpod controllers
  with this anti-pattern (TextEditingController) must be flagged, or the
  controller MUST be set to keepAlive so it stays alive!
  Background: some apps were built with Riverpod 2.0, which had the opposite
  default behavior for providers! Make such controllers robust and
  compatible when using Riverpod 3+!!
- Avoid passing `BuildContext` into controllers/services. Controllers expose
  `AsyncValue`; the UI reacts via `ref.listen` to show snackbars or navigate.
- Expose async work as **`AsyncValue`** (`AsyncNotifier`/`FutureProvider`);
  the UI handles data/loading/error. Rationale as above.
- Long-lived state (auth, theme, logger, config, backend client) uses
  **`@Riverpod(keepAlive: true)`**; everything else disposes automatically.

### Controller shape (adopt this pattern)

```dart
/// Controller for the login screen. Holds no widget-lifecycle objects and
/// never receives a BuildContext; exposes progress as AsyncValue<void>.
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    // Empty body (NOT `return;`) — starts idle.
  }

  /// Logs the user in with [email] and [password].
  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue<void>.loading();
    try {
      final AuthService auth = ref.read(authServiceProvider);
      await auth.login(email: email, password: password);
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}
```

---

## 4. Widgets & reuse

- Extract **reused controls** into `lib/widgets/` subfolders — e.g. form
  inputs (`AppTextField` for a label+icon input, `AppPasswordField` for a
  password field with a built-in show/hide toggle), so styling is defined
  once and every screen stays consistent.
- A reusable **password field owns its own visibility state**
  (`useState` in a `HookWidget`), instead of taking a shared toggle from the
  caller — so it can be used any number of times.
- Provide consistent **loading/error/empty** widgets and use them across all
  `AsyncValue` views, so state handling looks uniform.
- Keep widgets small; give reusable widgets a **minimal, consistent API** and
  add parameters only when a real need arises.

---

## 5. Theming

If the project doesn't yet have theme support, here's the best practice:

- **Material 3** (`useMaterial3: true`). Build BOTH `ThemeData`, light and
  dark, from a **single seed color** via `ColorScheme.fromSeed(...)`.
- **Centralize theme construction** in `lib/theme/app_theme.dart`
  (`AppTheme.build({brightness, seedColor})`) — never inline in `app.dart`.
- **Font sizes and component styling belong in `ThemeData`** (e.g.
  `navigationRailTheme`, `textTheme`), defined once in `AppTheme` — never
  hardcoded at each call site. Restyle by editing the theme, not every
  individual widget.
- If the app offers a user-selectable **accent color**, store it as a seed
  (ARGB int) in user settings and re-derive the whole palette from it; prefer
  a **curated preset palette** over a free color wheel (no extra dependency,
  testable). Read colors back with `Color(intValue)` and persist with
  `color.toARGB32()` (`Color.value` is deprecated).
- Embedded third-party screens (log viewer, picker, …) should receive the
  app's `ColorScheme` so they match light/dark, instead of bringing their own
  default palette.

---

## 6. Models

- All data models use **Freezed** (`@freezed`, `abstract class X with _$X`)
  plus `fromJson`/`toJson`. No hand-written, mutable data classes.
- Give every field a **default** (`@Default(...)`) so `fromJson` tolerates
  missing keys (older cached/removed data after a field was added).

---

## 7. Navigation

If the project doesn't yet use a navigation pattern/solution, here's the
best practice to use:

- Use **`go_router`** with a top-level `redirect` guard driven by the
  auth/session provider (not authenticated → login; during the startup
  check → a splash).
- **Bind the router's `refreshListenable` to auth state**, so the redirect
  is re-evaluated immediately on login/logout, not only on explicit
  navigation.
- For a persistent sidebar/shell, use **`StatefulShellRoute.indexedStack`**,
  so each tab keeps its own state and URL/back behavior stays correct in the
  browser.

---

## 8. Testing

**Unit/widget tests are NOT used.** Do **not** write `test/` files or add a
`flutter_test` dependency, unless the user explicitly asks for it. Verify
changes manually instead (run the app, `flutter analyze`, browser preview
where applicable) — see §13.

### Demo/debug mode as the general substitute for tests

**This is the general approach, project-independent, not specific to this
template.** Every project of this kind ships a demo mode that makes the app
**fully usable without a real backend service and without a real user
database**:

- All backend access goes through **service interfaces** (§2). For every
  interface with network/DB access (auth, database/repository, license, …)
  there is an **in-memory fake implementation** under `lib/services/demo/`
  (here: `DemoAuthService`, `DemoCloudSyncService`, `DemoLicenseService`) that
  returns fixed, plausible demo data instead of making real requests.
- A central **`demoModeProvider`** (`@Riverpod(keepAlive: true)`, see
  [`demo_mode_service.dart`](lib/services/demo_mode_service.dart)) holds the
  toggle, persists the choice, and is itself gated by a compile-time flag
  (`kDebugMode` or `--dart-define`). The service providers
  (`authServiceProvider`, `cloudSyncServiceProvider`, …) `watch` it and return
  either the real or the fake implementation depending on its state —
  controllers never notice, they only know the interface (§2).
- **The toggle sits visibly on the login screen** (a switch/toggle labeled
  "Demo mode"), not hidden away in settings — using the demo is an equal,
  self-contained login path, not a hidden debug tool. Enabling it pre-fills
  the email/password fields with fixed demo credentials (see the `useEffect`
  in [`login_view.dart`](lib/views/login/login_view.dart)); the user presses
  the same login button as in a real sign-in, and the fake auth accepts it.
- If the real backend service is unreachable (server down, no intranet), the
  app shows a discreet hint but **does not block usage** — demo mode always
  remains the way to show/verify the app.
- **Gated exclusively at compile time** (§10) — never only a runtime switch
  that could be visible in a production build or bypass auth.

This is the **general verification path** for new features (§13): instead of
writing a unit test, start the app in demo mode and exercise the feature
against the fake data.

If the user wants classic tests for a *different* project (in addition to
demo mode, not instead of it): still depend on **service interfaces** and
override the service providers with **hand-written fakes** (preferred over a
mocking framework — more readable) via `ProviderContainer` /
`ProviderScope(overrides: [...])`. Riverpod 3 does **not** export the
`Override` type — write `overrides: [...]` without an explicit type argument.

---

## 9. Logging

- Use a structured logging framework (e.g. **Talker**) via a
  `LoggerService` provider. **No `print` / `debugPrint`** for app logging.
- **Log an exception once, at the boundary where it's handled with
  context** (controller/service `catch`), then rethrow or propagate via
  `AsyncValue`. Don't swallow silently; don't double-log at every layer.
- **Never log secrets or PII** (passwords, tokens, full email addresses) —
  redact first.
- Catch unhandled errors globally (`FlutterError.onError`,
  `PlatformDispatcher.instance.onError`), so errors are visible on
  web/desktop where there's no terminal.

---

## 10. Config & secrets

- Read config (endpoints, IDs, feature flags) via `--dart-define` /
  `--dart-define-from-file`, exposed through a constants class using
  `String.fromEnvironment` / `bool.fromEnvironment`.
- Give every value a **safe default**, so CI can compile without secrets.
- **No secrets in checked-in source.** Ship a `*.example.json`; gitignore the
  real config file.
- **Feature flags that bypass security (demo/offline modes, auth shortcuts)
  MUST be gated by a compile-time flag** (see §8 for the demo-mode example),
  not by a runtime switch alone — a runtime switch must never be able to
  bypass auth in a shipped binary.

---

## 11. Localization

- Standard ARB localization (`flutter: generate: true`, `l10n.yaml`,
  `lib/l10n/app_*.arb` with matching keys). No hardcoded, user-visible
  strings in widgets — add a key and use the generated `AppLocalizations`.
- **The base/source locale is English** (`template-arb-file: app_en.arb` in
  `l10n.yaml`). New keys are authored in `app_en.arb` first, then translated
  into the other `app_*.arb` files — English is the documentation language
  (see the note at the top of this file), and using it as the translation
  source keeps the ARB files consistent with the rest of the codebase.

---

## 12. Hooks & reactive pitfalls

Preferred control/event handling from the UI:

- **Widget state set in an event handler is lost on a provider-driven
  remount.** If an action both sets widget-local state (e.g. pre-filling a
  `TextEditingController`) AND changes a provider that the router guard
  observes, the guard may redirect the route and **remount the view**,
  reinitializing its hooks and discarding the value. Fix: derive that state
  from a **`useEffect` keyed on the source value**, so it re-applies on every
  (re)mount — don't set it once in the handler.

---

---

## 13. Workflow expectations for the assistant

- After changing sources for generated code (Freezed/JSON/Riverpod), run
  **`dart run build_runner build`**; after changing ARB files, regenerate the
  localizations. (`--delete-conflicting-outputs` is obsolete on
  `build_runner` ≥ 2.15.)
- Before reporting "done": **`flutter analyze` must report zero issues —
  warnings included, not just errors.** `flutter analyze` exits non-zero on
  any warning (e.g. an unused import), and the CI "Analyze" job fails the
  whole run on that exit code regardless of severity — a lingering warning
  is a red CI run, not a cosmetic nit. Don't leave a warning "for later" or
  wave it off as harmless; remove or fix it immediately. There is
  deliberately no test suite (§8) — verify instead by actually running the
  app **in demo mode** (browser preview or similar), where applicable. Report
  results honestly; if something fails or is skipped, say so.
- Match the **style of the surrounding code** in every change (comment
  density, naming, idioms).
- Keep changes tightly scoped; don't add dependencies or a second framework
  without a clear reason and (ideally) the user's sign-off.

---

---

## 14. Persistence — user settings vs. user data

Two kinds of stored data, and they are **not** the same thing. Getting this
split right at the start is what keeps a growing app from painting itself into
a corner, so decide which bucket a new field belongs in before writing it.

| | **User settings** | **User data** |
|---|---|---|
| What it is | Configuration the user picks from a form | Content the user creates over time |
| Examples | theme, language, accent, feature toggles | notes, bookmarks, journal entries, drafts |
| Size | fixed, small, a handful of scalars | unbounded in principle |
| Model | `UserSettings` | `UserData` |
| Remote home | Appwrite **account preferences** (64 kB cap) | Appwrite **Storage**, one file per user |

**Split by growth, not by importance.** A settings model that grows a *list* of
user-created entries has become user data and must move; keeping it in
preferences works right up until a heavy user hits the 64 kB limit and their
save starts failing.

**Every app gets a `UserData` model, even an empty-looking one.** It is far
cheaper to ship the slot unused than to retrofit a second store later.

### The rules

- **`shared_preferences` is the authoritative store, always.** Both models are
  read from it at startup (synchronously, so no view handles a loading state
  for them) and written back on every change. The app must work fully with the
  network unplugged and with `HAS_LOGIN=false`.
- **Appwrite is a sync layer touched at exactly three moments**, all of them
  user-initiated: **pull on login**, **push on the settings Save button**,
  **push on logout**. The settings Save button is always pressable (no
  "unsaved changes" gate), because it doubles as the manual resync/retry
  action, next to a visible "Last synced …" line so the state of the cloud
  copy is never a mystery.
- **No background writers.** No debounce timer that reaches the network, no
  `ref.listen` that persists, no mirror file written after every mutation, no
  save-on-widget-event. If a maintainer has to trace an event graph to answer
  "when does this get saved?", the design is wrong.
- **Settings pages are forms.** Controls edit a draft (`SettingsDraft`); a
  single **Save** button commits it. There is deliberately **no Cancel button** —
  leaving the page discards the draft, which is what an auto-dispose draft
  provider gives for free. This is the one place where auto-dispose is the
  feature rather than the hazard (§3).
- **Direct one-tap actions are exempt.** A theme toggle in the app bar or a
  sidebar collapse button is not a form field; those persist immediately.
- **File import/export is a button, never a listener.** One `BackupService`
  assembles and applies the whole document, and file/clipboard/cloud all use
  the same serialization — so "export, reinstall, import" and "sign in on
  another machine" exercise one code path.

### Backup container pattern

**Use a general-purpose `SettingsBackup` container** (not app-specific like
`AppBackup`) for serialized backups. A `SettingsBackup` always contains:

- **`userSettings`** (`UserSettings`) — app configuration (theme, language, etc.)
- **`userData`** (`UserData`) — user-created content (notes, bookmarks, etc.)
- **Optional app-specific fields** — project may add custom settings as needed,
  so the same backup class works across different projects.

This way, a user can **reinstall on a different device or different app** and
get back their core settings and data without code changes. Export the
container via `BackupService.exportToFile()` / `importFromFile()` /
`copyToClipboard()` / `pasteFromClipboard()`, all exercising the same JSON
serialization path.
- **Never a table for either.** Preferences have no schema to forget; a bucket
  has no size ceiling to design around. A table is only right when something is
  actually *queried* — nothing here ever is. TablesDB stays for genuinely
  queryable, cross-user data (the `logs` and `entitlements` tables).
- **`HAS_LOGIN=false` means no Appwrite at all.** `appwriteServiceProvider`
  throws when read in such a build, so the rule is enforced rather than
  documented.

### Appwrite specifics worth knowing

- `account.updatePrefs(prefs:)` **replaces** the whole object; there is no
  partial update. Store each model as a **JSON string** under its own key, so
  the SDK's own serialization can never reshape a nested object.
- `storage.updateFile` changes **only** a file's name and permissions, never
  its contents. Overwriting is `deleteFile` (swallow the 404) then
  `createFile`.
- Use `InputFile.fromBytes`, not `fromPath` — `fromPath` has no web
  implementation.
- Give the user-data file **`fileId == userId`**, so reading it back is a
  direct fetch and never a query.
- A 404 on either store means "nothing synced yet" — a normal state for a new
  account, not an error.

## 15. Web CORS proxy demo (external REST APIs)

The Home page's third card ("External REST API", `WebApiProxyService`,
`WebApiDemoController`, `functions/web-api-proxy/`) is a worked example of a
problem every non-trivial Flutter Web app eventually hits: **a browser
refuses to hand a page the response of a cross-origin request unless the
server being called sends back permission headers (CORS).** Most REST APIs
and virtually all plain web pages send none, so a direct call from the web
build is blocked before this app ever sees a reply — desktop/mobile builds
never hit this at all, since there is no browser sandbox involved there.

**Do not "fix" this by trying to disable or work around CORS from the
client.** There is no client-side workaround — it is enforced by the
browser itself. The only fix is a server you control in the middle: this
template ships one as `functions/web-api-proxy/`, an Appwrite Function that
fetches the target server-side (not subject to CORS) and hands the response
back. The Flutter app calls it via `Functions.createExecution(...)` — a
normal request to Appwrite's own REST API, the same one login already uses
— so the function needs **no CORS headers of its own**; the browser's
permission check happens against Appwrite's API, already allowed for the
app's origin by the same "Web" platform registration login requires.

**This demo is a teaching example, not a required feature.** If a fork does
not need to call an external API, delete all three pieces together: the
function folder, `web_api_proxy_service.dart` + `web_api_demo_controller.dart`,
and the card in `home_view.dart` (plus the `homeApiDemo*` ARB keys and
`AppConfig.webApiProxyFunctionId`). If a fork *does* need this, adapt it in
place — see README §12's three-step "Adapting this to your own API".

**Security — the function's allowlist is not optional.** `ALLOWED_HOSTS` in
`functions/web-api-proxy/src/main.js` exists to stop the function from
becoming an open proxy (SSRF risk) that fetches whatever URL any caller
supplies. Never remove it or widen it to "allow everything," even
temporarily to debug something.

## Short DON'T list

- ❌ `StatefulWidget` / `ConsumerStatefulWidget`; deprecated `StateNotifier` /
  `ChangeNotifier`; a second state-management library.
- ❌ For new Riverpod controllers, avoid where possible (or use keepAlive in
  existing controllers!): `TextEditingController` fields in Riverpod
  controllers.
- ❌ For new Riverpod controllers, avoid where possible (or use keepAlive in
  existing controllers!): `BuildContext` in controllers/services.
- ❌ Calling a raw backend client from a controller (go through a service).
- ❌ Cascade operators (`..`); spread operators (`...`) and collection
  `if`/`for` in widget/map literals; multi-step arrow-body methods; long
  single-line chains; nested ternaries.
- ❌ Hardcoded font sizes/styles at the call site; `ThemeData` built inline in
  `app.dart`.
- ❌ `print` / `debugPrint`; logging secrets or PII.
- ❌ Missing `///` on public APIs; `SCREAMING_CAPS` constants; file names that
  aren't `snake_case`.
- ❌ Comments, doc comments, or the base ARB locale written in a language
  other than English (§1, §11).
- ❌ Secrets/config IDs checked into source.
- ❌ Runtime-only flags that can bypass authentication in a production build.
- ❌ Saving a settings value on a widget event; any background writer that
  persists on a timer or a `ref.listen`; a mirror/backup file written
  automatically rather than from a button (§14).
- ❌ An Appwrite table for user settings or user data — preferences and a
  Storage bucket, respectively (§14).
