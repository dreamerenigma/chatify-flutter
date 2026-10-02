import 'package:flutter/material.dart';

class QrScannerOverlayPainter extends CustomPainter {
  final Color borderColor;

  const QrScannerOverlayPainter({
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.55)..style = PaintingStyle.fill;

    const scanSize = 260.0;
    const borderRadius = 8.0;

    final left = (size.width - scanSize) / 2;
    final top = (size.height - scanSize) / 2;
    final scanRect = RRect.fromRectAndRadius(Rect.fromLTWH(left, top, scanSize, scanSize), const Radius.circular(borderRadius));
    final overlayPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height))..addRRect(scanRect)..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant QrScannerOverlayPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor;
  }
}
