import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class TrianglePainter extends CustomPainter {
  final ui.Image? image;
  final Color fillColor;
  final Color borderColor;

  TrianglePainter({
    this.image,
    this.fillColor = Colors.transparent,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 3, 0)
      ..quadraticBezierTo(size.width, 0, size.width - 1, 3)
      ..lineTo(1, size.height - 1)
      ..quadraticBezierTo(0, size.height, 0, size.height - 3)
      ..close();

    final shadowPaint = Paint()
      ..color = ChatifyColors.black.withAlpha((0.2 * 255).toInt())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.save();
    canvas.translate(1.5, 1.5);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    final Paint fillPaint;

    if (image != null) {
      fillPaint = Paint()
        ..shader = ui.ImageShader(
          image!,
          TileMode.clamp,
          TileMode.clamp,
          (Matrix4.identity()..scale(size.width / image!.width, size.height / image!.height)).storage,
        );
    } else {
      fillPaint = Paint()..color = fillColor..style = PaintingStyle.fill;
    }

    canvas.drawPath(path, fillPaint);

    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 3, 0)
      ..quadraticBezierTo(size.width, 0, size.width - 1, 3)
      ..lineTo(1, size.height - 1)
      ..lineTo(0, size.height - 1);

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(borderPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.fillColor != fillColor || oldDelegate.borderColor != borderColor;
  }
}
