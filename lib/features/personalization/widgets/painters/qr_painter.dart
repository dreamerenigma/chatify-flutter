import 'package:qr/qr.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class QrPainter extends CustomPainter {
  final QrImage qrImage;
  final double finderScale;

  QrPainter({
    required this.qrImage,
    this.finderScale = 0.72,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ChatifyColors.black..style = PaintingStyle.fill;
    final count = qrImage.moduleCount;
    final moduleSize = size.width / count;

    for (int y = 0; y < count; y++) {
      for (int x = 0; x < count; x++) {
        if (!qrImage.isDark(y, x)) continue;

        if (_isFinderModule(x, y, count)) {
          continue;
        }

        canvas.drawRect(Rect.fromLTWH(x * moduleSize, y * moduleSize, moduleSize, moduleSize), paint);
      }
    }

    _drawFinder(canvas, 0, 0, moduleSize);
    _drawFinder(canvas, count - 7, 0, moduleSize);
    _drawFinder(canvas, 0, count - 7, moduleSize);
  }

  bool _isFinderModule(int x, int y, int count) {
    final topLeft = x < 7 && y < 7;
    final topRight = x >= count - 7 && y < 7;
    final bottomLeft = x < 7 && y >= count - 7;

    return topLeft || topRight || bottomLeft;
  }

  void _drawFinder(Canvas canvas, int moduleX, int moduleY, double moduleSize) {
    final paint = Paint()..color = ChatifyColors.black..style = PaintingStyle.fill;
    final finderSize = moduleSize * 7 * finderScale;
    final offset = moduleSize * 7 - finderSize;
    final x = moduleX * moduleSize + offset / 2;
    final y = moduleY * moduleSize + offset / 2;

    canvas.drawRect(Rect.fromLTWH(x, y, finderSize, finderSize), paint);

    final whitePaint = Paint()..color = ChatifyColors.white..style = PaintingStyle.fill;
    final innerSize = finderSize * 5 / 7;

    canvas.drawRect(Rect.fromLTWH(x + (finderSize - innerSize) / 2, y + (finderSize - innerSize) / 2, innerSize, innerSize), whitePaint);

    final centerSize = finderSize * 3 / 7;

    canvas.drawRect(Rect.fromLTWH(x + (finderSize - centerSize) / 2, y + (finderSize - centerSize) / 2, centerSize, centerSize), paint);
  }

  @override
  bool shouldRepaint(covariant QrPainter oldDelegate) {
    return oldDelegate.qrImage != qrImage || oldDelegate.finderScale != finderScale;
  }
}
