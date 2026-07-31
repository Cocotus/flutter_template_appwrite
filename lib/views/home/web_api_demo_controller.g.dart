// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_api_demo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the Home page's "External REST API" demo card.
///
/// Fetches [WebApiProxyService.demoTarget]'s page title — see that class's
/// doc comment for why this needs a different code path on Flutter Web, and
/// README §12 for the full walkthrough. The view only reads this provider
/// once [WebApiProxyService.isAvailable] is `true`; on an unconfigured web
/// build it shows a setup hint instead, so this controller never attempts a
/// request that would just fail.

@ProviderFor(WebApiDemoController)
final webApiDemoControllerProvider = WebApiDemoControllerProvider._();

/// Controller for the Home page's "External REST API" demo card.
///
/// Fetches [WebApiProxyService.demoTarget]'s page title — see that class's
/// doc comment for why this needs a different code path on Flutter Web, and
/// README §12 for the full walkthrough. The view only reads this provider
/// once [WebApiProxyService.isAvailable] is `true`; on an unconfigured web
/// build it shows a setup hint instead, so this controller never attempts a
/// request that would just fail.
final class WebApiDemoControllerProvider
    extends $AsyncNotifierProvider<WebApiDemoController, String> {
  /// Controller for the Home page's "External REST API" demo card.
  ///
  /// Fetches [WebApiProxyService.demoTarget]'s page title — see that class's
  /// doc comment for why this needs a different code path on Flutter Web, and
  /// README §12 for the full walkthrough. The view only reads this provider
  /// once [WebApiProxyService.isAvailable] is `true`; on an unconfigured web
  /// build it shows a setup hint instead, so this controller never attempts a
  /// request that would just fail.
  WebApiDemoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webApiDemoControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webApiDemoControllerHash();

  @$internal
  @override
  WebApiDemoController create() => WebApiDemoController();
}

String _$webApiDemoControllerHash() =>
    r'4cefd26a41549fa38c0debfff6dd6803ebdfc1e9';

/// Controller for the Home page's "External REST API" demo card.
///
/// Fetches [WebApiProxyService.demoTarget]'s page title — see that class's
/// doc comment for why this needs a different code path on Flutter Web, and
/// README §12 for the full walkthrough. The view only reads this provider
/// once [WebApiProxyService.isAvailable] is `true`; on an unconfigured web
/// build it shows a setup hint instead, so this controller never attempts a
/// request that would just fail.

abstract class _$WebApiDemoController extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
