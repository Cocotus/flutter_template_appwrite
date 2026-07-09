import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_template_appwrite/l10n/app_localizations.dart';
import 'package:flutter_template_appwrite/theme/app_theme.dart';

/// Shown while the startup session check (`account.get()`) is running.
///
/// A branded splash instead of a bare spinner: a full-screen navy gradient
/// (matching the app shell's brand surface), the app logo gently pulsing in
/// a rounded card, and three staggered loading dots. The router's auth guard
/// replaces this page automatically with either the login screen or the
/// authenticated shell as soon as the check resolves.
///
/// Uses hooks for the animation controllers, so no StatefulWidget is needed.
class SplashView extends HookWidget {
  /// Creates a [SplashView].
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Gentle logo breathing: scale 0.96 -> 1.04 and back.
    final AnimationController pulseController = useAnimationController(
      duration: const Duration(milliseconds: 1400),
    );
    // Drives the three staggered loading dots.
    final AnimationController dotsController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    // Start both loops once on mount; the hooks dispose them automatically.
    useEffect(() {
      pulseController.repeat(reverse: true);
      dotsController.repeat();
      return null;
    }, const <Object?>[]);

    final Animation<double> logoScale = Tween<double>(begin: 0.96, end: 1.04)
        .animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    // The gradient is derived from the theme's primary color, so the splash
    // already carries the user's cached accent color on warm starts.
    final Color gradientTop = AppTheme.brandSurface(colorScheme.primary);
    const Color gradientBottom = Color(0xFF070D18);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[gradientTop, gradientBottom],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ScaleTransition(
                scale: logoScale,
                child: _buildLogoCard(context, localizations, colorScheme),
              ),
              const SizedBox(height: 28),
              Text(
                localizations.appTitle,
                style: const TextStyle(
                  color: AppTheme.onBrandSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 32),
              _buildLoadingDots(dotsController),
            ],
          ),
        ),
      ),
    );
  }

  // The logo in a white rounded card with a soft accent glow behind it.
  Widget _buildLogoCard(
    BuildContext context,
    AppLocalizations localizations,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 48,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        height: 72,
        semanticLabel: localizations.appTitle,
      ),
    );
  }

  // Three dots that light up one after another (a "typing" style loader).
  Widget _buildLoadingDots(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int dotIndex = 0; dotIndex < 3; dotIndex++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Opacity(
                  opacity: _dotOpacity(controller.value, dotIndex),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.onBrandSurface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Computes one dot's opacity: each dot is staggered by 20% of the cycle
  // and brightens/dims with a sine wave over the first 60% of its cycle.
  double _dotOpacity(double controllerValue, int dotIndex) {
    final double phase = (controllerValue - dotIndex * 0.2) % 1.0;
    // `%` can yield a negative phase for the later dots at cycle start.
    final double normalizedPhase = phase < 0 ? phase + 1.0 : phase;

    if (normalizedPhase < 0.6) {
      final double wave = math.sin((normalizedPhase / 0.6) * math.pi);
      return 0.25 + 0.75 * wave;
    }
    return 0.25;
  }
}
