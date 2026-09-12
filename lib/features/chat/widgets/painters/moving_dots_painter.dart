import 'dart:math' as math;
import 'package:flutter/material.dart';

class MovingDotsPainter extends CustomPainter {
  final double progress;
  final double level;
  final Color color;

  MovingDotsPainter({
    required this.progress,
    required this.level,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    const double spacing = 8.0;
    const double dotRadius = 1.7;

    final double centerY = size.height / 2;
    final double normalizedLevel = level.clamp(0.0, 1.0);
    final int dotCount = (size.width / spacing).ceil() + 10;
    final double offset = progress * spacing * 10;

    for (int i = -10; i < dotCount; i++) {
      final double x = i * spacing - offset;

      if (x < -spacing || x > size.width + spacing) {
        continue;
      }

      final double random = _noise(i);
      final double wave = normalizedLevel * random;
      final int verticalDots = math.max(1, (wave * 5).round());

      if (verticalDots == 1) {
        canvas.drawCircle(Offset(x, centerY), dotRadius, paint);
        continue;
      }

      for (int j = 0; j < verticalDots; j++) {
        final double y = centerY + (j - (verticalDots - 1) / 2) * spacing;

        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  double _noise(int index) {
    final double value = math.sin(index * 12.9898 + 78.233);

    return (value.abs() * 43758.5453) % 1.0;
  }

  @override
  bool shouldRepaint(covariant MovingDotsPainter oldDelegate,) {
    return oldDelegate.progress != progress || oldDelegate.level != level || oldDelegate.color != color;
  }
}
