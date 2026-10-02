import 'package:flutter/material.dart';

class QrFramePainter extends CustomPainter {
  final Color color;

  const QrFramePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.square;

    const cornerLength = 28.0;

    canvas.drawLine(const Offset(0, cornerLength), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width - cornerLength, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    canvas.drawLine(Offset(0, size.height - cornerLength), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
