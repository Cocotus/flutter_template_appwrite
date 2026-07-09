import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/router/app_router.dart';
import 'package:flutter_template_appwrite/services/locale_service.dart';
import 'package:flutter_template_appwrite/services/theme_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/theme/app_theme.dart';

/// The root widget: wires the router, theming and localization together.
///
/// Everything here is reactive: when the user changes the theme or the
/// language in the settings, the corresponding provider updates and this
/// widget rebuilds the whole MaterialApp with the new configuration.
class App extends ConsumerWidget {
  /// Creates the [App].
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final bool isDarkMode = ref.watch(themeServiceProvider);
    final Locale locale = ref.watch(appLocaleProvider);

    // The accent (seed) color is a per-user setting; watching it here
    // re-themes the whole app live when the user picks a new color.
    final UserSettings settings = ref.watch(userSettingsControllerProvider);
    final Color seedColor = Color(settings.accentColorValue);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      routerConfig: router,
      // Material 3 theming: both schemes derive from the user's seed color.
      theme: AppTheme.build(
        brightness: Brightness.light,
        seedColor: seedColor,
      ),
      darkTheme: AppTheme.build(
        brightness: Brightness.dark,
        seedColor: seedColor,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Localization: the active locale is backed by UserSettings.
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
