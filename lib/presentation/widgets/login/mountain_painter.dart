import 'package:flutter/material.dart';

class MountainPainter extends CustomPainter {
  final Color color;

  MountainPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.8);

    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.76,
      size.width * 0.43, size.height * 0.9,
    );

    path.quadraticBezierTo(
      size.width * 0.6, size.height,
      size.width * 0.7, size.height * 0.85,
    );

    path.quadraticBezierTo(
      size.width * 0.9, size.height * 0.6,
      size.width, size.height * 0.7, 
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
