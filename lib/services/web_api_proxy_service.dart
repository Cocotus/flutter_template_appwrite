import 'dart:async';

import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite/enums.dart' as appwrite_enums;
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';

part 'web_api_proxy_service.g.dart';

/// Demonstrates the one thing Flutter Web genuinely cannot do that every
/// other Flutter target can: call an arbitrary external REST API or web page
/// directly. Backs the "External REST API" card on the Home page.
///
/// ## Why web needs a different code path here
///
/// A browser refuses to hand a web page the response of a cross-origin
/// request unless the SERVER being called sends back permission headers
/// (this is called CORS — Cross-Origin Resource Sharing). Most REST APIs and
/// plain web pages — including [demoTarget] below — send no such headers, so
/// on Flutter Web a direct request to them is blocked before this app ever
/// sees a reply. Desktop and mobile builds have no such restriction — there
/// is no browser sandbox involved — so they call the target directly,
/// exactly like `curl` would, and need no setup at all.
///
/// On web, this service instead asks a small Appwrite Function
/// (`functions/web-api-proxy/`) to fetch the page — that function runs
/// server-side, so it is not subject to CORS. See README §12 for the full
/// walkthrough, including the five-minute deployment steps.
///
/// ## Adapting this to your own API
///
/// Change [demoTarget] to your API's URL, change how [fetchDemoPageTitle]
/// parses the response (e.g. `jsonDecode` for a JSON API instead of a
/// `<title>` regex), and add your API's hostname to `ALLOWED_HOSTS` on the
/// deployed function — nothing else in this class needs to change, since it
/// never interprets the response on the proxy side, only on this side.
class WebApiProxyService {
  /// Creates a [WebApiProxyService].
  WebApiProxyService({
    required this._httpClient,
    required appwrite.Client proxyClient,
  }) : _functions = appwrite.Functions(proxyClient);

  final http.Client _httpClient;
  final appwrite.Functions _functions;

  static const Duration _timeout = Duration(seconds: 15);

  /// The page this demo fetches.
  ///
  /// `example.com` is the domain IANA reserves specifically for use in
  /// examples and documentation like this one, so it is safe, free and
  /// guaranteed stable to depend on here.
  static final Uri demoTarget = Uri.parse('https://example.com');

  /// Whether this demo can be attempted at all on the current platform/build.
  ///
  /// `false` only on web without a deployed proxy function — every other
  /// combination (any non-web platform, or web with the function
  /// configured) can proceed with no further checks.
  bool get isAvailable {
    if (kIsWeb) {
      return AppConfig.webApiProxyFunctionId.isNotEmpty;
    }
    return true;
  }

  /// Fetches [demoTarget] and returns the text inside its `<title>` tag.
  ///
  /// This is the "scraping" part of the demo: a plain web page has no JSON
  /// API, so the only way to pull structured information out of one is to
  /// read its markup. A regex is enough for a single, well-known tag like
  /// this one; a real scraping task on a bigger page would reach for a
  /// proper HTML parser package instead of growing this regex.
  ///
  /// Only call this when [isAvailable] is `true` — the Home page's demo
  /// card checks that first and shows a setup hint instead when it is not.
  Future<String> fetchDemoPageTitle() async {
    final String html = kIsWeb
        ? await _fetchViaProxy(demoTarget)
        : await _fetchDirect(demoTarget);

    final RegExpMatch? titleMatch = RegExp(
      r'<title[^>]*>([^<]*)</title>',
      caseSensitive: false,
    ).firstMatch(html);
    if (titleMatch == null) {
      return '(no <title> tag found)';
    }
    return titleMatch.group(1)?.trim() ?? '(empty <title> tag)';
  }

  // The normal path: ask the target directly. Works on every platform
  // except web, where no site can be assumed to allow it.
  Future<String> _fetchDirect(Uri url) async {
    final http.Response response = await _httpClient.get(url).timeout(_timeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Unexpected HTTP ${response.statusCode} from ${url.host}',
      );
    }
    return response.body;
  }

  // The web path: ask the deployed `web-api-proxy` Appwrite Function to
  // fetch the target on our behalf (see functions/web-api-proxy/src/main.js).
  // This is a normal call to Appwrite's own REST API -- the same one login
  // already uses -- so it is not subject to CORS the way a direct call to
  // the target would be.
  Future<String> _fetchViaProxy(Uri url) async {
    final appwrite_models.Execution execution = await _functions
        .createExecution(
          functionId: AppConfig.webApiProxyFunctionId,
          // The real target URL travels as a single query parameter; the
          // function reads it back out as `req.query.url`.
          path: '/?url=${Uri.encodeQueryComponent(url.toString())}',
          method: appwrite_enums.ExecutionMethod.gET,
        )
        .timeout(_timeout);

    if (execution.responseStatusCode < 200 ||
        execution.responseStatusCode >= 300) {
      throw Exception(
        'Proxy returned unexpected HTTP ${execution.responseStatusCode}',
      );
    }
    return execution.responseBody;
  }
}

/// Provides the app-wide [WebApiProxyService].
@Riverpod(keepAlive: true)
WebApiProxyService webApiProxyService(Ref ref) {
  final http.Client httpClient = http.Client();

  // A minimal Appwrite client used ONLY to call the `web-api-proxy` function
  // on web. Deliberately built from `AppConfig` directly rather than reusing
  // `appwriteServiceProvider`: that provider requires `AppConfig.hasLogin`,
  // but this demo must keep working even in a build with no login at all.
  final appwrite.Client proxyClient = appwrite.Client()
      .setEndpoint(AppConfig.appwriteEndpoint)
      .setProject(AppConfig.appwriteProjectId);

  final WebApiProxyService service = WebApiProxyService(
    httpClient: httpClient,
    proxyClient: proxyClient,
  );
  ref.onDispose(httpClient.close);
  return service;
}
