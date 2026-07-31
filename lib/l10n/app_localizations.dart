import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// The application title shown in the header and on login
  ///
  /// In en, this message translates to:
  /// **'Flutter Appwrite Template'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @homeIntro.
  ///
  /// In en, this message translates to:
  /// **'Your starter home page: the first steps to make this template yours, and a live demo of the reusable base widgets.'**
  String get homeIntro;

  /// No description provided for @homeGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get homeGettingStarted;

  /// No description provided for @homeStepRename.
  ///
  /// In en, this message translates to:
  /// **'Rename the package: find & replace flutter_template_appwrite with your app name, then run flutter pub get.'**
  String get homeStepRename;

  /// No description provided for @homeStepBranding.
  ///
  /// In en, this message translates to:
  /// **'Replace assets/images/logo.png (1024×1024) and run: dart run flutter_launcher_icons'**
  String get homeStepBranding;

  /// No description provided for @homeStepColor.
  ///
  /// In en, this message translates to:
  /// **'Change AppTheme.defaultSeedColor in lib/theme/app_theme.dart — the whole palette (incl. the sidebar) derives from it.'**
  String get homeStepColor;

  /// No description provided for @homeStepBackend.
  ///
  /// In en, this message translates to:
  /// **'Connect Appwrite via config/app_config.json — or keep exploring in demo mode without a backend.'**
  String get homeStepBackend;

  /// No description provided for @homeStepHelp.
  ///
  /// In en, this message translates to:
  /// **'See the Help page in the sidebar for the full post-clone setup checklist (Appwrite, GitHub Actions secrets, GitHub Pages hosting).'**
  String get homeStepHelp;

  /// No description provided for @homeDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Base widgets'**
  String get homeDemoTitle;

  /// No description provided for @homeDemoIntro.
  ///
  /// In en, this message translates to:
  /// **'Reusable form elements from lib/widgets/ — use these instead of raw Material widgets so the design stays consistent. This form is wired to a Riverpod controller (home_controller.dart) with a Freezed state.'**
  String get homeDemoIntro;

  /// No description provided for @homeDemoRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get homeDemoRole;

  /// No description provided for @homeDemoNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get homeDemoNotifications;

  /// No description provided for @homeDemoSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved — this demo only updates in-memory state.'**
  String get homeDemoSaved;

  /// No description provided for @homeDemoReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get homeDemoReset;

  /// No description provided for @homeApiDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'External REST API'**
  String get homeApiDemoTitle;

  /// No description provided for @homeApiDemoIntro.
  ///
  /// In en, this message translates to:
  /// **'Fetches example.com and shows the page title it finds — a small demo of calling an external REST API/web page, and of the CORS wall Flutter Web specifically hits doing so. See functions/web-api-proxy and README §12.'**
  String get homeApiDemoIntro;

  /// No description provided for @homeApiDemoResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Page title:'**
  String get homeApiDemoResultLabel;

  /// No description provided for @homeApiDemoWebSetupNeeded.
  ///
  /// In en, this message translates to:
  /// **'This demo needs a small server-side proxy to run on Flutter Web, because browsers block direct calls to sites with no CORS support of their own. See README §12 for the five-minute setup — desktop and mobile builds already work here with no setup at all.'**
  String get homeApiDemoWebSetupNeeded;

  /// No description provided for @homeMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'The full tutorial lives in the README. The Help page in the sidebar shows how to ship a Markdown user manual with the app.'**
  String get homeMoreInfo;

  /// Sidebar section caption for the main working area
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get menuWorkspace;

  /// Sidebar section caption for profile and settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get menuAccount;

  /// Sidebar section caption for about, help and logs
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get menuSystem;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// Shown on the profile page when the user has a premium entitlement
  ///
  /// In en, this message translates to:
  /// **'Premium unlocked'**
  String get premiumActive;

  /// No description provided for @premiumUpsell.
  ///
  /// In en, this message translates to:
  /// **'Unlock premium support and future premium features with a one-time purchase.'**
  String get premiumUpsell;

  /// No description provided for @premiumBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy Premium'**
  String get premiumBuy;

  /// Button that re-reads the entitlement after returning from the checkout
  ///
  /// In en, this message translates to:
  /// **'Check purchase'**
  String get premiumCheckPurchase;

  /// No description provided for @premiumLocked.
  ///
  /// In en, this message translates to:
  /// **'This feature requires Premium.'**
  String get premiumLocked;

  /// No description provided for @premiumCheckoutMissing.
  ///
  /// In en, this message translates to:
  /// **'Checkout is not configured yet — set PREMIUM_CHECKOUT_URL in config/app_config.json.'**
  String get premiumCheckoutMissing;

  /// Link on Markdown doc pages to edit the file on GitHub
  ///
  /// In en, this message translates to:
  /// **'Edit on GitHub'**
  String get editOnGithub;

  /// Shown on the login page when the Appwrite backend cannot be reached
  ///
  /// In en, this message translates to:
  /// **'Server not reachable — demo mode still works offline'**
  String get offlineHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A starter template built with Riverpod 3, Freezed, go_router, Talker and Appwrite Cloud — for Web, Windows and Linux.'**
  String get aboutDescription;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @helpIntro.
  ///
  /// In en, this message translates to:
  /// **'This page is a prepared placeholder. Link your product documentation here or replace it with embedded help content.'**
  String get helpIntro;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// Settings label for the seed color picker
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @developerMode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get developerMode;

  /// No description provided for @developerModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Shows the live log view in the sidebar'**
  String get developerModeDescription;

  /// Label of the login-page switch that enables fake data
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoMode;

  /// No description provided for @demoModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore the app with sample data, no account needed'**
  String get demoModeDescription;

  /// Header badge shown while the app runs on fake demo data
  ///
  /// In en, this message translates to:
  /// **'DEMO'**
  String get demoBadge;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Register'**
  String get noAccountRegister;

  /// No description provided for @haveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get haveAccountLogin;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If this email is registered, a reset link has been sent'**
  String get resetPasswordSent;

  /// No description provided for @errorEmailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get errorEmailAlreadyExists;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredentials;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @settingsNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced with the cloud yet.'**
  String get settingsNeverSynced;

  /// No description provided for @settingsLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {timestamp}'**
  String settingsLastSynced(String timestamp);

  /// No description provided for @settingsSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Your changes are saved on this device.'**
  String get settingsSyncFailed;

  /// No description provided for @settingsUserData.
  ///
  /// In en, this message translates to:
  /// **'My data'**
  String get settingsUserData;

  /// No description provided for @settingsUserDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Everything you have created in this app is stored on this device.'**
  String get settingsUserDataDescription;

  /// No description provided for @settingsUserDataCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No entries} =1{1 entry} other{{count} entries}}'**
  String settingsUserDataCount(int count);

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get settingsExport;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import from JSON'**
  String get settingsImport;

  /// No description provided for @settingsExportDone.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path}'**
  String settingsExportDone(String path);

  /// No description provided for @settingsImportDone.
  ///
  /// In en, this message translates to:
  /// **'Import complete'**
  String get settingsImportDone;

  /// No description provided for @settingsImportFailed.
  ///
  /// In en, this message translates to:
  /// **'That file is not a backup of this app.'**
  String get settingsImportFailed;

  /// No description provided for @settingsClearData.
  ///
  /// In en, this message translates to:
  /// **'Delete all my data'**
  String get settingsClearData;

  /// No description provided for @settingsClearDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete everything you have created in this app? This cannot be undone.'**
  String get settingsClearDataConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
