import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/services/app_version_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_data.dart';
import 'package:flutter_template_appwrite/services/demo_mode_service.dart';
import 'package:flutter_template_appwrite/services/theme_service.dart';
import 'package:flutter_template_appwrite/utils/auth_error_mapper.dart';
import 'package:flutter_template_appwrite/views/login/login_controller.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_password_field.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_text_field.dart';

/// Login and registration screen.
///
/// Uses hooks for widget-scoped controllers so that no StatefulWidget is
/// needed: `useTextEditingController` creates and auto-disposes the text
/// controllers, `useState` holds pure UI-only flags (password visibility,
/// login/register mode). All business logic lives in [LoginController];
/// this widget only builds UI and forwards plain strings.
///
/// (No-hooks alternative, for reference: create the TextEditingControllers
/// in a dedicated `@riverpod` provider and dispose them via
/// `ref.onDispose(() => controller.dispose())`, keeping that provider alive
/// while the view is mounted. Hooks is the default this template ships.)
class LoginView extends HookConsumerWidget {
  /// Creates a [LoginView].
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Widget-scoped text controllers, auto-disposed by the hooks.
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController =
        useTextEditingController();
    final TextEditingController confirmController =
        useTextEditingController();
    final TextEditingController nameController = useTextEditingController();

    // Pure UI-only state (not business logic), so it lives in the widget.
    // (Password visibility is now owned by each AppPasswordField itself.)
    final ValueNotifier<bool> isRegisterMode = useState<bool>(false);

    final AsyncValue<void> authState = ref.watch(loginControllerProvider);
    final bool isDarkMode = ref.watch(themeServiceProvider);
    final bool isDemoMode = ref.watch(demoModeProvider);

    // Keep the form in sync with demo mode. This must be an effect, not a
    // one-off in the switch's onChanged: flipping demo mode rebuilds the
    // auth state, which briefly bounces the router (login -> splash -> login)
    // and REMOUNTS this view — a value set once in onChanged would be lost.
    // Keying on [isDemoMode] re-applies it on every (re)mount.
    useEffect(() {
      if (isDemoMode) {
        emailController.text = demoEmail;
        passwordController.text = demoPassword;
      } else {
        emailController.clear();
        passwordController.clear();
      }
      return null;
    }, <Object?>[isDemoMode]);

    // React to success/failure without passing BuildContext into the
    // controller. Navigation on success is handled by the router's auth
    // guard (refreshListenable), so only errors need handling here.
    ref.listen<AsyncValue<void>>(
      loginControllerProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (next.hasError && next.isLoading == false) {
          final String message = mapAuthError(context, next.error!);
          showErrorSnackbar(context, message);
        }
      },
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                // Width-constrained card so the form looks right on wide
                // web/desktop windows.
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: _buildForm(
                      context: context,
                      ref: ref,
                      localizations: localizations,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmController: confirmController,
                      nameController: nameController,
                      isRegisterMode: isRegisterMode,
                      authState: authState,
                      isDemoMode: isDemoMode,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildVersionLabel(context, ref),
          _buildThemeSwitch(context, ref, localizations, isDarkMode),
        ],
      ),
    );
  }

  // Private helpers do not require doc comments; kept small and clear.

  Widget _buildForm({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmController,
    required TextEditingController nameController,
    required ValueNotifier<bool> isRegisterMode,
    required AsyncValue<void> authState,
    required bool isDemoMode,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Centered logo directly above the input controls.
        Image.asset(
          'assets/images/logo.png',
          height: 96,
          semanticLabel: localizations.appTitle,
        ),
        const SizedBox(height: 24),
        Text(
          isRegisterMode.value
              ? localizations.register
              : localizations.login,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: emailController,
          label: localizations.email,
          icon: Icons.mail_outline,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        if (isRegisterMode.value) ...<Widget>[
          const SizedBox(height: 16),
          AppTextField(
            controller: nameController,
            // The display name is optional on registration.
            label: localizations.displayName,
            icon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
          ),
        ],
        const SizedBox(height: 16),
        AppPasswordField(
          controller: passwordController,
          label: localizations.password,
          textInputAction: TextInputAction.done,
        ),
        if (isRegisterMode.value) ...<Widget>[
          const SizedBox(height: 16),
          AppPasswordField(
            controller: confirmController,
            label: localizations.confirmPassword,
            textInputAction: TextInputAction.done,
          ),
        ],
        const SizedBox(height: 24),
        _buildSubmitButton(
          context: context,
          ref: ref,
          localizations: localizations,
          emailController: emailController,
          passwordController: passwordController,
          confirmController: confirmController,
          nameController: nameController,
          isRegisterMode: isRegisterMode,
          authState: authState,
        ),
        const SizedBox(height: 8),
        if (isRegisterMode.value == false)
          _buildForgotPasswordButton(
            context: context,
            ref: ref,
            localizations: localizations,
            emailController: emailController,
          ),
        _buildToggleModeButton(localizations, isRegisterMode),
        // Only rendered in builds that allow demo mode (debug, or a build
        // compiled with --dart-define=DEMO_MODE_ALLOWED=true). In production
        // it is absent entirely.
        if (demoModeIsAllowed)
          _buildDemoModeSwitch(
            ref: ref,
            localizations: localizations,
            isDemoMode: isDemoMode,
            isRegisterMode: isRegisterMode,
          ),
      ],
    );
  }

  // Lets the user explore the app with fake data and no real backend.
  // Switching it on swaps the auth/database services for in-memory fakes; the
  // form is then pre-filled by the `useEffect` in [build] so the user presses
  // Login exactly as in a real sign-in, and the fake auth service accepts it.
  Widget _buildDemoModeSwitch({
    required WidgetRef ref,
    required AppLocalizations localizations,
    required bool isDemoMode,
    required ValueNotifier<bool> isRegisterMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: const Icon(Icons.science_outlined),
        title: Text(localizations.demoMode),
        subtitle: Text(localizations.demoModeDescription),
        value: isDemoMode,
        onChanged: (bool enabled) async {
          // Demo mode logs in via the normal login form, never registration.
          if (enabled) {
            isRegisterMode.value = false;
          }
          await ref.read(demoModeProvider.notifier).set(enabled: enabled);
        },
      ),
    );
  }

  Widget _buildSubmitButton({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmController,
    required TextEditingController nameController,
    required ValueNotifier<bool> isRegisterMode,
    required AsyncValue<void> authState,
  }) {
    final bool isLoading = authState.isLoading;

    return FilledButton(
      onPressed: isLoading
          ? null
          : () {
              _submit(
                context: context,
                ref: ref,
                localizations: localizations,
                emailController: emailController,
                passwordController: passwordController,
                confirmController: confirmController,
                nameController: nameController,
                isRegisterMode: isRegisterMode,
              );
            },
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              isRegisterMode.value
                  ? localizations.register
                  : localizations.login,
            ),
    );
  }

  // Client-side validation is for UX only — the real enforcement happens
  // server-side in Appwrite.
  void _submit({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmController,
    required TextEditingController nameController,
    required ValueNotifier<bool> isRegisterMode,
  }) {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showErrorSnackbar(context, localizations.errorGeneric);
      return;
    }

    final LoginController controller =
        ref.read(loginControllerProvider.notifier);

    if (isRegisterMode.value) {
      if (password != confirmController.text) {
        showErrorSnackbar(context, localizations.passwordsDoNotMatch);
        return;
      }
      controller.register(
        email: email,
        password: password,
        name: nameController.text.trim(),
      );
    } else {
      controller.login(email: email, password: password);
    }
  }

  Widget _buildForgotPasswordButton({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required TextEditingController emailController,
  }) {
    return TextButton(
      onPressed: () {
        final String email = emailController.text.trim();
        if (email.isEmpty) {
          showErrorSnackbar(context, localizations.errorGeneric);
          return;
        }

        final LoginController controller =
            ref.read(loginControllerProvider.notifier);
        controller.sendPasswordReset(email);

        // Always show the neutral confirmation (see controller docs).
        showSnackbar(context, localizations.resetPasswordSent);
      },
      child: Text(localizations.forgotPassword),
    );
  }

  Widget _buildToggleModeButton(
    AppLocalizations localizations,
    ValueNotifier<bool> isRegisterMode,
  ) {
    return TextButton(
      onPressed: () {
        isRegisterMode.value = !isRegisterMode.value;
      },
      child: Text(
        isRegisterMode.value
            ? localizations.haveAccountLogin
            : localizations.noAccountRegister,
      ),
    );
  }

  // Discreet version number in the bottom-left corner.
  Widget _buildVersionLabel(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> versionState = ref.watch(appVersionProvider);
    final String versionText = versionState.value ?? '';

    return Positioned(
      left: 12,
      bottom: 12,
      child: Text(
        versionText.isEmpty ? '' : 'v$versionText',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).disabledColor),
      ),
    );
  }

  // Theme switch in the top-right corner. Before login the choice is
  // persisted to the local cache only; after login the settings row in
  // Appwrite takes over (see UserSettingsController).
  Widget _buildThemeSwitch(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    bool isDarkMode,
  ) {
    final IconData icon = isDarkMode ? Icons.light_mode : Icons.dark_mode;

    return Positioned(
      right: 12,
      top: 12,
      child: IconButton(
        icon: Icon(icon),
        tooltip: localizations.darkMode,
        onPressed: () {
          ref.read(themeServiceProvider.notifier).toggle();
        },
      ),
    );
  }
}
