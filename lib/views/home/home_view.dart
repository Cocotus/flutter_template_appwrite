import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';

/// The (intentionally empty) home page of the starter template.
///
/// This is where your app's real content starts. It greets the user and
/// points to the places worth exploring first.
class HomeView extends ConsumerWidget {
  /// Creates a [HomeView].
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UserSettings settings = ref.watch(userSettingsControllerProvider);

    final String greeting;
    if (settings.displayName.isEmpty) {
      greeting = localizations.welcome;
    } else {
      greeting = '${localizations.welcome}, ${settings.displayName}!';
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/images/logo.png', height: 96),
          const SizedBox(height: 24),
          Text(
            greeting,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            localizations.homeIntro,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
