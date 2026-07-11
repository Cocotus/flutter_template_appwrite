// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Flutter Appwrite Template';

  @override
  String get welcome => 'Willkommen';

  @override
  String get home => 'Start';

  @override
  String get homeIntro =>
      'Deine Template-Startseite: die ersten Schritte zur eigenen App und eine Live-Demo der wiederverwendbaren Basis-Widgets.';

  @override
  String get homeGettingStarted => 'Erste Schritte';

  @override
  String get homeStepRename =>
      'Paket umbenennen: flutter_template_appwrite global durch deinen App-Namen ersetzen, dann flutter pub get ausführen.';

  @override
  String get homeStepBranding =>
      'assets/images/logo.png ersetzen (1024×1024) und ausführen: dart run flutter_launcher_icons';

  @override
  String get homeStepColor =>
      'AppTheme.defaultSeedColor in lib/theme/app_theme.dart ändern — die gesamte Palette (inkl. Sidebar) leitet sich daraus ab.';

  @override
  String get homeStepBackend =>
      'Appwrite über config/app_config.json anbinden — oder ohne Backend im Demomodus weiter erkunden.';

  @override
  String get homeDemoTitle => 'Basis-Widgets';

  @override
  String get homeDemoIntro =>
      'Wiederverwendbare Formular-Elemente aus lib/widgets/ — nutze diese statt roher Material-Widgets, damit das Design konsistent bleibt. Das Formular hängt an einem Riverpod-Controller (home_controller.dart) mit Freezed-State.';

  @override
  String get homeDemoRole => 'Rolle';

  @override
  String get homeDemoNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get homeDemoSaved =>
      'Gespeichert — diese Demo ändert nur In-Memory-State.';

  @override
  String get homeDemoReset => 'Zurücksetzen';

  @override
  String get homeMoreInfo =>
      'Das vollständige Tutorial steht im README. Die Hilfe-Seite in der Sidebar zeigt, wie ein Markdown-Handbuch mit der App ausgeliefert wird.';

  @override
  String get menuWorkspace => 'Arbeitsbereich';

  @override
  String get menuAccount => 'Konto';

  @override
  String get menuSystem => 'System';

  @override
  String get editOnGithub => 'Auf GitHub bearbeiten';

  @override
  String get offlineHint =>
      'Server nicht erreichbar — der Demomodus funktioniert auch offline';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get about => 'Über';

  @override
  String get aboutDescription =>
      'Ein Starter-Template mit Riverpod 3, Freezed, go_router, Talker und Appwrite Cloud — für Web, Windows und Linux.';

  @override
  String get help => 'Hilfe';

  @override
  String get helpIntro =>
      'Diese Seite ist ein vorbereiteter Platzhalter. Verlinke hier deine Produktdokumentation oder ersetze sie durch eingebettete Hilfe-Inhalte.';

  @override
  String get theme => 'Design';

  @override
  String get language => 'Sprache';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String get version => 'Version';

  @override
  String get logs => 'Logs';

  @override
  String get developerMode => 'Entwicklermodus';

  @override
  String get developerModeDescription =>
      'Zeigt die Live-Logansicht in der Seitenleiste';

  @override
  String get demoMode => 'Demomodus';

  @override
  String get demoModeDescription =>
      'App mit Beispieldaten erkunden, ohne Konto';

  @override
  String get demoBadge => 'DEMO';

  @override
  String get save => 'Speichern';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get register => 'Registrieren';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get displayName => 'Anzeigename';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get noAccountRegister => 'Noch kein Konto? Registrieren';

  @override
  String get haveAccountLogin => 'Schon ein Konto? Anmelden';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get resetPasswordSent =>
      'Falls diese E-Mail registriert ist, wurde ein Link zum Zurücksetzen gesendet';

  @override
  String get errorEmailAlreadyExists => 'Diese E-Mail ist bereits registriert';

  @override
  String get errorInvalidCredentials => 'E-Mail oder Passwort ist ungültig';

  @override
  String get errorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';
}
