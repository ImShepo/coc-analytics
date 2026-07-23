import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Transition backdrop between login hills and the home sky/grid.
class LinkPlayerBackgroundPainter extends CustomPainter {
  final Color primary;
  final Color secondary;

  LinkPlayerBackgroundPainter({
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBase(canvas, size);
    _paintSoftAurora(canvas, size);
    _paintHills(canvas, size);
    _paintFaintGrid(canvas, size);
    _paintSparkles(canvas, size);
  }

  void _paintBase(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        const [
          Color(0xFFF7F7F5),
          Color(0xFFEEF3EA),
          Color(0xFFE4EEDC),
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawRect(rect, paint);
  }

  void _paintSoftAurora(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42);
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.12),
      size.width * 0.38,
      paint..color = secondary.withValues(alpha: 0.45),
    );
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.22),
      size.width * 0.32,
      paint..color = primary.withValues(alpha: 0.12),
    );
  }

  void _paintHills(Canvas canvas, Size size) {
    // Back hill — softer, more layered than login MountainPainter.
    final back = Path()
      ..moveTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.62,
        size.width * 0.34,
        size.height * 0.78,
        size.width * 0.52,
        size.height * 0.70,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.60,
        size.width * 0.88,
        size.height * 0.74,
        size.width,
        size.height * 0.66,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      back,
      Paint()..color = primary.withValues(alpha: 0.16),
    );

    final front = Path()
      ..moveTo(0, size.height * 0.84)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.76,
        size.width * 0.42,
        size.height * 0.88,
      )
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.98,
        size.width * 0.78,
        size.height * 0.86,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.78,
        size.width,
        size.height * 0.84,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      front,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, size.height * 0.78),
          Offset(0, size.height),
          [
            secondary.withValues(alpha: 0.95),
            primary.withValues(alpha: 0.55),
          ],
        ),
    );
  }

  void _paintFaintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primary.withValues(alpha: 0.07)
      ..strokeWidth = 1;

    final startY = size.height * 0.55;
    const step = 28.0;
    for (double y = startY; y < size.height; y += step) {
      final path = Path();
      for (double x = -20; x < size.width + 40; x += step) {
        final px = x + ((y - startY) / step) * (step * 0.5);
        final py = y;
        if (x <= -20) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final rnd = math.Random(29);
    final paint = Paint()..color = primary.withValues(alpha: 0.18);
    for (var i = 0; i < 18; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height * 0.55;
      final r = 1.2 + rnd.nextDouble() * 1.8;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinkPlayerBackgroundPainter oldDelegate) {
    return oldDelegate.primary != primary || oldDelegate.secondary != secondary;
  }
}
