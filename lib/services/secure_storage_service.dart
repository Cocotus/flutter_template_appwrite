import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_service.g.dart';

/// Encrypted key/value storage for sensitive values.
///
/// IMPORTANT: the Appwrite Flutter SDK persists its own session (browser
/// cookies on web, an internal store on desktop), so this template does not
/// need to store any auth token itself. This service exists as the
/// sanctioned place for secrets your app may add later (API keys, offline
/// tokens, ...) — never put such values into `shared_preferences`.
///
/// Platform notes:
/// - Windows: uses the system credential store (DPAPI).
/// - Linux: requires `libsecret` (install `libsecret-1-dev` when building,
///   and a keyring service at runtime) — see the README prerequisites.
/// - Web: values are encrypted with WebCrypto but stored in the browser;
///   treat web storage as best-effort, not as a vault.
class SecureStorageService {
  /// Creates a [SecureStorageService] (the store is passed as `storage:`).
  SecureStorageService({required this._storage});

  final FlutterSecureStorage _storage;

  /// Reads the secret stored under [key], or `null` when absent.
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  /// Stores [value] under [key].
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Deletes the secret stored under [key].
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }
}

/// Provides the app-wide [SecureStorageService] instance.
@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  return SecureStorageService(storage: const FlutterSecureStorage());
}
