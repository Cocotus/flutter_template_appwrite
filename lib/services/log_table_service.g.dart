// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_table_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [LogTableService] instance.
///
/// Kept alive because the logger outlives every view. In demo mode it returns
/// a [DemoLogTableService], so a demo run never posts anything anywhere.

@ProviderFor(logTableService)
final logTableServiceProvider = LogTableServiceProvider._();

/// Provides the app-wide [LogTableService] instance.
///
/// Kept alive because the logger outlives every view. In demo mode it returns
/// a [DemoLogTableService], so a demo run never posts anything anywhere.

final class LogTableServiceProvider
    extends
        $FunctionalProvider<LogTableService, LogTableService, LogTableService>
    with $Provider<LogTableService> {
  /// Provides the app-wide [LogTableService] instance.
  ///
  /// Kept alive because the logger outlives every view. In demo mode it returns
  /// a [DemoLogTableService], so a demo run never posts anything anywhere.
  LogTableServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logTableServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logTableServiceHash();

  @$internal
  @override
  $ProviderElement<LogTableService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogTableService create(Ref ref) {
    return logTableService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogTableService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogTableService>(value),
    );
  }
}

String _$logTableServiceHash() => r'a946464027890d8f0d843d21ece8025f9bbeaeb8';
