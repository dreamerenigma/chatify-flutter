import 'package:flutter/material.dart';

class CircleSplitPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  CircleSplitPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    const double overlapAngle = 0.01;

    paint.color = color1;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14 - overlapAngle,
      3.14 + overlapAngle * 2,
      true,
      paint,
    );

    paint.color = color2;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -overlapAngle,
      3.14 + overlapAngle * 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
