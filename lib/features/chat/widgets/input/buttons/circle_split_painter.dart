import 'package:flutter/material.dart';

class CircleSplitPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  CircleSplitPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Slight overlap to prevent the white line
    const double overlapAngle = 0.01;

    // Draw the first half
    paint.color = color1;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14 - overlapAngle, // Start slightly before 180 degrees
      3.14 + overlapAngle * 2, // Draw slightly more than half a circle
      true,
      paint,
    );

    // Draw the second half
    paint.color = color2;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -overlapAngle, // Start slightly before 0 degrees
      3.14 + overlapAngle * 2, // Draw slightly more than half a circle
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
