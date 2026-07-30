import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/models/language_option.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

part 'app_locale_provider.g.dart';

/// Provides the active app [Locale], backed by [UserSettings.languageCode].
///
/// `app.dart` passes this to `MaterialApp.router(locale: ...)`, so changing
/// the language in the settings view re-renders the whole app immediately.
@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  final UserSettings settings = ref.watch(userSettingsServiceProvider);

  final String languageCode = settings.languageCode;
  if (supportedLanguageCodes.contains(languageCode)) {
    return Locale(languageCode);
  }

  // Unknown code in the settings row (e.g. hand-edited): fall back to
  // English instead of crashing the localization lookup.
  return const Locale('en');
}
