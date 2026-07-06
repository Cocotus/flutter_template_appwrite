import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/services/app_version_service.dart';
import 'package:flutter_template_appwrite/views/shell/app_shell.dart';

/// About page: app name, version/build number, short description and links.
class AboutView extends ConsumerWidget {
  /// Creates an [AboutView].
  const AboutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final AsyncValue<String> versionState = ref.watch(appVersionProvider);

    // The version loads in a few milliseconds; a placeholder is enough.
    final String versionText = versionState.value ?? '…';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/logo.png', height: 96),
            const SizedBox(height: 24),
            Text(
              localizations.appTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('${localizations.version}: $versionText'),
            const SizedBox(height: 16),
            Text(
              localizations.aboutDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(githubUrl));
                  },
                  child: const Text('GitHub'),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('https://appwrite.io/docs'));
                  },
                  child: const Text('Appwrite Docs'),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('https://docs.flutter.dev'));
                  },
                  child: const Text('Flutter Docs'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
