import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_auth_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_data.dart';
import 'package:flutter_template_appwrite/services/demo/demo_database_service.dart';
import 'package:flutter_template_appwrite/services/demo_mode_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';

/// Tests for demo mode.
///
/// Under `flutter test`, [kDebugMode] is `true`, so [demoModeIsAllowed] is
/// `true` — these tests exercise the "allowed" path. The production-gated
/// path (allowed == false) cannot be reached from a debug test run; it is
/// guaranteed at compile time by [AppConfig.demoModeAllowed] being `false`
/// when the define is omitted.
void main() {
  Future<ProviderContainer> createContainer({
    required bool demoEnabled,
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'demo_mode_enabled': demoEnabled,
    });
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // (The Override list type is inferred — riverpod 3 does not export the
    // Override class in its public API.)
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('demoModeIsAllowed is true in debug test runs', () {
    expect(demoModeIsAllowed, isTrue);
  });

  test('demo mode reflects the persisted preference', () async {
    final ProviderContainer container =
        await createContainer(demoEnabled: true);
    expect(container.read(demoModeProvider), isTrue);
  });

  test('demo mode defaults to off when nothing is persisted', () async {
    final ProviderContainer container =
        await createContainer(demoEnabled: false);
    expect(container.read(demoModeProvider), isFalse);
  });

  test('with demo mode on, the app uses the fake services (no Appwrite)',
      () async {
    final ProviderContainer container =
        await createContainer(demoEnabled: true);

    // The service layer swapped in the in-memory fakes.
    expect(container.read(authServiceProvider), isA<DemoAuthService>());
    expect(container.read(databaseServiceProvider), isA<DemoDatabaseService>());

    // The demo account starts logged OUT, so the login form is shown.
    expect(await container.read(currentUserProvider.future), isNull);

    // Submitting the (pre-filled) form logs in — any credentials are accepted.
    await container
        .read(authServiceProvider)
        .login(email: demoEmail, password: demoPassword);
    await container.read(currentUserProvider.notifier).refresh();

    final user = await container.read(currentUserProvider.future);
    expect(user, isNotNull);
    expect(user!.$id, demoUserId);

    // The demo database serves the seeded settings.
    final DatabaseService db = container.read(databaseServiceProvider);
    final UserSettings? settings =
        await db.loadUserSettings(userId: demoUserId);
    expect(settings?.displayName, demoUserSettings.displayName);
  });

  test('turning demo mode off flips the state and persists the choice',
      () async {
    final ProviderContainer container =
        await createContainer(demoEnabled: true);
    expect(container.read(demoModeProvider), isTrue);

    await container.read(demoModeProvider.notifier).set(enabled: false);

    // In-memory state is off...
    expect(container.read(demoModeProvider), isFalse);
    // ...and the choice was written back to preferences.
    expect(container.read(preferencesServiceProvider).readDemoMode(), isFalse);
    // (Reading authServiceProvider now would build the real Appwrite client,
    // which needs Flutter bindings/plugins — out of scope here. The
    // demo -> fake service swap is covered by the test above.)
  });
}
