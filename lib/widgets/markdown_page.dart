import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';

/// Renders a bundled Markdown document (from `docs/`) as a scrollable page.
///
/// The docs are normal repo files — versioned and reviewed together with
/// the code — and bundled as assets, so the shown content always matches
/// the running app version and works fully offline. Used by the Help page
/// (user manual).
class MarkdownPage extends StatelessWidget {
  /// Creates a [MarkdownPage] for `docs/<baseName>_<locale>.md`.
  const MarkdownPage({
    super.key,
    required this.baseName,
    this.editUrlBase,
  });

  /// Document base name, e.g. `help` for `docs/help_de.md` / `docs/help_en.md`.
  final String baseName;

  /// GitHub edit URL up to (excluding) the file name. When given, an
  /// "Edit on GitHub" link is shown above the document.
  final String? editUrlBase;

  // Locales the docs are translated to; anything else falls back to English.
  static const Set<String> _availableLocales = <String>{'de', 'en'};

  String _assetPath(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final String locale =
        _availableLocales.contains(languageCode) ? languageCode : 'en';
    return 'docs/${baseName}_$locale.md';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String assetPath = _assetPath(context);

    return FutureBuilder<String>(
      // rootBundle caches asset strings, so this future is cheap on
      // rebuilds and needs no extra state management.
      future: rootBundle.loadString(assetPath),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(localizations.errorGeneric));
        }
        if (snapshot.hasData == false) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (editUrlBase != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: TextButton.icon(
                        onPressed: () {
                          final String fileName = assetPath.split('/').last;
                          launchUrl(Uri.parse('$editUrlBase$fileName'));
                        },
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(localizations.editOnGithub),
                      ),
                    ),
                  ),
                Expanded(
                  child: Markdown(
                    data: snapshot.requireData,
                    selectable: true,
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    onTapLink: (String text, String? href, String title) {
                      if (href != null) {
                        launchUrl(Uri.parse(href));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
