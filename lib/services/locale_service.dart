import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'locale_service.g.dart';

/// One selectable entry in the settings language dropdown.
///
/// [englishName] is always the English name of the language — never its
/// endonym — so the dropdown itself stays readable no matter which language
/// is currently active (a user who accidentally switches into a script they
/// can't read can still find their way back to English).
class LanguageOption {
  /// Creates a [LanguageOption].
  const LanguageOption({
    required this.code,
    required this.flagEmoji,
    required this.englishName,
  });

  /// The ARB/locale code, e.g. `'en'`, `'de'`, `'zh'`.
  final String code;

  /// A regional-indicator flag emoji shown as the dropdown entry's icon.
  final String flagEmoji;

  /// The language's English name, e.g. `'German'`, `'Chinese (Simplified)'`.
  final String englishName;
}

/// The languages this template ships translations for.
///
/// Must match the ARB files in `lib/l10n/` (app_en.arb, app_<code>.arb, ...).
/// Add a new entry here together with its ARB file to offer another
/// language in the settings dropdown.
const List<LanguageOption> languageOptions = <LanguageOption>[
  LanguageOption(code: 'en', flagEmoji: '🇬🇧', englishName: 'English'),
  LanguageOption(code: 'de', flagEmoji: '🇩🇪', englishName: 'German'),
  LanguageOption(code: 'es', flagEmoji: '🇪🇸', englishName: 'Spanish'),
  LanguageOption(code: 'fr', flagEmoji: '🇫🇷', englishName: 'French'),
  LanguageOption(code: 'pt', flagEmoji: '🇧🇷', englishName: 'Portuguese'),
  LanguageOption(code: 'it', flagEmoji: '🇮🇹', englishName: 'Italian'),
  LanguageOption(code: 'nl', flagEmoji: '🇳🇱', englishName: 'Dutch'),
  LanguageOption(code: 'pl', flagEmoji: '🇵🇱', englishName: 'Polish'),
  LanguageOption(code: 'ru', flagEmoji: '🇷🇺', englishName: 'Russian'),
  LanguageOption(code: 'uk', flagEmoji: '🇺🇦', englishName: 'Ukrainian'),
  LanguageOption(code: 'tr', flagEmoji: '🇹🇷', englishName: 'Turkish'),
  LanguageOption(code: 'sv', flagEmoji: '🇸🇪', englishName: 'Swedish'),
  LanguageOption(
    code: 'zh',
    flagEmoji: '🇨🇳',
    englishName: 'Chinese (Simplified)',
  ),
  LanguageOption(code: 'ja', flagEmoji: '🇯🇵', englishName: 'Japanese'),
  LanguageOption(code: 'ko', flagEmoji: '🇰🇷', englishName: 'Korean'),
  LanguageOption(code: 'vi', flagEmoji: '🇻🇳', englishName: 'Vietnamese'),
  LanguageOption(code: 'id', flagEmoji: '🇮🇩', englishName: 'Indonesian'),
  LanguageOption(code: 'th', flagEmoji: '🇹🇭', englishName: 'Thai'),
  LanguageOption(code: 'ar', flagEmoji: '🇸🇦', englishName: 'Arabic'),
  LanguageOption(code: 'hi', flagEmoji: '🇮🇳', englishName: 'Hindi'),
];

/// The language codes this template ships translations for.
///
/// Derived from [languageOptions] so the two lists can never drift apart.
final List<String> supportedLanguageCodes = <String>[
  for (final LanguageOption option in languageOptions) option.code,
];

/// Provides the active app [Locale], backed by [UserSettings.languageCode].
///
/// `app.dart` passes this to `MaterialApp.router(locale: ...)`, so changing
/// the language in the settings view re-renders the whole app immediately.
@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  final UserSettings settings = ref.watch(userSettingsControllerProvider);

  final String languageCode = settings.languageCode;
  if (supportedLanguageCodes.contains(languageCode)) {
    return Locale(languageCode);
  }

  // Unknown code in the settings row (e.g. hand-edited): fall back to
  // English instead of crashing the localization lookup.
  return const Locale('en');
}
