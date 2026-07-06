# Task: Build a new Flutter starter template (Riverpod 3.x + Freezed + Appwrite)

## Goal
Create a **brand-new, clean, production-ready Flutter starter template** from scratch.
This is a **greenfield project** — start from `flutter create` and build up. Do not assume any
existing codebase.

- **State management:** Riverpod **3.x** with **code generation** (`riverpod_annotation` + `riverpod_generator`). Use the Riverpod 3 generator API; do NOT use legacy `StateNotifier`/`ChangeNotifier` patterns.
- **Backend / DB:** **Appwrite Cloud** (hosted, online) for auth and data. Do **not** use Firebase or any other backend.
- **Models:** All data models generated with **Freezed**.
- **Logging:** **Talker** (`talker_flutter`) with Riverpod integration and an in-app live log view.
- **Target platforms:** **Flutter Web (first-class)**, **Linux Desktop**, **Windows Desktop** — configured, buildable and runnable on all three out of the box. Mobile (iOS/Android) is NOT a target; do not spend effort on it.

The result must be an **empty but production-ready starter** another developer can clone and immediately extend.

### Project creation
Create the project as a desktop/web app, e.g.:
```sh
flutter create --platforms=web,windows,linux --org com.example my_app
```
Choose a **neutral template name** (e.g. `flutter_appwrite_template`). Set a clear `description:` in `pubspec.yaml`.

---

## Hard Rules (MUST be enforced everywhere)

1. **NO `StatefulWidget` and NO `ConsumerStatefulWidget` anywhere.** Not a single one.
2. Allowed widget types:
   - **`StatelessWidget`** — pure presentation widgets with **no logic and no mutable state**.
   - **`ConsumerWidget`** — any widget that reads providers / needs state.
   - **`HookConsumerWidget`** — for widgets that need widget-scoped controllers (e.g. `TextEditingController`) or UI-only state via `flutter_hooks`. This is the sanctioned way to have widget-lifecycle objects WITHOUT a StatefulWidget.
3. For every view that needs logic or mutable state, create a **paired Riverpod controller** (a generated `@riverpod` Notifier/AsyncNotifier).
   Pattern: `xyz_view.dart` (UI) + `xyz_controller.dart` (`@riverpod` class).
4. **All view-local business state** lives in the **controller** — never in widget fields. Pure UI-only state (e.g. password-visibility toggle) may use hooks (`useState`).
5. **All models** use `@freezed` + `fromJson`/`toJson`. No hand-written mutable data classes.
6. Configure **`riverpod_lint` + `custom_lint`**; `flutter analyze` and `dart run custom_lint` must pass clean.

### Tie-breaker rule
If any two rules conflict (e.g. a style rule vs. readability, or a "no arrow function" rule vs. an idiomatic hook usage), **the reference implementation in this document wins**, and **readability for an intermediate developer** is the deciding factor.

---

## Code Style & Target Audience (MUST — governs ALL generated code)

**Target reader:** an **intermediate Flutter developer** who knows basic Dart syntax and Flutter, has built apps before, but is **NOT** an expert and is **not always up to date** with the newest Dart language features and shortcuts. All code in this template MUST be **easy to read, explicit, and self-explanatory** for that audience. This template is meant to be *learned from and extended*, not to show off advanced Dart.

**Prefer an elaborate, explicit, "boring" coding style over clever/concise code.** Readability beats brevity every time.

### DO (explicit, readable style)
- Use **explicit types** on variables, fields, parameters, and return values (e.g. `final String email = ...;`, `Future<void> login() async { ... }`). Avoid heavy reliance on `var`/type inference when a written type makes it clearer.
- Use **full block bodies with `{ ... }` and `return`** for functions and methods.
- Write **multi-line, step-by-step logic** with clearly named intermediate variables instead of chaining everything into one expression.
- Use plain **`if / else` statements** instead of ternary chains where it aids clarity.
- Add short comments explaining *why* something is done.
- Keep widget `build` methods broken into **small, clearly named helper widgets or `Widget _buildXxx()` methods** so the tree is easy to follow.
- Name things descriptively and fully (e.g. `isPasswordVisible`, not `pwv`).
- Handle errors with explicit `try / catch` blocks that log and return/rethrow clearly.

### AVOID (too clever / "expert-only" style)
- ❌ **Arrow-function bodies (`=>`) for anything non-trivial.** A one-line `=>` is only OK for truly trivial getters/callbacks (e.g. `onPressed: () => controller.submit()`). Do NOT write multi-step logic or whole methods as arrow expressions.
- ❌ Long **method/cascade chains** packed into a single statement (e.g. `list.where(...).map(...).toList()..sort()` all in one line). Break them into steps with named variables.
- ❌ Overusing **cascades (`..`)**, spread-heavy one-liners, complex **collection-if/for** inside big widget trees, or nested ternaries.
- ❌ Terse, "magic" reactive/functional-style code that requires deep Dart knowledge to parse.
- ❌ Excessive `extension`s, records, pattern-matching, or bleeding-edge syntax used purely for cleverness. Only use a modern feature when it genuinely makes the code *simpler for a non-expert to read*, and add a comment if it might be unfamiliar.
- ❌ Deeply nested inline anonymous functions.

### Dart naming & documentation conventions (MUST — follow the official Dart style guide)
- **Documentation:**
  - **Every public API (public classes, public methods, public functions, public fields, providers, top-level members) MUST have a `///` doc comment.** Start with a single-sentence summary.
  - **Private members (`_name`) do NOT require doc comments**, but add short `//` comments where the intent is not obvious.
  - Use `///` (not `/** */`) for doc comments, per Dart convention.
- **Naming (per effective Dart):**
  - **Classes, enums, typedefs, extensions, mixins:** `UpperCamelCase` (e.g. `LoginController`, `UserSettings`, `AuthService`).
  - **Variables, parameters, methods, functions, named constructors, fields:** `lowerCamelCase` (e.g. `isPasswordVisible`, `loadForCurrentUser`).
  - **Constants:** `lowerCamelCase` (modern Dart style, e.g. `defaultLanguageCode`) — do NOT use `SCREAMING_CAPS`.
  - **File names & folders:** `lowercase_with_underscores` (e.g. `login_view.dart`, `user_settings.dart`, `auth_service.dart`).
  - **Import prefixes / libraries:** `lowercase_with_underscores`.
  - **Booleans:** name as positive assertions (e.g. `isLoading`, `hasError`, `isDarkMode`).
  - Avoid abbreviations and single-letter names except for trivial loop counters.
- **General:**
  - Prefer `final` over `var` when a value does not change.
  - Order class members sensibly (constructors → public fields → public methods → private helpers).
  - Keep one primary public class per file where reasonable.

### Example — the SAME logic, written the way this template wants

**❌ Too concise / expert-style (do NOT write like this):**
```dart
Future<void> login(String e, String p) async =>
    state = await AsyncValue.guard(() async =>
        ref.read(authServiceProvider).login(email: e, password: p));
```

**✅ Elaborate, readable, well-documented style (write like this):**
```dart
/// Logs the user in with the given [email] and [password].
///
/// Sets [state] to loading while the request runs, then to data on success
/// or to error on failure.
Future<void> login({required String email, required String password}) async {
  final LoggerService logger = ref.read(loggerServiceProvider);
  logger.info('Login attempt started');

  // Show the loading spinner while the request is running.
  state = const AsyncValue.loading();

  try {
    final AuthService authService = ref.read(authServiceProvider);
    await authService.login(email: email, password: password);

    logger.info('Login was successful');
    state = const AsyncValue.data(null);
  } catch (error, stackTrace) {
    logger.handle(error, stackTrace, 'Login failed');
    state = AsyncValue.error(error, stackTrace);
  }
}
```

Both do the same thing; the template MUST use the second style throughout: explicit types, block bodies, `try/catch`, named variables, doc comments on public members.

### Consistency
- Apply this style to **every** file (views, controllers, services, models glue code, tests).
- The README's "Coding conventions" section MUST state: *"This template intentionally favors explicit, verbose, beginner-friendly Dart over concise expert-style code, follows the official Dart naming guidelines, and documents all public APIs, so an average/intermediate Flutter developer can read and extend it."*

---

## Architecture: view / model / controller / service

Four-layer separation under `lib/`:

- **`lib/models/`** — Freezed data models only (e.g. `UserSettings`, `AppUser`).
- **`lib/views/`** — UI (`ConsumerWidget` / `HookConsumerWidget` / `StatelessWidget`). One subfolder per feature (`views/login/`, `views/home/`, `views/settings/`, `views/profile/`, `views/about/`, `views/logs/`). Views contain UI + wiring only; **no business logic**.
- **`lib/controllers/`** (or co-located `xyz_controller.dart` next to its view) — **view-scoped logic**: the `@riverpod` controller for one specific view. Handles that view's state, validation, loading/error via `AsyncValue`, and calls into services.
- **`lib/services/`** — **central / cross-cutting logic** shared by multiple views, exposed as Riverpod providers and **singletons where sensible** (`ref.keepAlive()`):
  - **AppwriteService** (Appwrite `Client`),
  - **AuthService** (Appwrite `Account`),
  - **DatabaseService** (Appwrite `Databases`),
  - **ThemeService**, **LoggerService**, config/session access.
  A service **may itself be a Riverpod controller** if it manages state.
- **`lib/widgets/`** — reusable shared widgets, including consistent **loading / error / empty** state widgets used across all `AsyncValue` views.

**Rule of thumb:** *Controller* = logic **for one view**. *Service* = logic **shared by many views** (DB, theme, config, logging, cross-feature state), often a singleton provider.

**Layering rule:** controllers depend on **service interfaces**, never on the raw Appwrite client directly. This keeps controllers testable (see Testability).

---

## Riverpod 3.x specifics (MUST follow)

- Providers are **auto-dispose by default** in Riverpod 3.x. Long-lived services (Appwrite client, ThemeService, LoggerService, auth state) MUST call `ref.keepAlive()` or be declared to survive.
- **Never** store a `TextEditingController` (or any widget-lifecycle object) as a field inside a `@riverpod` controller. The provider auto-disposes and would `dispose()` the controller out from under the UI → "used after being disposed" crashes.
- **Never** pass `BuildContext` into controllers/services. Controllers expose `AsyncValue`; the UI reacts via `ref.listen` to show snackbars / navigate.
- Expose async work as `AsyncValue` (`AsyncNotifier`/`FutureProvider`); the UI handles `.when(data/loading/error)`.
- Use the **Riverpod 3 code-generation API** (`@riverpod`); do NOT use legacy `StateNotifier`/`ChangeNotifier`.

### MANDATORY form pattern (Hooks)
Use **`hooks_riverpod` + `flutter_hooks`**. `TextEditingController`s live in the **View** via `useTextEditingController()` (auto-disposed by the hook); the controller receives only **Strings**. UI-only booleans use `useState`. Reference implementation is in the Login/Register section below.

> Document the no-hooks alternative briefly in code comments/README: create controllers in a dedicated `@riverpod` provider and dispose via `ref.onDispose(() => c.dispose())`, keeping the provider alive while the view is mounted. **Hooks is the default this template ships with.**

---

## Navigation (MUST)

- Use **`go_router`** with a top-level `redirect` guard driven by the auth provider (unauthenticated → `/login`).
- For the authenticated shell (sidebar + content), use **`StatefulShellRoute.indexedStack`** so the collapsible NavigationRail stays persistent and each tab keeps its own state — current best practice for web/desktop shells, with correct browser URLs / back behavior.
- Register `TalkerRouteObserver` on the router so navigation is logged (see Logging).

---

## Web specifics (MUST — this template targets Flutter web as a first-class platform)

- Use **path-based URLs**: call `usePathUrlStrategy()` (from `package:flutter_web_plugins/url_strategy.dart`) in `main()` so routes are `/login`, not `/#/login`.
- Because of path URLs, **static hosting must rewrite all unknown paths to `index.html`** (SPA fallback); otherwise page refresh and deep links return 404. Document this in the README's hosting notes.
- Review and fill **`web/manifest.json`** (`name`, `short_name`, `theme_color`, `background_color`, `display: standalone`) and ensure it references the generated icons.
- State a renderer decision for web builds in the README (default CanvasKit) and how to override it.
- Ensure `go_router` deep-links + path URLs + hosting rewrite are described together so refresh/deep-link behavior is correct.

---

## Logging (MUST) — Talker-based, best practice, two layers

Use **`talker_flutter`** as the logging framework. Do NOT use `print`/`debugPrint` for app logging, and do NOT add `talker_logger` separately (it is already included by `talker_flutter`).

**Packages:**
- `talker_flutter` — core logger + Flutter integration + the ready-made `TalkerScreen` (live log view) + `TalkerRouteObserver`.
- `talker_riverpod_logger` — a `ProviderObserver` that pipes ALL Riverpod events (add/update/dispose/**fail**) into the same Talker instance.
- Do NOT add `talker_logger` (redundant) or `talker_dio_logger` (no Dio; Appwrite ships its own client).

**Setup (best practice):**
- Create a single `Talker` instance exposed via a `LoggerService` provider (`@Riverpod(keepAlive: true)`); expose typed helpers `info/debug/error/handle` that wrap `talker`.
- Register `TalkerRiverpodObserver(talker: ...)` in the root `ProviderScope(observers: [...])` so Riverpod state changes and provider failures are logged automatically.
- Register `TalkerRouteObserver(talker)` on `go_router`.
- Capture uncaught errors globally (crucial on Web/Desktop where the end-user has no terminal):
  - `FlutterError.onError = (details) => talker.handle(details.exception, details.stack);`
  - `PlatformDispatcher.instance.onError = (error, stack) { talker.handle(error, stack); return true; };`
  - Run `runApp` inside `runZonedGuarded` and forward zone errors to `talker.handle(...)`.
- **Exception logging policy:** log exceptions where they are *handled with context* (e.g. in `try/catch` inside controllers, and in `AuthService`/`DatabaseService` catch blocks) using `talker.handle(error, stackTrace, 'context message')`. Do not swallow errors silently, and do not double-log the same error at every layer — log once at the boundary where it is meaningful, then rethrow or surface via `AsyncValue`.
- **Never log secrets or PII** (passwords, tokens, full emails). Redact before logging (state this in code comments).

### Test logging on login (MUST)
To demonstrate the logging pipeline out of the box, the auth flow MUST emit logs:
- On login attempt: `logger.info('Login attempt for <redacted-email>')`.
- On success: `logger.info('Login success, session created')`.
- On failure: `logger.handle(error, stackTrace, 'Login failed')` (the Riverpod observer will also log the controller's `AsyncError` automatically).
- Analogous logs for register and logout.
These serve as living examples; keep them (they're useful) but ensure emails are redacted (e.g. show domain only or a masked value).

### Live Log view in the sidebar (MUST)
- Add a **"Logs" entry in the left sidebar** (`views/logs/`) that shows live log output.
- Preferred implementation: route Talker's built-in **`TalkerScreen(talker: ref.read(loggerServiceProvider).talker)`** as its own shell page (filterable, copyable, shareable) — minimal effort, production-quality UI. A custom `ConsumerWidget` subscribing to `talker.stream` via a `StreamProvider` is an allowed alternative.
- **Visibility gated by a user setting:** the Logs sidebar entry is shown when **`UserSettings.developerMode == true`** (default `false`), OR always in `kDebugMode`. This lets the user opt in to seeing live logs inside the app while keeping them hidden for normal end-users in production. Add a toggle for `developerMode` in the Settings view.

### Remote / server logging with Appwrite (SHOULD — prepared, optional, off by default)
On Web/Desktop, local console output is invisible to you in production, so remote logging matters. Prepare it, but keep it lean:
- Define a small `RemoteLogSink` abstraction and a Talker observer that forwards **only `error`/`fatal` level** events to it (never every debug log — cost/noise on a hosted backend).
- Provide an **`AppwriteLogSink`** implementation that writes those events as documents into a dedicated Appwrite **`logs` collection** (document the collection + permissions in the README). Gate it behind a config flag `remoteLoggingEnabled` (default `false`).
- In the README, mention **Sentry (`sentry_flutter`)** as the recommended alternative for full production crash monitoring, but do NOT add it as a default dependency.

---

## Localization (standardized ARB, MUST)

- `l10n.yaml` at repo root pointing to `lib/l10n/`; `flutter: generate: true`.
- `lib/l10n/app_en.arb` and `lib/l10n/app_de.arb` with matching keys, pre-filled with the app's example strings.
- Base keys: `appTitle`, `welcome`, `login`, `logout`, `email`, `password`, `settings`, `profile`, `about`, `help`, `theme`, `language`, `darkMode`, `version`, `logs`, `developerMode`.
- Login/register keys: `register`, `confirmPassword`, `displayName`, `passwordsDoNotMatch`, `noAccountRegister`, `haveAccountLogin`, `forgotPassword`, `resetPasswordSent`, `errorEmailAlreadyExists`, `errorInvalidCredentials`, `errorGeneric`, `showPassword`, `hidePassword`.
- Wire `MaterialApp` to generated `AppLocalizations`; `locale` comes from the locale provider backed by `UserSettings.languageCode`.

---

## Theming & responsiveness (MUST)

- **Material 3** (`useMaterial3: true`); light/dark `ColorScheme.fromSeed(...)` driven by `ThemeService` + `UserSettings.isDarkMode`.
- Responsive shell: auto-collapse sidebar on narrow widths (`LayoutBuilder`/breakpoints). Persist the user's manual collapse choice in `UserSettings.sidebarCollapsed`.

---

## Accessibility & consistent UI states (SHOULD)
- Provide semantic labels and a sensible focus order for the login form and navigation.
- Provide reusable **loading / error / empty** widgets (in `lib/widgets/`) and use them consistently for all `AsyncValue` views, so state handling looks uniform across the app.

---

## Login / Register screen (detailed spec — MUST)

Single `LoginView` (`HookConsumerWidget`) that toggles between **Login** and **Register** modes (no separate route). `LoginController` (`@riverpod`) holds the logic; UI-only state (password visibility, mode toggle) uses hooks (`useState`), NOT the controller.

### Layout
- **Centered logo** (`assets/images/logo.png`) directly above the input controls, inside a width-constrained card (`maxWidth ≈ 420`) so it looks correct on wide web/desktop windows.
- **Inputs:** email, password. In register mode also show **confirm password** and an optional **display name** field.
- **Password field:** `obscureText` toggled by an **eye icon** (`IconButton` as `suffixIcon`, `Icons.visibility` / `Icons.visibility_off`). The visibility boolean is view UI state via `useState`.
- **Discreet version number bottom-left:** small, muted text (e.g. `Theme.of(context).textTheme.bodySmall` in `disabledColor`), value from `package_info_plus`.
- **Theme switch button** (e.g. top-right): toggles light/dark **before login** via `ThemeService` (persisted to the local cache / `shared_preferences`, since no user exists yet). **After login**, `UserSettings.isDarkMode` loaded from Appwrite takes over and drives the theme.
- **"Forgot password?" link:** prepared in login mode. Wire it to `account.createRecovery(...)` (may be a functional stub that shows a "reset link sent" message); real completion (`updateRecovery`) can be a documented TODO.

### Auth via Appwrite Account API (do NOT roll your own auth/user storage)
- **Login:** `account.createEmailPasswordSession(email, password)`.
- **Register:** `account.create(userId: ID.unique(), email, password, name)`, then auto-login (`createEmailPasswordSession`), then create the initial per-user `UserSettings` document in the Appwrite database.
- **Duplicate users:** do NOT pre-check for existing emails. Appwrite enforces uniqueness server-side; `account.create(...)` throws `AppwriteException(code: 409)` for an existing email — catch it and show a localized "email already registered" message.
- **Startup guard:** on app start, call `account.get()` to determine the current session; `go_router`'s `redirect` sends authenticated users to the shell and others to `/login`.
- **Password reset:** `account.createRecovery(email, url)` to send the reset email; document `account.updateRecovery(...)` for completing it.
- **Client-side validation for UX only:** non-empty fields, valid email format, password == confirm password (register). Real enforcement is server-side.
- Map `AppwriteException` codes to localized messages (`409` → email exists, `401` → invalid credentials, else generic). Show via the snackbar/toast service using `ref.listen` on the controller's `AsyncValue` — never pass `BuildContext` into the controller.
- **Log every auth step via Talker** (see Logging → "Test logging on login").

### Reference implementation (note the explicit, documented style)
```dart
/// Login and registration screen.
///
/// Uses hooks for widget-scoped controllers so that no StatefulWidget is needed.
/// All business logic lives in [LoginController]; this widget only builds UI.
class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController confirmController = useTextEditingController();
    final TextEditingController nameController = useTextEditingController();

    // Pure UI-only state (not business logic), so it lives in the widget via hooks.
    final ValueNotifier<bool> isPasswordVisible = useState<bool>(false);
    final ValueNotifier<bool> isRegisterMode = useState<bool>(false);

    final AsyncValue<void> authState = ref.watch(loginControllerProvider);
    final bool isDarkMode = ref.watch(themeServiceProvider).isDarkMode;
    final String appVersion = ref.watch(appVersionProvider);

    // React to success/failure without passing BuildContext into the controller.
    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      if (next.hasError == true) {
        final String message = mapAuthError(context, next.error!);
        showSnackbar(context, message);
        return;
      }
      if (next.hasValue == true && next.isLoading == false) {
        context.go('/');
      }
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _buildForm(
                context: context,
                ref: ref,
                emailController: emailController,
                passwordController: passwordController,
                confirmController: confirmController,
                nameController: nameController,
                isPasswordVisible: isPasswordVisible,
                isRegisterMode: isRegisterMode,
                authState: authState,
              ),
            ),
          ),
          _buildVersionLabel(context, appVersion),
          _buildThemeSwitch(context, ref, isDarkMode),
        ],
      ),
    );
  }

  // Private helpers do not require doc comments, but keep them small and clear.
  Widget _buildForm({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmController,
    required TextEditingController nameController,
    required ValueNotifier<bool> isPasswordVisible,
    required ValueNotifier<bool> isRegisterMode,
    required AsyncValue<void> authState,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset('assets/images/logo.png', height: 96),
        const SizedBox(height: 24),
        TextField(controller: emailController /* email */),
        if (isRegisterMode.value == true)
          TextField(controller: nameController /* optional display name */),
        _buildPasswordField(passwordController, isPasswordVisible),
        if (isRegisterMode.value == true)
          TextField(
            controller: confirmController,
            obscureText: isPasswordVisible.value == false,
          ),
        const SizedBox(height: 16),
        _buildSubmitButton(
          context: context,
          ref: ref,
          emailController: emailController,
          passwordController: passwordController,
          confirmController: confirmController,
          nameController: nameController,
          isRegisterMode: isRegisterMode,
          authState: authState,
        ),
        _buildToggleModeButton(isRegisterMode),
      ],
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    ValueNotifier<bool> isVisible,
  ) {
    final IconData icon =
        isVisible.value ? Icons.visibility : Icons.visibility_off;
    return TextField(
      controller: controller,
      obscureText: isVisible.value == false,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(icon),
          onPressed: () {
            isVisible.value = !isVisible.value;
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmController,
    required TextEditingController nameController,
    required ValueNotifier<bool> isRegisterMode,
    required AsyncValue<void> authState,
  }) {
    final bool isLoading = authState.isLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              final LoginController controller =
                  ref.read(loginControllerProvider.notifier);

              if (isRegisterMode.value == true) {
                if (passwordController.text != confirmController.text) {
                  showSnackbar(context, 'Passwords do not match');
                  return;
                }
                controller.register(
                  email: emailController.text,
                  password: passwordController.text,
                  name: nameController.text,
                );
              } else {
                controller.login(
                  email: emailController.text,
                  password: passwordController.text,
                );
              }
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(isRegisterMode.value ? 'Register' : 'Login'),
    );
  }

  Widget _buildToggleModeButton(ValueNotifier<bool> isRegisterMode) {
    return TextButton(
      onPressed: () {
        isRegisterMode.value = !isRegisterMode.value;
      },
      child: Text(
        isRegisterMode.value ? 'Have an account? Login' : 'No account? Register',
      ),
    );
  }

  Widget _buildVersionLabel(BuildContext context, String version) {
    return Positioned(
      left: 12,
      bottom: 12,
      child: Text(
        'v$version',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).disabledColor),
      ),
    );
  }

  Widget _buildThemeSwitch(
    BuildContext context,
    WidgetRef ref,
    bool isDarkMode,
  ) {
    final IconData icon = isDarkMode ? Icons.light_mode : Icons.dark_mode;
    return Positioned(
      right: 12,
      top: 12,
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {
          ref.read(themeServiceProvider.notifier).toggle();
        },
      ),
    );
  }
}
```

```dart
/// Controller for the login/register screen.
///
/// Holds no widget-lifecycle objects and never receives a [BuildContext].
/// It only receives plain [String] values and exposes state as [AsyncValue].
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    // No initial work needed; the screen starts in an idle data state.
    return;
  }

  /// Logs the user in with the given [email] and [password].
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Login attempt (${redactEmail(email)})');

    state = const AsyncValue.loading();
    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.login(email: email, password: password);

      logger.info('Login success, session created');

      final UserSettingsController settingsController =
          ref.read(userSettingsControllerProvider.notifier);
      await settingsController.loadForCurrentUser();

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Login failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }

  /// Registers a new user, then logs them in and creates default settings.
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final LoggerService logger = ref.read(loggerServiceProvider);
    logger.info('Register attempt (${redactEmail(email)})');

    state = const AsyncValue.loading();
    try {
      final AuthService authService = ref.read(authServiceProvider);
      await authService.register(
        email: email,
        password: password,
        name: name,
      );
      await authService.login(email: email, password: password);

      final UserSettingsController settingsController =
          ref.read(userSettingsControllerProvider.notifier);
      await settingsController.createDefaultsForCurrentUser();

      logger.info('Register success for ${redactEmail(email)}');
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, 'Register failed');
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }

  /// Sends a password recovery email to the given [email].
  Future<void> sendPasswordReset(String email) async {
    final AuthService authService = ref.read(authServiceProvider);
    await authService.sendPasswordReset(email);
  }
}

/// Service that wraps the Appwrite Account API for authentication.
///
/// Kept alive for the lifetime of the app because it is used across views.
/// Controllers depend on this service, not on the raw Appwrite client, so it
/// can be overridden with a fake in tests.
@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  @override
  void build() {
    return;
  }

  Account get _account => ref.read(appwriteServiceProvider).account;

  /// Creates a new Appwrite user. Throws [AppwriteException] with code 409
  /// when a user with the same email already exists.
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  /// Creates an email/password session for the given credentials.
  Future<void> login({
    required String email,
    required String password,
  }) {
    return _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  /// Returns the currently logged-in user, used by the startup auth guard.
  Future<User> currentUser() {
    return _account.get();
  }

  /// Deletes the current session (logout).
  Future<void> logout() {
    return _account.deleteSession(sessionId: 'current');
  }

  /// Sends a password recovery email.
  Future<void> sendPasswordReset(String email) {
    return _account.createRecovery(
      email: email,
      url: passwordRecoveryUrl,
    );
  }
}

/// Maps an Appwrite error to a localized, user-friendly message.
String mapAuthError(BuildContext context, Object error) {
  if (error is AppwriteException) {
    if (error.code == 409) {
      return 'This email is already registered';
    }
    if (error.code == 401) {
      return 'Invalid email or password';
    }
    return error.message ?? 'Something went wrong';
  }
  return 'Something went wrong';
}

/// Masks an email address so it can be logged without exposing PII.
String redactEmail(String email) {
  final int atIndex = email.indexOf('@');
  if (atIndex <= 1) {
    return '***';
  }
  final String firstChar = email.substring(0, 1);
  final String domain = email.substring(atIndex);
  return '$firstChar***$domain';
}
```

---

## Required App Structure & Features (the empty template UI)

Minimal, **best-practice, non-over-engineered** shell:

### 1. Freezed `UserSettings` model (`lib/models/user_settings.dart`)
`@freezed` with at least:
- `isDarkMode` — wired to the theme via `ThemeService`.
- `languageCode` — used by the locale provider.
- `sidebarCollapsed` — sidebar state.
- `developerMode` (bool, default `false`) — gates the Logs sidebar entry / live log view.
- example extra: `displayName`.
Persisted **remotely in Appwrite** (per user) + cached locally (`shared_preferences`). Provide `UserSettingsController` (`@riverpod`) to load/save via `DatabaseService`, plus `createDefaultsForCurrentUser()` used right after registration.

### 2. Login / Register screen
As specified in the detailed section above.

### 3. Authenticated layout (desktop/web shell)
- **Top header bar:** logo/title left; a few **static links** right (Home, Docs/Help, GitHub).
- **Left collapsible sidebar** (NavigationRail, expand/collapse state in `UserSettings`), with an **avatar circle** (initials/image) → opens Profile/Settings. Includes a **"Logs" entry shown only when `developerMode` is true (or in `kDebugMode`)**.
- **Right content area:** routed pages.

### 4. Pages / Views
- **Settings** (`SettingsView` + `SettingsController`): edit `UserSettings` (dark/light, language dropdown, **developerMode toggle**, example fields) → persists (Appwrite + cache) and updates UI live.
- **Profile:** current user info (avatar, email/name from Appwrite).
- **About:** app name, **version & build number** via `package_info_plus`, links, short description.
- **Help:** prepared entry (docs URL or placeholder page).
- **Logs:** live Talker log view (`TalkerScreen` or custom), gated by `developerMode`/`kDebugMode`.

---

## Appwrite Integration (the backend)

- Official **`appwrite`** SDK (use a caret-constrained version).
- **AppwriteService** (singleton provider): `Client` with `endpoint` + `projectId` from config (`--dart-define` / `--dart-define-from-file`, **no hardcoded secrets**); exposes `account` and `databases`.
- **AuthService** (Appwrite `Account`): register/login/logout/current user/password recovery.
- **DatabaseService** (Appwrite `Databases`): store/read per-user `UserSettings` document; and (optional) write to the `logs` collection when remote logging is enabled.
- **Web:** the web hostname must be registered in the Appwrite console — document this in the README.

### Appwrite data model & security (MUST — be explicit)
- Store each user's settings as a **single document whose document ID equals the Appwrite user ID** (`documentId: userId`), so lookups are direct and there is exactly one settings document per user.
- Set **document-level permissions** so only the owner can read/write their settings (e.g. `Permission.read(Role.user(userId))`, `Permission.update(Role.user(userId))`, `Permission.delete(Role.user(userId))`). Document the required Collection settings/attributes/permissions in the README.
- **Settings precedence / first load:** show sane defaults immediately; load the **local cached settings** (`shared_preferences`) first for instant UI, then fetch the **remote** document and let remote win once available; write changes to both local cache and Appwrite.

---

## Config / secrets (MUST)
- Read Appwrite `endpoint`/`projectId`, `passwordRecoveryUrl`, and `remoteLoggingEnabled` via `--dart-define` **or** `--dart-define-from-file=config/app_config.json`.
- Ship `config/app_config.example.json`; add the real config file to `.gitignore`. No secrets committed.

---

## `pubspec.yaml` expectations

**dependencies** (use **caret ranges `^x.y.z`**, latest stable compatible with Riverpod 3.x — do NOT hard-pin everything, and never use `any`):
`flutter_riverpod` (3.x), `hooks_riverpod`, `flutter_hooks`, `riverpod_annotation`,
`freezed_annotation`, `json_annotation`, `appwrite`, `go_router`,
`flutter_localizations` (sdk), `intl` (caret-constrained, NOT `any`),
`package_info_plus`, `shared_preferences`, `flutter_secure_storage`,
`flutter_launcher_icons`, **`talker_flutter`**, **`talker_riverpod_logger`**.

**dev_dependencies:**
`build_runner`, `riverpod_generator`, **`freezed`** (generator belongs here, not in dependencies),
`json_serializable`, `custom_lint`, `riverpod_lint`, `flutter_lints`.

Do NOT add `talker_logger` or `talker_dio_logger`.

Keep `flutter: generate: true`, register `assets/` (`assets/`, `assets/images/`, `assets/icons/`), and configure `flutter_launcher_icons` for `web` + `windows` as a single source from `assets/images/logo.png`.

---

## Icons & favicon (MUST) — single source
`flutter_launcher_icons` is the current, actively maintained standard. One 1024×1024 `assets/images/logo.png` generates launcher icons, the **web favicon/manifest icons**, and Windows icons. Document regeneration: `dart run flutter_launcher_icons`.

---

## Platform enablement
- Web, Windows, Linux enabled (from `flutter create --platforms=web,windows,linux`).
- `web/index.html`, `web/manifest.json`, favicon present and referencing generated icons.

---

## Storage (MUST)
- Store auth/session tokens in **`flutter_secure_storage`** (desktop-capable; Appwrite manages web session cookies itself). Use `shared_preferences` only for non-sensitive cached settings (e.g. pre-login theme, cached `UserSettings`).

---

## Project hygiene (MUST)
- Verify a proper Flutter **`.gitignore`** (build output, `.dart_tool/`, plus the real `config/app_config.json`).
- Decide and state whether generated `*.g.dart` / `*.freezed.dart` files are committed. **Recommended: commit them** so the template builds without requiring a first codegen run — otherwise clearly document "run build_runner first" as step one.
- Add a **LICENSE** file with a permissive license (e.g. MIT) so the template is genuinely reusable as a neutral starter.

---

## Tooling & CI (SHOULD)
- `analysis_options.yaml`: keep `flutter_lints` AND enable custom_lint:
  ```yaml
  include: package:flutter_lints/flutter.yaml
  analyzer:
    plugins:
      - custom_lint
  ```
- CI pipeline (e.g. GitHub Actions): `flutter pub get` → `dart run build_runner build --delete-conflicting-outputs` → `flutter analyze` → `dart run custom_lint` → matrix `flutter build web` / `linux` / `windows`.
- At least one **widget test** (login form renders, toggles to register) and one **controller test** (auth/settings with a mocked Appwrite service).

---

## Testability (MUST — make Appwrite mockable)
- Wrap Appwrite behind the service interfaces (`AuthService`, `DatabaseService`) and depend on those in controllers (never call the raw Appwrite client from a controller).
- In tests, override the service providers with fakes/mocks via `ProviderContainer` / `ProviderScope(overrides: ...)` so tests never hit the network. The required "controller test" must use such an override.

---

## README.md (write in English)

Include, in order:
1. **Short description** (Riverpod 3.x + codegen + hooks, Freezed, Appwrite Cloud, Talker logging, Web/Linux/Windows).
2. **Screenshots** placeholder.
3. **Dev environment setup (step by step):** VSCode + Flutter extension; Flutter SDK + `flutter doctor`; enable targets `flutter config --enable-windows-desktop --enable-linux-desktop --enable-web`; Linux prerequisites (`clang cmake ninja-build pkg-config libgtk-3-dev`); **Appwrite Cloud setup** (create account, project, note Project ID + endpoint, add Web platform/hostname, enable Email/Password auth, create Database + Collection for `UserSettings` with attributes + **document-level owner permissions**, document ID = user ID; optional `logs` collection for remote logging).
4. **Configure the project:** copy `config/app_config.example.json`, insert endpoint/projectId (+ recovery URL, remote-logging flag).
5. **Code generation:**
   ```sh
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```
6. **First run / debug (step by step):**
   ```sh
   flutter pub get
   flutter run -d chrome  --dart-define-from-file=config/app_config.json
   flutter run -d windows --dart-define-from-file=config/app_config.json
   flutter run -d linux   --dart-define-from-file=config/app_config.json
   ```
7. **Logging & debugging:** explain that logs appear in the console AND in the in-app **Logs view** (enable via the **developer mode** toggle in Settings), that Riverpod state changes and errors are logged automatically, and how to enable optional Appwrite remote logging; mention Sentry as an alternative for production.
8. **Regenerate icons/favicon:** place `assets/images/logo.png` (1024×1024) → `dart run flutter_launcher_icons`.
9. **Build & release (Web):** `flutter build web --release`; note the **SPA fallback rewrite to `index.html`** required by path-based URLs, plus generic static-hosting notes and renderer choice.
10. **Project structure:** `models/`, `views/`, `controllers/`, `services/`, `widgets/`, `config/`, `l10n/`.
11. **Coding conventions:** restate hard rules — no StatefulWidget/ConsumerStatefulWidget; StatelessWidget only for logic-free UI; ConsumerWidget/HookConsumerWidget + `@riverpod` controller for stateful views; view-logic in controllers, shared logic in services; **TextEditingControllers live in the View via hooks, controllers receive Strings only, never BuildContext**; Freezed models only; **all logging via Talker, no print/debugPrint, never log secrets/PII**; **explicit/verbose beginner-friendly Dart, official Dart naming conventions, all public APIs documented with `///`**.

---

## Explicit DON'Ts (anti-patterns to avoid)
- ❌ `TextEditingController` fields inside Riverpod controllers (breaks under Riverpod 3.x auto-dispose).
- ❌ `BuildContext` parameters in controllers/services.
- ❌ Calling the raw Appwrite client from a controller (call it through a service so it stays mockable).
- ❌ Pre-querying Appwrite for an existing email before register (rely on the server-side `409` instead).
- ❌ `print()` / `debugPrint()` for app logging; adding `talker_logger` or `talker_dio_logger`.
- ❌ Logging secrets or PII (passwords, tokens, full emails).
- ❌ Terse/expert-style Dart: multi-step arrow-body methods, long single-line method/cascade chains, nested ternaries, cleverness an intermediate developer can't easily read. Prefer explicit, verbose, well-commented code (see "Code Style & Target Audience").
- ❌ Missing `///` docs on public APIs; `SCREAMING_CAPS` constants; non-`snake_case` file names.
- ❌ `intl: any` / unpinned or hard-pinned-everywhere deps; `freezed` generator in `dependencies` instead of `dev_dependencies`.
- ❌ Hash-based web URLs (use `usePathUrlStrategy()`).
- ❌ Any second state-management lib (BLoC/GetX/Provider) alongside Riverpod, or legacy `StateNotifier`/`ChangeNotifier`.
- ❌ Firebase or any non-Appwrite backend.
- ❌ Storing secrets or Appwrite IDs in committed source.

---

## Acceptance Criteria (Definition of Done)
- [ ] No `StatefulWidget` / `ConsumerStatefulWidget` anywhere in `lib/`.
- [ ] `StatelessWidget` only for logic-free UI; stateful views use `ConsumerWidget`/`HookConsumerWidget` + a `@riverpod` controller.
- [ ] `TextEditingController`s live in the View (hooks); controllers receive Strings only; no `BuildContext` in controllers/services.
- [ ] Long-lived services use `ref.keepAlive()`; short-lived state auto-disposes cleanly (no "used after disposed" errors).
- [ ] Clear separation: view-logic in `controllers/`, shared logic (DB, theme, config, logger) in `services/`; controllers call services, not the raw Appwrite client.
- [ ] Uses Riverpod 3 code-gen API; no legacy `StateNotifier`/`ChangeNotifier`.
- [ ] All models are `@freezed` with working `fromJson`/`toJson`.
- [ ] Appwrite used for auth + settings storage; no Firebase; neutral package name.
- [ ] **Code style:** explicit types, block bodies (not multi-step `=>`), `if/else` over nested ternaries, named intermediate variables instead of long chains, helper `_buildXxx()` methods for large widget trees.
- [ ] **Dart conventions:** all public classes/methods/functions/fields/providers have `///` doc comments; `UpperCamelCase` types, `lowerCamelCase` members, `lowercase_with_underscores` file names; no `SCREAMING_CAPS` constants.
- [ ] **Web:** `usePathUrlStrategy()` used; `web/manifest.json` filled; README documents SPA rewrite + renderer choice.
- [ ] **Appwrite data:** settings document keyed by user ID with document-level owner permissions; local-then-remote settings precedence implemented.
- [ ] **Login/Register screen:** centered logo above controls; email + password inputs; register mode adds confirm-password + optional display name; password field has a working eye toggle; discreet version bottom-left; theme switch (local before login, `UserSettings` after); "Forgot password?" link wired to `createRecovery`.
- [ ] Register uses `account.create` + auto-login + creates default `UserSettings`; duplicate email handled via `AppwriteException` 409 (not pre-checked).
- [ ] Navigation via `go_router` + `StatefulShellRoute` for the sidebar shell; startup auth guard via `account.get()`; redirect works.
- [ ] Logging via `talker_flutter`; no `print`/`debugPrint`; `talker_logger`/`talker_dio_logger` NOT added.
- [ ] `TalkerRiverpodObserver` registered in root `ProviderScope`; `TalkerRouteObserver` on `go_router`; `FlutterError.onError` + `PlatformDispatcher.onError` + `runZonedGuarded` route errors into Talker.
- [ ] Login/register/logout emit Talker logs (with redacted email); exceptions handled via `talker.handle(...)` at the right boundary, no silent swallowing.
- [ ] Sidebar "Logs" view shows live log output; visible only when `UserSettings.developerMode == true` (or in `kDebugMode`); Settings has a developerMode toggle.
- [ ] `RemoteLogSink` abstraction with an `AppwriteLogSink` (error/fatal only), off by default via `remoteLoggingEnabled`; no secrets/PII logged.
- [ ] App builds and runs on **web, windows, linux**.
- [ ] Login → collapsible sidebar (with avatar) + top static links + right content works.
- [ ] Settings, Profile, About (dynamic version), Help, Logs present and reachable.
- [ ] `UserSettings` (theme + language + developerMode + example fields) persists and drives theme/locale live.
- [ ] Material 3 theming; responsive sidebar collapse.
- [ ] Reusable loading/error/empty widgets used consistently; login form + nav have semantic labels / sensible focus order.
- [ ] Launcher icons + web favicon generated from a single `logo.png` via `flutter_launcher_icons`.
- [ ] ARB files for `en` + `de` present (incl. login/register + logs/developerMode keys) and wired via `AppLocalizations`.
- [ ] Tokens in `flutter_secure_storage`.
- [ ] `.gitignore` correct; generated files decision documented; LICENSE (permissive) present.
- [ ] `analysis_options.yaml` enables `custom_lint`; `flutter analyze` and `dart run custom_lint` pass clean.
- [ ] CI pipeline + at least one widget test and one controller test (using provider overrides) present.
- [ ] README written in English with full step-by-step setup + first-debug + logging guide.
- [ ] `dart run build_runner build --delete-conflicting-outputs` completes without errors.
```