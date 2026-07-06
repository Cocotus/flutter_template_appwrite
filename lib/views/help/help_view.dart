import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';

/// Help page — a prepared placeholder.
///
/// Point [documentationUrl] at your real product documentation, or replace
/// this page's body with embedded help content.
class HelpView extends StatelessWidget {
  /// Creates a [HelpView].
  const HelpView({super.key});

  /// The external documentation linked from this page.
  static const String documentationUrl =
      'https://github.com/your-org/your-repo#readme';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.help_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              localizations.help,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              localizations.helpIntro,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: () {
                launchUrl(Uri.parse(documentationUrl));
              },
              icon: const Icon(Icons.open_in_new),
              label: Text(localizations.help),
            ),
          ],
        ),
      ),
    );
  }
}
