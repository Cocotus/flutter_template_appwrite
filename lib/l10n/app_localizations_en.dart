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
      'This is your empty starter home page. Explore Settings, Profile and the developer Logs view — then start building.';

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
  String get version => 'Version';

  @override
  String get logs => 'Logs';

  @override
  String get developerMode => 'Developer mode';

  @override
  String get developerModeDescription =>
      'Shows the live log view in the sidebar';

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
