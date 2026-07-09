import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;

import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/demo/demo_data.dart';

/// In-memory [AuthService] used when demo mode is active.
///
/// It implements the exact same interface the real [AuthService] exposes, so
/// controllers and the router's auth guard cannot tell the difference. The
/// demo account starts LOGGED OUT: switching demo mode on pre-fills the login
/// form (see `LoginView`), and the user submits it just like a real login —
/// [login] then accepts any credentials. This keeps the demo faithful to the
/// real sign-in experience.
///
/// This class ships in `lib/` (not `test/`) on purpose: it backs a real,
/// user-facing run. It is only ever selected behind the compile-time
/// [AppConfig.demoModeAllowed] gate (see `authServiceProvider`).
class DemoAuthService implements AuthService {
  /// Whether a demo session currently exists. Starts `false` so the login
  /// form is shown; [login] flips it to `true`.
  bool _isLoggedIn = false;

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Any credentials are accepted in demo mode.
    _isLoggedIn = true;
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Registration is a no-op; the single demo account always exists.
  }

  @override
  Future<appwrite_models.User> currentUser() async {
    if (_isLoggedIn == false) {
      // Mirror real Appwrite behaviour when no session exists.
      throw AppwriteException('missing scope', 401, 'general_unauthorized');
    }
    return buildDemoUser();
  }

  @override
  Future<void> logout() async {
    _isLoggedIn = false;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    // No email is sent in demo mode.
  }
}
