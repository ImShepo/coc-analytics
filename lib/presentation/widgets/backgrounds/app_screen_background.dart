import 'package:coc/presentation/widgets/backgrounds/app_screen_background_painter.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:flutter/material.dart';

/// Full-screen painted backdrop shared across the app.
class AppScreenBackground extends StatelessWidget {
  final AppScreenBackgroundVariant variant;
  final Color? primary;
  final Color? secondary;

  const AppScreenBackground({
    super.key,
    required this.variant,
    this.primary,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: AppScreenBackgroundPainter(
        primary: primary ?? colorScheme.onPrimary,
        secondary: secondary ?? colorScheme.secondary,
        variant: variant,
      ),
    );
  }
}

/// Convenience wrapper for the player home screen.
class PlayerHomeBackground extends StatelessWidget {
  final Color primary;
  final Color secondary;

  const PlayerHomeBackground({
    super.key,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return AppScreenBackground(
      variant: AppScreenBackgroundVariant.home,
      primary: primary,
      secondary: secondary,
    );
  }
}
