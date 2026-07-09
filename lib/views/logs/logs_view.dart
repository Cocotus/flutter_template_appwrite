import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';

/// Live log view embedding Talker's ready-made [TalkerScreen].
///
/// Shows every log event of the running app (app logs, Riverpod state
/// changes, route changes, caught errors) with filtering, copy and share.
/// Reached via the "Logs" sidebar entry, which is visible when the user
/// enables developer mode in the settings (always visible in debug builds).
class LogsView extends ConsumerWidget {
  /// Creates a [LogsView].
  const LogsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final Talker talker = ref.watch(loggerServiceProvider).talker;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TalkerScreen(
      talker: talker,
      appBarTitle: localizations.logs,
      // Match the app's theme instead of Talker's default dark palette, so
      // the log view fits light/dark mode and the chosen accent color. Only
      // the surface/text/card colors are themed; the per-level log colors
      // (error red, info blue, ...) keep Talker's defaults for readability.
      theme: TalkerScreenTheme(
        backgroundColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
        cardColor: colorScheme.surfaceContainerHighest,
      ),
      // The shell already provides the app-level chrome; TalkerScreen
      // brings its own AppBar with filter/actions, which is what we want
      // inside the content area.
    );
  }
}
