import 'package:coc/presentation/widgets/backgrounds/app_screen_background.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_content_scrim.dart';
import 'package:flutter/material.dart';

/// Painted background + readability scrim + screen content.
class AppScreenStack extends StatelessWidget {
  final AppScreenBackgroundVariant variant;
  final Widget child;
  final Color? primary;
  final Color? secondary;
  final Color? mood;
  final bool showScrim;

  const AppScreenStack({
    super.key,
    required this.variant,
    required this.child,
    this.primary,
    this.secondary,
    this.mood,
    this.showScrim = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: AppScreenBackground(
            variant: variant,
            primary: primary,
            secondary: secondary,
            mood: mood,
          ),
        ),
        if (showScrim) const AppScreenContentScrim(),
        child,
      ],
    );
  }
}
