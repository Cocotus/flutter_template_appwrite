import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/demo_mode_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/views/shell/app_sidebar.dart';

/// The URL opened by the "GitHub" link in the header.
/// Replace with your own repository URL.
const String githubUrl = 'https://github.com/your-org/your-repo';

/// The authenticated desktop/web shell in a modern admin-dashboard layout:
/// a full-height dark sidebar on the left ([AppSidebar]) and, on the right,
/// a light page header above the routed content area.
///
/// Receives the [StatefulNavigationShell] from `StatefulShellRoute` so each
/// sidebar entry switches to its own persistent navigator branch (tabs keep
/// their state, browser URL and back button stay correct).
class AppShell extends ConsumerWidget {
  /// Creates an [AppShell] around the given [navigationShell].
  const AppShell({super.key, required this.navigationShell});

  /// The active branch navigator provided by `StatefulShellRoute`.
  final StatefulNavigationShell navigationShell;

  // Below this width the sidebar collapses automatically.
  static const double _wideLayoutBreakpoint = 1100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UserSettings settings = ref.watch(userSettingsControllerProvider);
    final bool isDemoMode = ref.watch(demoModeProvider);

    // The Logs entry is an opt-in developer feature; in debug builds it is
    // always available.
    final bool isLogsVisible = settings.developerMode || kDebugMode;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Auto-collapse on narrow windows; on wide windows the user's
          // manual choice (persisted in UserSettings) wins.
          final bool isWideLayout =
              constraints.maxWidth >= _wideLayoutBreakpoint;
          final bool isSidebarExpanded =
              isWideLayout && settings.sidebarCollapsed == false;

          return Row(
            children: <Widget>[
              AppSidebar(
                navigationShell: navigationShell,
                isExpanded: isSidebarExpanded,
                isToggleEnabled: isWideLayout,
                isLogsVisible: isLogsVisible,
              ),
              // Right side: light page header + the routed page content.
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildPageHeader(context, localizations, isDemoMode),
                    Expanded(child: navigationShell),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // The light header bar above the content area: current page title (with
  // an optional subtitle), the demo badge and a GitHub link. Unlike the
  // sidebar it follows the light/dark theme mode.
  Widget _buildPageHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDemoMode,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isDark = scheme.brightness == Brightness.dark;

    // Title/subtitle per branch — must match the branch order in
    // app_router.dart: 0 home, 1 settings, 2 profile, 3 about, 4 help,
    // 5 logs.
    final List<String> titles = <String>[
      localizations.home,
      localizations.settings,
      localizations.profile,
      localizations.about,
      localizations.help,
      localizations.logs,
    ];
    final int currentIndex = navigationShell.currentIndex;
    final String title =
        currentIndex < titles.length ? titles[currentIndex] : '';
    final String? subtitle = currentIndex == 0 ? localizations.homeIntro : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? scheme.surfaceContainerLow : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Unmissable reminder that the app is showing fake data.
                    if (isDemoMode) ...<Widget>[
                      const SizedBox(width: 12),
                      Chip(
                        label: Text(localizations.demoBadge),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: scheme.tertiaryContainer,
                        labelStyle: TextStyle(
                          color: scheme.onTertiaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {
              // Fire-and-forget: opening the browser needs no result.
              launchUrl(Uri.parse(githubUrl));
            },
            style: TextButton.styleFrom(
              foregroundColor: scheme.onSurfaceVariant,
            ),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('GitHub'),
          ),
        ],
      ),
    );
  }
}
