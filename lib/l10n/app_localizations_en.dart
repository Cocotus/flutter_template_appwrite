// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Appwrite Template';

  @override
  String get welcome => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get homeIntro =>
      'Your starter home page: the first steps to make this template yours, and a live demo of the reusable base widgets.';

  @override
  String get homeGettingStarted => 'Getting started';

  @override
  String get homeStepRename =>
      'Rename the package: find & replace flutter_template_appwrite with your app name, then run flutter pub get.';

  @override
  String get homeStepBranding =>
      'Replace assets/images/logo.png (1024×1024) and run: dart run flutter_launcher_icons';

  @override
  String get homeStepColor =>
      'Change AppTheme.defaultSeedColor in lib/theme/app_theme.dart — the whole palette (incl. the sidebar) derives from it.';

  @override
  String get homeStepBackend =>
      'Connect Appwrite via config/app_config.json — or keep exploring in demo mode without a backend.';

  @override
  String get homeDemoTitle => 'Base widgets';

  @override
  String get homeDemoIntro =>
      'Reusable form elements from lib/widgets/ — use these instead of raw Material widgets so the design stays consistent. This form is wired to a Riverpod controller (home_controller.dart) with a Freezed state.';

  @override
  String get homeDemoRole => 'Role';

  @override
  String get homeDemoNotifications => 'Enable notifications';

  @override
  String get homeDemoSaved => 'Saved — this demo only updates in-memory state.';

  @override
  String get homeDemoReset => 'Reset';

  @override
  String get homeMoreInfo =>
      'The full tutorial lives in the README. The Help page in the sidebar shows how to ship a Markdown user manual with the app.';

  @override
  String get menuWorkspace => 'Workspace';

  @override
  String get menuAccount => 'Account';

  @override
  String get menuSystem => 'System';

  @override
  String get editOnGithub => 'Edit on GitHub';

  @override
  String get offlineHint =>
      'Server not reachable — demo mode still works offline';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get about => 'About';

  @override
  String get aboutDescription =>
      'A starter template built with Riverpod 3, Freezed, go_router, Talker and Appwrite Cloud — for Web, Windows and Linux.';

  @override
  String get help => 'Help';

  @override
  String get helpIntro =>
      'This page is a prepared placeholder. Link your product documentation here or replace it with embedded help content.';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get accentColor => 'Accent color';

  @override
  String get version => 'Version';

  @override
  String get logs => 'Logs';

  @override
  String get developerMode => 'Developer mode';

  @override
  String get developerModeDescription =>
      'Shows the live log view in the sidebar';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get demoModeDescription =>
      'Explore the app with sample data, no account needed';

  @override
  String get demoBadge => 'DEMO';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';

  @override
  String get register => 'Register';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get displayName => 'Display name';

  @override
  String get passwordsDoNotMatch => 'The passwords do not match';

  @override
  String get noAccountRegister => 'No account yet? Register';

  @override
  String get haveAccountLogin => 'Already have an account? Login';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPasswordSent =>
      'If this email is registered, a reset link has been sent';

  @override
  String get errorEmailAlreadyExists => 'This email is already registered';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';
}
