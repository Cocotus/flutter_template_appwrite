import 'package:flutter/material.dart';

import 'package:flutter_template_appwrite/widgets/markdown_page.dart';

/// Help page rendering the bundled Markdown user manual.
///
/// The manual lives in `docs/help_<locale>.md` — replace its placeholder
/// content with your product documentation. Doc-only fixes ship with the
/// next release, not immediately; that trade-off is intentional (the help
/// always matches the running app version and works offline).
class HelpView extends StatelessWidget {
  /// Creates a [HelpView].
  const HelpView({super.key});

  /// GitHub edit URL of the manual, without the locale-specific file name.
  /// Replace `your-org/your-repo` with your repository.
  static const String editUrlBase =
      'https://github.com/your-org/your-repo/edit/main/docs/';

  @override
  Widget build(BuildContext context) {
    return const MarkdownPage(baseName: 'help', editUrlBase: editUrlBase);
  }
}
