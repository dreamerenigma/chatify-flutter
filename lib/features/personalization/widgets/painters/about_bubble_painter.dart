import 'package:flutter/material.dart';

class AboutBubblePainter extends CustomPainter {
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double circleRadius;
  final double circleCenterX;
  final double circleCenterY;

  AboutBubblePainter({
    required this.borderColor,
    required this.backgroundColor,
    required this.radius,
    required this.circleRadius,
    required this.circleCenterX,
    required this.circleCenterY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final fillPaint = Paint()..color = backgroundColor..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 1;
    final bubble = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    canvas.drawRRect(bubble, fillPaint);
    canvas.drawRRect(bubble, borderPaint);
    canvas.drawCircle(Offset(circleCenterX, circleCenterY), circleRadius, fillPaint);
    canvas.drawCircle(Offset(circleCenterX, circleCenterY), circleRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant AboutBubblePainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.radius != radius ||
      oldDelegate.circleRadius != circleRadius ||
      oldDelegate.circleCenterX != circleCenterX ||
      oldDelegate.circleCenterY != circleCenterY;
  }
}
