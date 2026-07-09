import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/demo_mode_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/theme/app_theme.dart';
import 'package:flutter_template_appwrite/views/profile/profile_controller.dart';
import 'package:flutter_template_appwrite/widgets/user_avatar.dart';

/// The URL opened by the "GitHub" link in the header.
/// Replace with your own repository URL.
const String githubUrl = 'https://github.com/your-org/your-repo';

/// The authenticated desktop/web shell: top header bar, collapsible left
/// sidebar (NavigationRail) and the routed content area on the right.
///
/// Receives the [StatefulNavigationShell] from `StatefulShellRoute` so each
/// sidebar entry switches to its own persistent navigator branch (tabs keep
/// their state, browser URL and back button stay correct).
class AppShell extends ConsumerWidget {
  /// Creates an [AppShell] around the given [navigationShell].
  const AppShell({super.key, required this.navigationShell});

  /// The active branch navigator provided by `StatefulShellRoute`.
  final StatefulNavigationShell navigationShell;

  // Branch indices — must match the branch order in app_router.dart:
  // 0 home, 1 settings, 2 profile, 3 about, 4 help, 5 logs.
  static const int _homeBranchIndex = 0;
  static const int _profileBranchIndex = 2;
  static const int _helpBranchIndex = 4;

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
      appBar: _buildHeaderBar(context, localizations, isDemoMode),
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
              _buildSidebar(
                context: context,
                ref: ref,
                localizations: localizations,
                settings: settings,
                isExpanded: isSidebarExpanded,
                isToggleEnabled: isWideLayout,
                isLogsVisible: isLogsVisible,
              ),
              // No divider needed: the dark sidebar forms its own edge
              // against the content area (see AppTheme.brandSurface).
              // The routed page content.
              Expanded(child: navigationShell),
            ],
          );
        },
      ),
    );
  }

  // Top header: logo/title on the left, a few static links on the right.
  PreferredSizeWidget _buildHeaderBar(
    BuildContext context,
    AppLocalizations localizations,
    bool isDemoMode,
  ) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            height: 28,
            semanticLabel: localizations.appTitle,
          ),
          const SizedBox(width: 12),
          Text(localizations.appTitle),
          // Unmissable reminder that the app is showing fake data.
          if (isDemoMode) ...<Widget>[
            const SizedBox(width: 12),
            Chip(
              label: Text(localizations.demoBadge),
              visualDensity: VisualDensity.compact,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
      actions: <Widget>[
        _buildHeaderLink(
          label: localizations.home,
          onPressed: () {
            navigationShell.goBranch(_homeBranchIndex);
          },
        ),
        _buildHeaderLink(
          label: localizations.help,
          onPressed: () {
            navigationShell.goBranch(_helpBranchIndex);
          },
        ),
        _buildHeaderLink(
          label: 'GitHub',
          onPressed: () {
            // Fire-and-forget: opening the browser needs no result.
            launchUrl(Uri.parse(githubUrl));
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // A flat text link in the dark header bar. The explicit white foreground
  // is needed because TextButton defaults to the accent color, which is
  // unreadable on the navy brand surface.
  Widget _buildHeaderLink({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.onBrandSurface,
      ),
      child: Text(label),
    );
  }

  Widget _buildSidebar({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required UserSettings settings,
    required bool isExpanded,
    required bool isToggleEnabled,
    required bool isLogsVisible,
  }) {
    // The destination list must line up with the branch indices, so the
    // gated Logs entry is only ever appended at the end.
    final List<NavigationRailDestination> destinations =
        <NavigationRailDestination>[
      NavigationRailDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: Text(localizations.home),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: Text(localizations.settings),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(localizations.profile),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.info_outline),
        selectedIcon: const Icon(Icons.info),
        label: Text(localizations.about),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.help_outline),
        selectedIcon: const Icon(Icons.help),
        label: Text(localizations.help),
      ),
      if (isLogsVisible)
        NavigationRailDestination(
          icon: const Icon(Icons.terminal_outlined),
          selectedIcon: const Icon(Icons.terminal),
          label: Text(localizations.logs),
        ),
    ];

    // When the Logs branch is active but its entry is hidden (possible in
    // debug via deep link), show no selection instead of crashing.
    final int currentIndex = navigationShell.currentIndex;
    final int? selectedIndex =
        currentIndex < destinations.length ? currentIndex : null;

    return NavigationRail(
      extended: isExpanded,
      labelType: isExpanded
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        // Tapping the active entry pops that branch back to its root.
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      leading: _buildSidebarHeader(
        context: context,
        ref: ref,
        localizations: localizations,
        settings: settings,
        isExpanded: isExpanded,
        isToggleEnabled: isToggleEnabled,
      ),
      // Pinned to the bottom of the rail via Expanded + Align.
      trailing: _buildSidebarFooter(
        context: context,
        ref: ref,
        localizations: localizations,
        isExpanded: isExpanded,
      ),
      destinations: destinations,
    );
  }

  // Logout button pinned at the bottom of the sidebar. Reuses the profile
  // controller's logout action so logging and error handling stay in one
  // place; the router guard redirects to the login page on success.
  Widget _buildSidebarFooter({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required bool isExpanded,
  }) {
    final AsyncValue<void> logoutState = ref.watch(profileControllerProvider);
    final bool isLoggingOut = logoutState.isLoading;

    final VoidCallback? onLogoutPressed = isLoggingOut
        ? null
        : () {
            ref.read(profileControllerProvider.notifier).logout();
          };

    // Expanded sidebar: full-width button with icon + label.
    // Collapsed sidebar: icon-only button with a tooltip.
    final Widget logoutButton;
    if (isExpanded) {
      logoutButton = TextButton.icon(
        onPressed: onLogoutPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.onBrandSurfaceMuted,
        ),
        icon: const Icon(Icons.logout),
        label: Text(localizations.logout),
      );
    } else {
      logoutButton = IconButton(
        onPressed: onLogoutPressed,
        tooltip: localizations.logout,
        color: AppTheme.onBrandSurfaceMuted,
        icon: const Icon(Icons.logout),
      );
    }

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: logoutButton,
        ),
      ),
    );
  }

  // Collapse toggle + avatar at the top of the sidebar. The avatar opens
  // the profile page.
  Widget _buildSidebarHeader({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required UserSettings settings,
    required bool isExpanded,
    required bool isToggleEnabled,
  }) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        IconButton(
          icon: Icon(isExpanded ? Icons.menu_open : Icons.menu),
          // Explicit white: the sidebar is navy in both theme modes.
          color: AppTheme.onBrandSurface,
          disabledColor: AppTheme.onBrandSurfaceMuted,
          tooltip: localizations.appTitle,
          // Disabled on narrow layouts where the rail is forced collapsed.
          onPressed: isToggleEnabled
              ? () {
                  final UserSettingsController settingsController =
                      ref.read(userSettingsControllerProvider.notifier);
                  settingsController
                      .setSidebarCollapsed(!settings.sidebarCollapsed);
                }
              : null,
        ),
        const SizedBox(height: 8),
        Tooltip(
          message: localizations.profile,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              navigationShell.goBranch(_profileBranchIndex);
            },
            child: UserAvatar(displayName: settings.displayName),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
