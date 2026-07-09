// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [DatabaseService] instance.
///
/// Kept alive because data access is used across the whole app. Tests
/// override this provider with a fake, e.g.
/// `databaseServiceProvider.overrideWithValue(FakeDatabaseService())`.
///
/// When demo mode is active it returns a [DemoDatabaseService] serving
/// in-memory seed data, so every data-backed view works without Appwrite.

@ProviderFor(databaseService)
final databaseServiceProvider = DatabaseServiceProvider._();

/// Provides the app-wide [DatabaseService] instance.
///
/// Kept alive because data access is used across the whole app. Tests
/// override this provider with a fake, e.g.
/// `databaseServiceProvider.overrideWithValue(FakeDatabaseService())`.
///
/// When demo mode is active it returns a [DemoDatabaseService] serving
/// in-memory seed data, so every data-backed view works without Appwrite.

final class DatabaseServiceProvider
    extends
        $FunctionalProvider<DatabaseService, DatabaseService, DatabaseService>
    with $Provider<DatabaseService> {
  /// Provides the app-wide [DatabaseService] instance.
  ///
  /// Kept alive because data access is used across the whole app. Tests
  /// override this provider with a fake, e.g.
  /// `databaseServiceProvider.overrideWithValue(FakeDatabaseService())`.
  ///
  /// When demo mode is active it returns a [DemoDatabaseService] serving
  /// in-memory seed data, so every data-backed view works without Appwrite.
  DatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseServiceHash();

  @$internal
  @override
  $ProviderElement<DatabaseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DatabaseService create(Ref ref) {
    return databaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatabaseService>(value),
    );
  }
}

String _$databaseServiceHash() => r'c5a9501a9504c9a279f72e0c6931c0effa1400c3';
