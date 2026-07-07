import 'package:flutter/material.dart';

/// Soft veil over painted backgrounds so body text stays readable.
class AppScreenContentScrim extends StatelessWidget {
  const AppScreenContentScrim({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.58),
              Colors.white.withValues(alpha: 0.72),
              Colors.white.withValues(alpha: 0.82),
            ],
            stops: const [0.0, 0.42, 1.0],
          ),
        ),
      ),
    );
  }
}
