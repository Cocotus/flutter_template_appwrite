import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/services/web_api_proxy_service.dart';

part 'web_api_demo_controller.g.dart';

/// Controller for the Home page's "External REST API" demo card.
///
/// Fetches [WebApiProxyService.demoTarget]'s page title — see that class's
/// doc comment for why this needs a different code path on Flutter Web, and
/// README §12 for the full walkthrough. The view only reads this provider
/// once [WebApiProxyService.isAvailable] is `true`; on an unconfigured web
/// build it shows a setup hint instead, so this controller never attempts a
/// request that would just fail.
@riverpod
class WebApiDemoController extends _$WebApiDemoController {
  @override
  FutureOr<String> build() {
    final WebApiProxyService service = ref.watch(webApiProxyServiceProvider);
    return service.fetchDemoPageTitle();
  }

  /// Re-runs the fetch (used by the card's retry button).
  Future<void> refresh() async {
    state = const AsyncValue<String>.loading();
    state = await AsyncValue.guard(() {
      final WebApiProxyService service = ref.read(webApiProxyServiceProvider);
      return service.fetchDemoPageTitle();
    });
  }
}
