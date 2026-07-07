import 'dart:math' as math;

import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:flutter/material.dart';

/// Unified screen backdrop aligned with the home palette.
/// Each [AppScreenBackgroundVariant] adds contextual layers on top of the shared sky.
class AppScreenBackgroundPainter extends CustomPainter {
  final Color primary;
  final Color secondary;
  final AppScreenBackgroundVariant variant;

  AppScreenBackgroundPainter({
    required this.primary,
    required this.secondary,
    required this.variant,
  });

  int get _sparkleSeed => switch (variant) {
        AppScreenBackgroundVariant.home => 17,
        AppScreenBackgroundVariant.stats => 23,
        AppScreenBackgroundVariant.compare => 31,
        AppScreenBackgroundVariant.clan => 7,
        AppScreenBackgroundVariant.member => 11,
        AppScreenBackgroundVariant.unit => 19,
      };

  double get _vignetteStrength => switch (variant) {
        AppScreenBackgroundVariant.home => 0.06,
        AppScreenBackgroundVariant.stats => 0.07,
        AppScreenBackgroundVariant.compare => 0.07,
        AppScreenBackgroundVariant.clan => 0.05,
        AppScreenBackgroundVariant.member => 0.08,
        AppScreenBackgroundVariant.unit => 0.08,
      };

  @override
  void paint(Canvas canvas, Size size) {
    _paintSky(canvas, size);
    _paintAuroraBands(canvas, size);
    _paintVariantLayers(canvas, size);
    _paintSparkles(canvas, size);
    _paintVignette(canvas, size, _vignetteStrength);
  }

  void _paintVariantLayers(Canvas canvas, Size size) {
    switch (variant) {
      case AppScreenBackgroundVariant.home:
        _paintResourceGlows(canvas, size);
        _paintConstellation(canvas, size, seed: 42, topFactor: 0.42);
        _paintShieldWatermark(canvas, size);
        _paintIsometricGrid(canvas, size, startFactor: 0.52, intensity: 1.0);
      case AppScreenBackgroundVariant.stats:
        _drawGlowOrb(
          canvas,
          center: Offset(size.width * 0.84, size.height * 0.12),
          radius: 100,
          inner: const Color(0xFFF5C842).withValues(alpha: 0.32),
        );
        _paintStatBars(canvas, size);
        _paintConstellation(canvas, size, seed: 58, topFactor: 0.32);
        _paintIsometricGrid(canvas, size, startFactor: 0.62, intensity: 0.55);
      case AppScreenBackgroundVariant.compare:
        _drawGlowOrb(
          canvas,
          center: Offset(size.width * 0.18, size.height * 0.28),
          radius: 105,
          inner: primary.withValues(alpha: 0.22),
        );
        _drawGlowOrb(
          canvas,
          center: Offset(size.width * 0.82, size.height * 0.28),
          radius: 105,
          inner: const Color(0xFF6B4E71).withValues(alpha: 0.22),
        );
        _paintVsWatermark(canvas, size);
        _paintConstellation(canvas, size, seed: 71, topFactor: 0.38);
        _paintIsometricGrid(canvas, size, startFactor: 0.58, intensity: 0.65);
      case AppScreenBackgroundVariant.clan:
        _paintClouds(canvas, size);
        _paintRollingHills(canvas, size);
        _paintVillagePath(canvas, size);
        _paintBannerWatermark(canvas, size);
        _paintIsometricGrid(canvas, size, startFactor: 0.64, intensity: 0.45);
      case AppScreenBackgroundVariant.member:
        _drawGlowOrb(
          canvas,
          center: Offset(size.width * 0.5, size.height * 0.22),
          radius: 120,
          inner: secondary.withValues(alpha: 0.38),
        );
        _paintRollingHills(canvas, size, hillAlpha: 0.18);
        _paintVillagePath(canvas, size, alpha: 0.35);
        _paintConstellation(canvas, size, seed: 89, topFactor: 0.28);
        _paintIsometricGrid(canvas, size, startFactor: 0.66, intensity: 0.4);
      case AppScreenBackgroundVariant.unit:
        _drawGlowOrb(
          canvas,
          center: Offset(size.width * 0.5, size.height * 0.34),
          radius: 140,
          inner: primary.withValues(alpha: 0.2),
        );
        _drawGlowOrb(
          canvas,
          center: Offset(size.width * 0.5, size.height * 0.34),
          radius: 70,
          inner: const Color(0xFFF5C842).withValues(alpha: 0.16),
        );
        _paintCrosshairWatermark(canvas, size);
        _paintIsometricGrid(canvas, size, startFactor: 0.48, intensity: 1.15);
    }
  }

  void _paintSky(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE8EEF8),
            const Color(0xFFEDF5EA),
            secondary.withValues(alpha: 0.42),
            const Color(0xFFF3EBE0),
            AppScreenBackgroundColors.base,
          ],
          stops: const [0.0, 0.28, 0.52, 0.78, 1.0],
        ).createShader(rect),
    );
  }

  void _paintAuroraBands(Canvas canvas, Size size) {
    final intensity = switch (variant) {
      AppScreenBackgroundVariant.home => 1.0,
      AppScreenBackgroundVariant.stats => 0.85,
      AppScreenBackgroundVariant.compare => 0.9,
      AppScreenBackgroundVariant.clan => 0.75,
      AppScreenBackgroundVariant.member => 0.7,
      AppScreenBackgroundVariant.unit => 0.8,
    };

    final bands = [
      (0.12, primary.withValues(alpha: 0.14 * intensity), 0.18),
      (0.22, const Color(0xFFB565D8).withValues(alpha: 0.10 * intensity), 0.14),
      (0.34, secondary.withValues(alpha: 0.22 * intensity), 0.16),
    ];

    for (final (yFactor, color, amp) in bands) {
      final path = Path()..moveTo(0, size.height * yFactor);
      for (var x = 0.0; x <= size.width; x += 6) {
        final y = size.height * yFactor +
            math.sin((x / size.width) * math.pi * 3.2) * size.height * amp;
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height * (yFactor + 0.18))
        ..lineTo(0, size.height * (yFactor + 0.18))
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }
  }

  void _paintResourceGlows(Canvas canvas, Size size) {
    _drawGlowOrb(
      canvas,
      center: Offset(size.width * 0.88, size.height * 0.10),
      radius: 110,
      inner: const Color(0xFFF5C842).withValues(alpha: 0.38),
    );
    _drawGlowOrb(
      canvas,
      center: Offset(size.width * 0.10, size.height * 0.22),
      radius: 95,
      inner: const Color(0xFFB565D8).withValues(alpha: 0.28),
    );
    _drawGlowOrb(
      canvas,
      center: Offset(size.width * 0.72, size.height * 0.48),
      radius: 130,
      inner: primary.withValues(alpha: 0.16),
    );
    _drawGlowOrb(
      canvas,
      center: Offset(size.width * 0.28, size.height * 0.62),
      radius: 85,
      inner: secondary.withValues(alpha: 0.32),
    );
  }

  void _drawGlowOrb(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color inner,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [inner, inner.withValues(alpha: 0.0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _paintConstellation(
    Canvas canvas,
    Size size, {
    required int seed,
    required double topFactor,
  }) {
    final rng = math.Random(seed);
    final points = List.generate(
      12,
      (_) => Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height * topFactor + size.height * 0.04,
      ),
    );

    final linePaint = Paint()
      ..color = primary.withValues(alpha: 0.12)
      ..strokeWidth = 1.1;

    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        if ((points[i] - points[j]).distance < size.width * 0.28) {
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    final nodePaint = Paint()..color = primary.withValues(alpha: 0.28);
    final corePaint = Paint()..color = Colors.white.withValues(alpha: 0.55);
    for (final point in points) {
      canvas.drawCircle(point, 3.2, nodePaint);
      canvas.drawCircle(point, 1.2, corePaint);
    }
  }

  void _paintShieldWatermark(Canvas canvas, Size size) {
    _paintBadgePath(
      canvas,
      size,
      center: Offset(size.width * 0.5, size.height * 0.38),
      scale: size.width * 0.38,
      fillAlpha: 0.045,
      strokeAlpha: 0.07,
    );
  }

  void _paintVsWatermark(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.36);
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'VS',
        style: TextStyle(
          fontSize: size.width * 0.16,
          fontWeight: FontWeight.w700,
          color: primary.withValues(alpha: 0.035),
          letterSpacing: 4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _paintBannerWatermark(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.34);
    final w = size.width * 0.42;
    final h = size.height * 0.08;
    final path = Path()
      ..moveTo(center.dx - w * 0.5, center.dy)
      ..lineTo(center.dx - w * 0.35, center.dy - h)
      ..lineTo(center.dx + w * 0.35, center.dy - h)
      ..lineTo(center.dx + w * 0.5, center.dy)
      ..close();

    canvas.drawPath(path, Paint()..color = primary.withValues(alpha: 0.05));
    canvas.drawPath(
      path,
      Paint()
        ..color = primary.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _paintCrosshairWatermark(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.36);
    final paint = Paint()
      ..color = primary.withValues(alpha: 0.07)
      ..strokeWidth = 2;
    canvas.drawCircle(center, 48, paint);
    canvas.drawLine(
      Offset(center.dx - 62, center.dy),
      Offset(center.dx + 62, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 62),
      Offset(center.dx, center.dy + 62),
      paint,
    );
  }

  void _paintBadgePath(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double scale,
    required double fillAlpha,
    required double strokeAlpha,
  }) {
    final path = Path()
      ..moveTo(center.dx, center.dy - scale * 0.55)
      ..cubicTo(
        center.dx + scale * 0.52,
        center.dy - scale * 0.42,
        center.dx + scale * 0.48,
        center.dy + scale * 0.08,
        center.dx,
        center.dy + scale * 0.52,
      )
      ..cubicTo(
        center.dx - scale * 0.48,
        center.dy + scale * 0.08,
        center.dx - scale * 0.52,
        center.dy - scale * 0.42,
        center.dx,
        center.dy - scale * 0.55,
      )
      ..close();

    canvas.drawPath(path, Paint()..color = primary.withValues(alpha: fillAlpha));
    canvas.drawPath(
      path,
      Paint()
        ..color = primary.withValues(alpha: strokeAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  void _paintStatBars(Canvas canvas, Size size) {
    final rng = math.Random(23);
    final baseY = size.height * 0.68;
    for (var i = 0; i < 7; i++) {
      final x = size.width * (0.12 + i * 0.11);
      final barH = 24 + rng.nextDouble() * 56;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, baseY - barH, 14, barH),
        const Radius.circular(4),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = primary.withValues(alpha: 0.08 + rng.nextDouble() * 0.06),
      );
    }
  }

  void _paintClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.55);
    _drawCloud(canvas, cloudPaint, Offset(size.width * 0.18, size.height * 0.08), 48);
    _drawCloud(canvas, cloudPaint, Offset(size.width * 0.55, size.height * 0.05), 40);
    _drawCloud(
      canvas,
      cloudPaint..color = Colors.white.withValues(alpha: 0.32),
      Offset(size.width * 0.78, size.height * 0.12),
      34,
    );
  }

  void _drawCloud(Canvas canvas, Paint paint, Offset origin, double scale) {
    canvas.drawCircle(origin, scale * 0.42, paint);
    canvas.drawCircle(origin + Offset(scale * 0.35, -scale * 0.08), scale * 0.34, paint);
    canvas.drawCircle(origin + Offset(-scale * 0.32, scale * 0.04), scale * 0.28, paint);
  }

  void _paintRollingHills(Canvas canvas, Size size, {double hillAlpha = 1.0}) {
    final far = Path()
      ..moveTo(0, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.5, size.width * 0.5, size.height * 0.56)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.62, size.width, size.height * 0.52)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      far,
      Paint()..color = primary.withValues(alpha: 0.22 * hillAlpha),
    );

    final near = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.66, size.width * 0.42, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.68, size.height * 0.82, size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      near,
      Paint()..color = primary.withValues(alpha: 0.34 * hillAlpha),
    );
  }

  void _paintVillagePath(Canvas canvas, Size size, {double alpha = 0.55}) {
    final path = Path()
      ..moveTo(size.width * 0.08, size.height)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.88, size.width * 0.62, size.height * 0.94)
      ..quadraticBezierTo(size.width * 0.88, size.height * 0.98, size.width * 0.95, size.height);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFD4C4A8).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintIsometricGrid(
    Canvas canvas,
    Size size, {
    required double startFactor,
    required double intensity,
  }) {
    const spacing = 26.0;
    final startY = size.height * startFactor;
    final rows = ((size.height - startY) / (spacing * 0.52)).ceil() + 2;
    final cols = (size.width / spacing).ceil() + 2;

    for (var row = 0; row < rows; row++) {
      final rowFade = (row / rows).clamp(0.0, 1.0);
      final fillPaint = Paint()
        ..color = primary.withValues(alpha: (0.015 + rowFade * 0.025) * intensity);
      final strokePaint = Paint()
        ..color = primary.withValues(alpha: (0.035 + rowFade * 0.05) * intensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9;

      for (var col = -1; col < cols; col++) {
        final cx = col * spacing + (row.isOdd ? spacing * 0.5 : 0);
        final cy = startY + row * spacing * 0.52;
        _drawIsoDiamond(canvas, Offset(cx, cy), spacing * 0.46, fillPaint, strokePaint);
      }
    }
  }

  void _drawIsoDiamond(
    Canvas canvas,
    Offset center,
    double radius,
    Paint fill,
    Paint stroke,
  ) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius * 0.55)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius * 0.55)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final rng = math.Random(_sparkleSeed);
    for (var i = 0; i < 44; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.6 + rng.nextDouble() * 1.4,
        Paint()..color = Colors.white.withValues(alpha: 0.08 + rng.nextDouble() * 0.16),
      );
    }
  }

  void _paintVignette(Canvas canvas, Size size, double strength) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 1.05,
          colors: [Colors.transparent, primary.withValues(alpha: strength)],
          stops: const [0.55, 1.0],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant AppScreenBackgroundPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary ||
        oldDelegate.variant != variant;
  }
}
