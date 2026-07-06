/// Hand-written fakes for the service layer.
///
/// Tests override the service providers with these fakes via
/// `ProviderScope(overrides: ...)` / `ProviderContainer(overrides: ...)`,
/// so no test ever talks to the network. Plain classes instead of a mocking
/// framework keep the tests easy to read and free of extra dependencies.
library;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;

import 'package:flutter_template_appwrite/models/remote_log_entry.dart';
import 'package:flutter_template_appwrite/models/user_settings.dart';
import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/database_service.dart';

/// Builds a minimal Appwrite [appwrite_models.User] for tests.
appwrite_models.User buildFakeUser({
  String id = 'user-123',
  String name = 'Test User',
  String email = 'test@example.com',
}) {
  return appwrite_models.User.fromMap(<String, dynamic>{
    r'$id': id,
    r'$createdAt': '2026-01-01T00:00:00.000+00:00',
    r'$updatedAt': '2026-01-01T00:00:00.000+00:00',
    'name': name,
    'registration': '2026-01-01T00:00:00.000+00:00',
    'status': true,
    'labels': <String>[],
    'passwordUpdate': '2026-01-01T00:00:00.000+00:00',
    'email': email,
    'phone': '',
    'emailVerification': true,
    'phoneVerification': false,
    'mfa': false,
    'prefs': <String, dynamic>{},
    'targets': <dynamic>[],
    'accessedAt': '2026-01-01T00:00:00.000+00:00',
  });
}

/// A fake [AuthService] that records every call instead of hitting Appwrite.
class FakeAuthService implements AuthService {
  /// The user returned by [currentUser] after a successful [login].
  appwrite_models.User fakeUser = buildFakeUser();

  /// When set, [login] throws this exception instead of succeeding.
  AppwriteException? loginException;

  /// When set, [register] throws this exception instead of succeeding.
  AppwriteException? registerException;

  /// Whether a session currently exists (drives [currentUser]).
  bool isLoggedIn = false;

  /// The email passed to the last [login] call.
  String? lastLoginEmail;

  /// The password passed to the last [login] call.
  String? lastLoginPassword;

  /// The email passed to the last [register] call.
  String? lastRegisterEmail;

  /// The name passed to the last [register] call.
  String? lastRegisterName;

  /// The email passed to the last [sendPasswordReset] call.
  String? lastPasswordResetEmail;

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    lastLoginEmail = email;
    lastLoginPassword = password;

    if (loginException != null) {
      throw loginException!;
    }
    isLoggedIn = true;
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    lastRegisterEmail = email;
    lastRegisterName = name;

    if (registerException != null) {
      throw registerException!;
    }
  }

  @override
  Future<appwrite_models.User> currentUser() async {
    if (isLoggedIn == false) {
      // Mirrors the real Appwrite behaviour without a session.
      throw AppwriteException('missing scope', 401, 'general_unauthorized');
    }
    return fakeUser;
  }

  @override
  Future<void> logout() async {
    isLoggedIn = false;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    lastPasswordResetEmail = email;
  }
}

/// A fake [DatabaseService] that stores settings in memory.
class FakeDatabaseService implements DatabaseService {
  /// The settings returned by [loadUserSettings]; `null` simulates a user
  /// without a settings row (first login).
  UserSettings? remoteSettings;

  /// The user ID passed to the last [saveUserSettings] call.
  String? lastSavedUserId;

  /// The settings passed to the last [saveUserSettings] call.
  UserSettings? lastSavedSettings;

  /// Every log entry passed to [writeLogEntry].
  final List<RemoteLogEntry> writtenLogEntries = <RemoteLogEntry>[];

  @override
  Future<UserSettings?> loadUserSettings({required String userId}) async {
    return remoteSettings;
  }

  @override
  Future<void> saveUserSettings({
    required String userId,
    required UserSettings settings,
  }) async {
    lastSavedUserId = userId;
    lastSavedSettings = settings;
    remoteSettings = settings;
  }

  @override
  Future<void> writeLogEntry(RemoteLogEntry entry) async {
    writtenLogEntries.add(entry);
  }
}
