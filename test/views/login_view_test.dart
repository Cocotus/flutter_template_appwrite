import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/services/app_version_service.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';
import 'package:flutter_template_appwrite/services/preferences_service.dart';
import 'package:flutter_template_appwrite/views/login/login_view.dart';

import '../fakes/fake_services.dart';

/// Widget tests for [LoginView]: rendering, register-mode toggle and the
/// password visibility (eye icon) toggle.
void main() {
  /// Pumps the login view with all Appwrite services faked.
  Future<void> pumpLoginView(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          authServiceProvider.overrideWithValue(FakeAuthService()),
          databaseServiceProvider.overrideWithValue(FakeDatabaseService()),
          // package_info_plus has no platform implementation in tests.
          appVersionProvider.overrideWith((Ref ref) {
            return Future<String>.value('0.1.0 (1)');
          }),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginView(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders email, password and a login button', (
    WidgetTester tester,
  ) async {
    await pumpLoginView(tester);

    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Login'), findsOneWidget);

    // Register-only fields are hidden in login mode.
    expect(find.widgetWithText(TextField, 'Confirm password'), findsNothing);
    expect(find.widgetWithText(TextField, 'Display name'), findsNothing);
  });

  testWidgets('toggles to register mode and back', (
    WidgetTester tester,
  ) async {
    await pumpLoginView(tester);

    // Switch to register mode.
    await tester.ensureVisible(find.text('No account yet? Register'));
    await tester.tap(find.text('No account yet? Register'));
    await tester.pump();

    expect(find.widgetWithText(TextField, 'Confirm password'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Display name'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Register'), findsOneWidget);

    // And back to login mode. In register mode the form grows beyond the
    // test viewport, so scroll the button into view before tapping.
    await tester.ensureVisible(find.text('Already have an account? Login'));
    await tester.pump();
    await tester.tap(find.text('Already have an account? Login'));
    await tester.pump();

    expect(find.widgetWithText(TextField, 'Confirm password'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Login'), findsOneWidget);
  });

  testWidgets('eye icon toggles password visibility', (
    WidgetTester tester,
  ) async {
    await pumpLoginView(tester);

    // Initially the password is hidden and the "show" icon is offered.
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    EditableText passwordEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextField, 'Password'),
        matching: find.byType(EditableText),
      ),
    );
    expect(passwordEditable.obscureText, isTrue);

    // Tap the eye icon: the password becomes visible.
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    passwordEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextField, 'Password'),
        matching: find.byType(EditableText),
      ),
    );
    expect(passwordEditable.obscureText, isFalse);
  });
}
