import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/user_settings_service.dart';
import 'package:flutter_template_appwrite/views/home/home_controller.dart';
import 'package:flutter_template_appwrite/views/home/home_state.dart';
import 'package:flutter_template_appwrite/widgets/app_snackbar.dart';
import 'package:flutter_template_appwrite/widgets/buttons/app_buttons.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_dropdown_field.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_switch_tile.dart';
import 'package:flutter_template_appwrite/widgets/forms/app_text_field.dart';
import 'package:flutter_template_appwrite/widgets/section_header.dart';

/// The home page of the starter template: getting-started steps plus a
/// live demo of the reusable base widgets from `lib/widgets/`.
///
/// The demo section is intentionally a fully wired mini-feature — view,
/// `@riverpod` controller ([HomeController]) and Freezed state
/// ([HomeDemoState]) — so a new developer sees the template's standard
/// pattern working end to end. Replace this view (and its controller/state)
/// with your app's real content when you get going.
class HomeView extends HookConsumerWidget {
  /// Creates a [HomeView].
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UserSettings settings = ref.watch(userSettingsControllerProvider);

    final AsyncValue<HomeDemoState> demoState =
        ref.watch(homeControllerProvider);
    final HomeDemoState demo = demoState.value ?? const HomeDemoState();
    final bool isSaving = demoState.isLoading;
    final HomeController controller = ref.read(homeControllerProvider.notifier);

    // Widget-scoped controller for the demo text field (hook-managed).
    final TextEditingController nameController =
        useTextEditingController(text: demo.displayName);

    final String greeting;
    if (settings.displayName.isEmpty) {
      greeting = localizations.welcome;
    } else {
      greeting = '${localizations.welcome}, ${settings.displayName}!';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SectionHeader.page(
                title: greeting,
                subtitle: localizations.homeIntro,
              ),
              const SizedBox(height: 12),
              _buildGettingStartedCard(context, localizations),
              const SizedBox(height: 16),
              _buildWidgetDemoCard(
                context: context,
                localizations: localizations,
                demo: demo,
                isSaving: isSaving,
                controller: controller,
                nameController: nameController,
              ),
              const SizedBox(height: 16),
              Text(
                localizations.homeMoreInfo,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // The four steps that turn the template into your own app.
  Widget _buildGettingStartedCard(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final List<String> steps = <String>[
      localizations.homeStepRename,
      localizations.homeStepBranding,
      localizations.homeStepColor,
      localizations.homeStepBackend,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(title: localizations.homeGettingStarted),
            for (int stepIndex = 0; stepIndex < steps.length; stepIndex++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  child: Text(
                    '${stepIndex + 1}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                title: Text(steps[stepIndex]),
              ),
          ],
        ),
      ),
    );
  }

  // Live demo of the base widgets, wired to [HomeController] so the
  // standard view/controller/state pattern is visible in action.
  Widget _buildWidgetDemoCard({
    required BuildContext context,
    required AppLocalizations localizations,
    required HomeDemoState demo,
    required bool isSaving,
    required HomeController controller,
    required TextEditingController nameController,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SectionHeader(
              title: localizations.homeDemoTitle,
              subtitle: localizations.homeDemoIntro,
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: nameController,
              label: localizations.displayName,
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            AppDropdownField<String>(
              label: localizations.homeDemoRole,
              icon: Icons.workspaces_outlined,
              value: demo.role,
              // Demo data — real apps would localize or load these values.
              options: const <AppDropdownOption<String>>[
                AppDropdownOption<String>(value: 'admin', label: 'Admin'),
                AppDropdownOption<String>(value: 'user', label: 'User'),
                AppDropdownOption<String>(value: 'guest', label: 'Guest'),
              ],
              onChanged: isSaving
                  ? null
                  : (String? newRole) {
                      if (newRole != null) {
                        controller.setRole(newRole);
                      }
                    },
            ),
            AppSwitchTile(
              contentPadding: EdgeInsets.zero,
              icon: Icons.notifications_outlined,
              title: localizations.homeDemoNotifications,
              value: demo.notificationsEnabled,
              onChanged: isSaving
                  ? null
                  : (bool enabled) {
                      controller.setNotificationsEnabled(enabled: enabled);
                    },
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                AppPrimaryButton(
                  label: localizations.save,
                  icon: Icons.save_outlined,
                  isLoading: isSaving,
                  onPressed: () async {
                    await controller.save(nameController.text.trim());
                    if (context.mounted) {
                      showSnackbar(context, localizations.homeDemoSaved);
                    }
                  },
                ),
                const SizedBox(width: 12),
                AppSecondaryButton(
                  label: localizations.homeDemoReset,
                  icon: Icons.restart_alt,
                  onPressed: isSaving
                      ? null
                      : () {
                          controller.reset();
                          nameController.clear();
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
