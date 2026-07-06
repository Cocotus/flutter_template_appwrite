import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/router/app_router.dart';
import 'package:flutter_template_appwrite/services/locale_service.dart';
import 'package:flutter_template_appwrite/services/theme_service.dart';

/// The root widget: wires the router, theming and localization together.
///
/// Everything here is reactive: when the user changes the theme or the
/// language in the settings, the corresponding provider updates and this
/// widget rebuilds the whole MaterialApp with the new configuration.
class App extends ConsumerWidget {
  /// Creates the [App].
  const App({super.key});

  /// The seed color both Material 3 color schemes derive from.
  ///
  /// Change this one value to re-brand the whole app's palette.
  static const Color seedColor = Color(0xFF3D5AFE);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final bool isDarkMode = ref.watch(themeServiceProvider);
    final Locale locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      routerConfig: router,
      // Material 3 theming: both schemes derive from one seed color.
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Localization: the active locale is backed by UserSettings.
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }
}
