// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the single app-wide [LoggerService] instance.
///
/// Kept alive for the whole app lifetime: the logger must never be
/// disposed. In the real app this provider is overridden in `main.dart` so
/// it wraps the same Talker instance that receives the global error hooks;
/// the default implementation below keeps tests and tools working without
/// that override.

@ProviderFor(loggerService)
final loggerServiceProvider = LoggerServiceProvider._();

/// Provides the single app-wide [LoggerService] instance.
///
/// Kept alive for the whole app lifetime: the logger must never be
/// disposed. In the real app this provider is overridden in `main.dart` so
/// it wraps the same Talker instance that receives the global error hooks;
/// the default implementation below keeps tests and tools working without
/// that override.

final class LoggerServiceProvider
    extends $FunctionalProvider<LoggerService, LoggerService, LoggerService>
    with $Provider<LoggerService> {
  /// Provides the single app-wide [LoggerService] instance.
  ///
  /// Kept alive for the whole app lifetime: the logger must never be
  /// disposed. In the real app this provider is overridden in `main.dart` so
  /// it wraps the same Talker instance that receives the global error hooks;
  /// the default implementation below keeps tests and tools working without
  /// that override.
  LoggerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggerServiceHash();

  @$internal
  @override
  $ProviderElement<LoggerService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoggerService create(Ref ref) {
    return loggerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoggerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoggerService>(value),
    );
  }
}

String _$loggerServiceHash() => r'af8892080b956e9ebbeafb3057707d9110e016e3';
