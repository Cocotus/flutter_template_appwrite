// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_api_proxy_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [WebApiProxyService].

@ProviderFor(webApiProxyService)
final webApiProxyServiceProvider = WebApiProxyServiceProvider._();

/// Provides the app-wide [WebApiProxyService].

final class WebApiProxyServiceProvider
    extends
        $FunctionalProvider<
          WebApiProxyService,
          WebApiProxyService,
          WebApiProxyService
        >
    with $Provider<WebApiProxyService> {
  /// Provides the app-wide [WebApiProxyService].
  WebApiProxyServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webApiProxyServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webApiProxyServiceHash();

  @$internal
  @override
  $ProviderElement<WebApiProxyService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WebApiProxyService create(Ref ref) {
    return webApiProxyService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebApiProxyService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebApiProxyService>(value),
    );
  }
}

String _$webApiProxyServiceHash() =>
    r'67a45ff76a18ddb20947d2988e1fb334dec671c6';
