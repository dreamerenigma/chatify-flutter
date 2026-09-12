import 'package:flutter/material.dart';

class MovingLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  MovingLinePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 3..strokeCap = StrokeCap.round;

    const double lineWidth = 60;

    final double x = size.width - (progress * (size.width + lineWidth));

    canvas.drawLine(Offset(x, size.height / 2), Offset(x + lineWidth, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant MovingLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
