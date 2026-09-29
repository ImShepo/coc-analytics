import 'package:flutter/material.dart';

class TrophySparkline extends StatelessWidget {
  final List<int> values;

  const TrophySparkline({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: CustomPaint(
        painter: _TrophySparklinePainter(values: values),
      ),
    );
  }
}

class _TrophySparklinePainter extends CustomPainter {
  final List<int> values;

  _TrophySparklinePainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.width <= 0 || size.height <= 0) return;

    final minValue = values.reduce((a, b) => a < b ? a : b).toDouble();
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    final span = (maxValue - minValue).abs();
    final low = span == 0 ? minValue - 1 : minValue;
    final high = span == 0 ? maxValue + 1 : maxValue;

    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          values.length == 1
              ? size.width
              : size.width * i / (values.length - 1),
          _y(values[i].toDouble(), low, high, size.height),
        ),
    ];
    if (values.length == 1) {
      points.insert(0, Offset(0, points.first.dy));
    }

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }

    final fill = Path.from(line)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()..color = Colors.white.withValues(alpha: 0.16),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(
      points.last,
      3.5,
      Paint()..color = Colors.white,
    );
  }

  double _y(double value, double low, double high, double height) {
    const pad = 4.0;
    final t = (value - low) / (high - low);
    return height - pad - t * (height - pad * 2);
  }

  @override
  bool shouldRepaint(covariant _TrophySparklinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
