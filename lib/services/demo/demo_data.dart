/// Seed data for demo mode.
///
/// Demo mode replaces the Appwrite-backed services with in-memory fakes so
/// the whole app can be explored without any backend (see
/// `DemoAuthService`, `DemoDatabaseService` and the `DemoMode` provider).
/// Everything a demo run displays originates here — change these values to
/// tailor the showcase.
library;

import 'package:appwrite/models.dart' as appwrite_models;

import 'package:flutter_template_appwrite/models/user_settings.dart';

/// The stable user ID used for the demo account.
const String demoUserId = 'demo-user';

/// The email pre-filled into the login form when demo mode is switched on.
const String demoEmail = 'demo@example.com';

/// The password pre-filled into the login form when demo mode is switched on.
///
/// Any credentials are accepted by [DemoAuthService]; this just gives the
/// form realistic-looking values so the demo mirrors a real login.
const String demoPassword = 'demo1234';

/// Builds the fake Appwrite [appwrite_models.User] returned while demo mode
/// is active.
///
/// Mirrors the shape of a real Appwrite user object so every view that reads
/// `currentUserProvider` (profile, sidebar avatar, ...) renders normally.
appwrite_models.User buildDemoUser() {
  return appwrite_models.User.fromMap(<String, dynamic>{
    r'$id': demoUserId,
    r'$createdAt': '2026-01-01T00:00:00.000+00:00',
    r'$updatedAt': '2026-01-01T00:00:00.000+00:00',
    'name': 'Demo User',
    'registration': '2026-01-01T00:00:00.000+00:00',
    'status': true,
    'labels': <String>[],
    'passwordUpdate': '2026-01-01T00:00:00.000+00:00',
    'email': demoEmail,
    'phone': '',
    'emailVerification': true,
    'phoneVerification': false,
    'mfa': false,
    'prefs': <String, dynamic>{},
    'targets': <dynamic>[],
    'accessedAt': '2026-01-01T00:00:00.000+00:00',
  });
}

/// The settings the demo account starts with.
const UserSettings demoUserSettings = UserSettings(
  displayName: 'Demo User',
);
