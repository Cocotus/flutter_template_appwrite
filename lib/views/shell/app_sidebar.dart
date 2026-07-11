import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/theme/app_theme.dart';
import 'package:flutter_template_appwrite/views/profile/profile_controller.dart';
import 'package:flutter_template_appwrite/widgets/user_avatar.dart';

// One entry in the sidebar menu; [branchIndex] must match the branch order
// in app_router.dart.
class _NavItem {
  const _NavItem({
    required this.branchIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final int branchIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

// A titled group of menu entries ("ARBEITSBEREICH", "SYSTEM", ...).
class _NavSection {
  const _NavSection({required this.label, required this.items});

  final String label;
  final List<_NavItem> items;
}

/// The full-height dark sidebar of the authenticated shell.
///
/// Modern admin-dashboard layout: app logo + name at the top, grouped menu
/// sections with small uppercase captions, and a pinned user card at the
/// bottom (avatar + name + email, tap opens the profile page) with a logout
/// icon button next to it.
///
/// The background is [AppTheme.brandSurface] — deep navy tinted with the
/// user's accent color — so the accent picker in the settings restyles the
/// sidebar too. The selected entry is a solid accent-colored pill.
class AppSidebar extends ConsumerWidget {
  /// Creates an [AppSidebar].
  const AppSidebar({
    super.key,
    required this.navigationShell,
    required this.isExpanded,
    required this.isToggleEnabled,
    required this.isLogsVisible,
  });

  /// The active branch navigator provided by `StatefulShellRoute`.
  final StatefulNavigationShell navigationShell;

  /// Whether the sidebar shows labels (true) or icons only (false).
  final bool isExpanded;

  /// Whether the collapse toggle is interactive (false on narrow layouts
  /// where the sidebar is forced collapsed).
  final bool isToggleEnabled;

  /// Whether the developer "Logs" entry is shown.
  final bool isLogsVisible;

  // Branch indices — must match the branch order in app_router.dart:
  // 0 home, 1 settings, 2 profile, 3 about, 4 help, 5 logs.
  static const int _profileBranchIndex = 2;

  static const double _expandedWidth = 248;
  static const double _collapsedWidth = 76;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UserSettings settings = ref.watch(userSettingsControllerProvider);
    final Color background =
        AppTheme.brandSurface(Color(settings.accentColorValue));

    final List<_NavSection> sections = <_NavSection>[
      _NavSection(
        label: localizations.menuWorkspace,
        items: <_NavItem>[
          _NavItem(
            branchIndex: 0,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: localizations.home,
          ),
        ],
      ),
      _NavSection(
        label: localizations.menuAccount,
        items: <_NavItem>[
          _NavItem(
            branchIndex: 2,
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: localizations.profile,
          ),
          _NavItem(
            branchIndex: 1,
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: localizations.settings,
          ),
        ],
      ),
      _NavSection(
        label: localizations.menuSystem,
        items: <_NavItem>[
          _NavItem(
            branchIndex: 4,
            icon: Icons.help_outline,
            selectedIcon: Icons.help,
            label: localizations.help,
          ),
          _NavItem(
            branchIndex: 3,
            icon: Icons.info_outline,
            selectedIcon: Icons.info,
            label: localizations.about,
          ),
          if (isLogsVisible)
            _NavItem(
              branchIndex: 5,
              icon: Icons.terminal_outlined,
              selectedIcon: Icons.terminal,
              label: localizations.logs,
            ),
        ],
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: isExpanded ? _expandedWidth : _collapsedWidth,
      color: background,
      child: Column(
        children: <Widget>[
          _buildBrandHeader(context, ref, localizations, settings),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              children: <Widget>[
                for (final _NavSection section in sections)
                  ..._buildSection(context, section),
              ],
            ),
          ),
          _buildUserCard(context, ref, localizations, settings),
        ],
      ),
    );
  }

  // Logo + app name at the top, with the collapse toggle. Collapsed mode
  // stacks logo and toggle vertically.
  Widget _buildBrandHeader(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    UserSettings settings,
  ) {
    final Widget toggleButton = IconButton(
      icon: Icon(isExpanded ? Icons.menu_open : Icons.menu),
      color: AppTheme.onBrandSurfaceMuted,
      disabledColor: AppTheme.onBrandSurfaceMuted.withValues(alpha: 0.3),
      tooltip: localizations.appTitle,
      onPressed: isToggleEnabled
          ? () {
              ref
                  .read(userSettingsControllerProvider.notifier)
                  .setSidebarCollapsed(!settings.sidebarCollapsed);
            }
          : null,
    );

    final Widget logo = Image.asset(
      'assets/images/logo.png',
      height: 30,
      semanticLabel: localizations.appTitle,
    );

    if (isExpanded == false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: <Widget>[logo, const SizedBox(height: 4), toggleButton],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 4, 10),
      child: Row(
        children: <Widget>[
          logo,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              localizations.appTitle,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.onBrandSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          toggleButton,
        ],
      ),
    );
  }

  // A section caption (expanded) or a subtle divider (collapsed), followed
  // by the section's menu entries.
  List<Widget> _buildSection(BuildContext context, _NavSection section) {
    final Widget caption;
    if (isExpanded) {
      caption = Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 16, 6),
        child: Text(
          section.label.toUpperCase(),
          style: TextStyle(
            color: AppTheme.onBrandSurfaceMuted.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      );
    } else {
      caption = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Divider(
          height: 1,
          color: Colors.white.withValues(alpha: 0.10),
        ),
      );
    }

    return <Widget>[
      caption,
      for (final _NavItem item in section.items) _buildItem(context, item),
    ];
  }

  Widget _buildItem(BuildContext context, _NavItem item) {
    final bool isSelected = navigationShell.currentIndex == item.branchIndex;
    final Color accent = Theme.of(context).colorScheme.primary;

    void onTap() {
      // Tapping the active entry pops that branch back to its root.
      navigationShell.goBranch(
        item.branchIndex,
        initialLocation: item.branchIndex == navigationShell.currentIndex,
      );
    }

    // onPrimary instead of plain white: in dark mode `primary` is a light
    // tone, where white icons/labels would be unreadable.
    final Color foreground = isSelected
        ? Theme.of(context).colorScheme.onPrimary
        : AppTheme.onBrandSurfaceMuted;

    final Widget tile = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: Colors.white.withValues(alpha: 0.06),
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: isExpanded ? 12 : 0),
          decoration: isSelected
              ? BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                size: 20,
                color: foreground,
              ),
              if (isExpanded) ...<Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: isExpanded ? tile : Tooltip(message: item.label, child: tile),
    );
  }

  // The pinned footer: avatar + name + email open the profile page; the
  // logout icon next to it signs the user out (via the profile controller,
  // so logging and error handling stay in one place — the router guard
  // then redirects to the login page).
  Widget _buildUserCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    UserSettings settings,
  ) {
    final String email =
        ref.watch(currentUserProvider).value?.email ?? '';
    final String displayName =
        settings.displayName.isEmpty ? localizations.profile : settings.displayName;

    final AsyncValue<void> logoutState = ref.watch(profileControllerProvider);
    final VoidCallback? onLogoutPressed = logoutState.isLoading
        ? null
        : () {
            ref.read(profileControllerProvider.notifier).logout();
          };

    void openProfile() {
      navigationShell.goBranch(_profileBranchIndex);
    }

    final Widget logoutButton = IconButton(
      onPressed: onLogoutPressed,
      tooltip: localizations.logout,
      color: AppTheme.onBrandSurfaceMuted,
      iconSize: 20,
      icon: const Icon(Icons.logout),
    );

    final BoxDecoration decoration = BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
      ),
    );

    if (isExpanded == false) {
      return Container(
        decoration: decoration,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            Tooltip(
              message: localizations.profile,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: openProfile,
                child: UserAvatar(displayName: settings.displayName, radius: 16),
              ),
            ),
            const SizedBox(height: 4),
            logoutButton,
          ],
        ),
      );
    }

    return Container(
      decoration: decoration,
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: openProfile,
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.white.withValues(alpha: 0.06),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: <Widget>[
                    UserAvatar(displayName: settings.displayName, radius: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            displayName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.onBrandSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (email.isNotEmpty)
                            Text(
                              email,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.onBrandSurfaceMuted,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          logoutButton,
        ],
      ),
    );
  }
}
