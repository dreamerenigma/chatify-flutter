import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class TrianglePainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  TrianglePainter({
    required this.fillColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = fillColor..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 1;
    final shadowPaint = Paint()..color = ChatifyColors.black.withAlpha((0.2 * 255).toInt())..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 3, 0)
      ..quadraticBezierTo(size.width, 0, size.width - 1, 3)
      ..lineTo(1, size.height - 1)
      ..quadraticBezierTo(0, size.height, 0, size.height - 3)
      ..close();

    canvas.save();
    canvas.translate(1.5, 1.5);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();
    canvas.drawPath(path, fillPaint);

    final borderPath = Path()
      ..moveTo(size.width - 3, 0)
      ..quadraticBezierTo(size.width, 0, size.width - 1, 3)
      ..lineTo(1, size.height - 1)
      ..quadraticBezierTo(0, size.height, 0, size.height - 3);

    canvas.drawPath(borderPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.fillColor != fillColor || oldDelegate.borderColor != borderColor;
  }
}
