import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';
import 'package:flutter_template_appwrite/views/login/login_controller.dart';

import '../fakes/fake_services.dart';

/// Controller tests for [LoginController].
///
/// The Appwrite-facing services are replaced with in-memory fakes via
/// provider overrides, so these tests never touch the network.
void main() {
  late FakeAuthService fakeAuthService;
  late FakeDatabaseService fakeDatabaseService;

  /// Builds a fresh [ProviderContainer] with all Appwrite services faked.
  Future<ProviderContainer> createContainer() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final ProviderContainer container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        authServiceProvider.overrideWithValue(fakeAuthService),
        databaseServiceProvider.overrideWithValue(fakeDatabaseService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    fakeAuthService = FakeAuthService();
    fakeDatabaseService = FakeDatabaseService();
  });

  test('login success calls the auth service and ends in AsyncData',
      () async {
    final ProviderContainer container = await createContainer();
    final LoginController controller =
        container.read(loginControllerProvider.notifier);

    await controller.login(
      email: 'jane@example.com',
      password: 'secret123',
    );

    expect(fakeAuthService.lastLoginEmail, 'jane@example.com');
    expect(fakeAuthService.lastLoginPassword, 'secret123');

    final AsyncValue<void> state = container.read(loginControllerProvider);
    expect(state.hasError, isFalse);
    expect(state.hasValue, isTrue);
  });

  test('login failure (401) surfaces the AppwriteException as AsyncError',
      () async {
    fakeAuthService.loginException =
        AppwriteException('Invalid credentials', 401, 'user_invalid');

    final ProviderContainer container = await createContainer();
    final LoginController controller =
        container.read(loginControllerProvider.notifier);

    await controller.login(
      email: 'jane@example.com',
      password: 'wrong-password',
    );

    final AsyncValue<void> state = container.read(loginControllerProvider);
    expect(state.hasError, isTrue);

    final Object? error = state.error;
    expect(error, isA<AppwriteException>());
    expect((error as AppwriteException).code, 401);
  });

  test(
      'register creates the user, logs in and stores default settings '
      'under the user id', () async {
    final ProviderContainer container = await createContainer();
    final LoginController controller =
        container.read(loginControllerProvider.notifier);

    await controller.register(
      email: 'new@example.com',
      password: 'secret123',
      name: 'New User',
    );

    // Registration and auto-login both reached the auth service.
    expect(fakeAuthService.lastRegisterEmail, 'new@example.com');
    expect(fakeAuthService.lastRegisterName, 'New User');
    expect(fakeAuthService.lastLoginEmail, 'new@example.com');

    // The default settings row was written with rowId == user id.
    expect(fakeDatabaseService.lastSavedUserId, fakeAuthService.fakeUser.$id);
    expect(fakeDatabaseService.lastSavedSettings, isNotNull);

    final AsyncValue<void> state = container.read(loginControllerProvider);
    expect(state.hasError, isFalse);
    expect(state.hasValue, isTrue);
  });

  test('duplicate email on register (409) ends in AsyncError', () async {
    fakeAuthService.registerException =
        AppwriteException('User already exists', 409, 'user_already_exists');

    final ProviderContainer container = await createContainer();
    final LoginController controller =
        container.read(loginControllerProvider.notifier);

    await controller.register(
      email: 'taken@example.com',
      password: 'secret123',
      name: 'Someone',
    );

    final AsyncValue<void> state = container.read(loginControllerProvider);
    expect(state.hasError, isTrue);
    expect((state.error as AppwriteException).code, 409);
  });
}
