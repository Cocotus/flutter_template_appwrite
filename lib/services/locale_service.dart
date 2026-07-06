import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'locale_service.g.dart';

/// The language codes this template ships translations for.
///
/// Must match the ARB files in `lib/l10n/` (app_en.arb, app_de.arb). Add a
/// new code here together with its ARB file to offer another language in
/// the settings dropdown.
const List<String> supportedLanguageCodes = <String>['en', 'de'];

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
