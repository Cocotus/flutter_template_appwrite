import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_version_service.g.dart';

/// Provides the app version as a display string, e.g. `0.1.0 (1)`.
///
/// The value comes from `package_info_plus` at runtime (which reads the
/// version from `pubspec.yaml` via the platform build), so it is always in
/// sync with the built artifact. Shown discreetly on the login screen and
/// on the About page.
@Riverpod(keepAlive: true)
Future<String> appVersion(Ref ref) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  if (buildNumber.isEmpty) {
    return version;
  }
  return '$version ($buildNumber)';
}
