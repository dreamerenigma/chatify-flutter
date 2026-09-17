import 'dart:math' as math;
import 'package:flutter/material.dart';

class VoiceTrackPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color activeColor;
  final Color markerColor;

  const VoiceTrackPainter({
    required this.progress,
    required this.color,
    required this.activeColor,
    required this.markerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final inactivePaint = Paint()..color = color..strokeWidth = 2..strokeCap = StrokeCap.round;
    final activePaint = Paint()..color = activeColor..strokeWidth = 2..strokeCap = StrokeCap.round;

    const markerRadius = 7.0;
    const horizontalPadding = 0;
    const barCount = 32;

    final minX = markerRadius + horizontalPadding;
    final maxX = size.width - markerRadius - horizontalPadding;
    final spacing = (maxX - minX) / (barCount - 1);

    for (int i = 0; i < barCount; i++) {
      final x = minX + i * spacing;
      final wave = math.sin(i * 0.8) * 0.5 + 0.5;
      final height = 4 + wave * (size.height - 8);
      final isActive = i / (barCount - 1) <= progress;

      canvas.drawLine(Offset(x, centerY - height / 2), Offset(x, centerY + height / 2), isActive ? activePaint : inactivePaint);
    }

    final markerX = minX + (maxX - minX) * progress;
    final markerPaint = Paint()..color = markerColor;

    canvas.drawCircle(Offset(markerX, centerY), markerRadius, markerPaint);
  }

  @override
  bool shouldRepaint(covariant VoiceTrackPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.activeColor != activeColor || oldDelegate.markerColor != markerColor;
  }
}
