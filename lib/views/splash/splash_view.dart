import 'package:flutter/material.dart';

import 'package:flutter_template_appwrite/widgets/loading_indicator.dart';

/// Shown while the startup session check (`account.get()`) is running.
///
/// The router's auth guard replaces this page automatically with either the
/// login screen or the authenticated shell as soon as the check resolves.
class SplashView extends StatelessWidget {
  /// Creates a [SplashView].
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingIndicator(),
    );
  }
}
