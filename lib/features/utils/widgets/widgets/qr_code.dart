import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class ChatifyQrCode extends StatelessWidget {
  final String data;
  final double size;
  final double finderScale;
  final Color backgroundColor;
  final Color foregroundColor;

  const ChatifyQrCode({
    super.key,
    required this.data,
    this.size = 180,
    this.finderScale = 1,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode(payload: QrPayload.fromString(data), errorCorrectLevel: QrErrorCorrectLevel.medium);
    final qrImage = QrImage(qrCode);

    return CustomPaint(
      size: Size.square(size),
      painter: _ChatifyQrPainter(qrImage: qrImage, finderScale: finderScale, foregroundColor: foregroundColor, backgroundColor: backgroundColor),
    );
  }
}

class _ChatifyQrPainter extends CustomPainter {
  final QrImage qrImage;
  final double finderScale;
  final Color foregroundColor;
  final Color backgroundColor;

  const _ChatifyQrPainter({
    required this.qrImage,
    required this.finderScale,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final count = qrImage.moduleCount;
    final moduleSize = size.width / count;
    final foregroundPaint = Paint()..color = foregroundColor..style = PaintingStyle.fill;

    for (int y = 0; y < count; y++) {
      for (int x = 0; x < count; x++) {
        if (!qrImage.isDark(y, x)) continue;

        if (_isInsideFinder(
          x,
          y,
          count,
          finderScale,
        )) {
          continue;
        }

        canvas.drawRect(
          Rect.fromLTWH(
            x * moduleSize,
            y * moduleSize,
            moduleSize,
            moduleSize,
          ),
          foregroundPaint,
        );
      }
    }

    _drawFinder(canvas, 0, 0, moduleSize,foregroundPaint);
    _drawFinder(canvas, count - 7, 0, moduleSize, foregroundPaint);
    _drawFinder(canvas, 0, count - 7, moduleSize, foregroundPaint);
  }

  bool _isInsideFinder(int x, int y, int count, double scale) {
    final finderModules = 7 * scale;
    final topLeft = x < finderModules && y < finderModules;
    final topRight = x >= count - finderModules && y < finderModules;
    final bottomLeft = x < finderModules && y >= count - finderModules;

    return topLeft || topRight || bottomLeft;
  }

  void _drawFinder(Canvas canvas, int moduleX, int moduleY, double moduleSize, Paint foregroundPaint) {
    final finderSize = moduleSize * 7 * finderScale;
    final fullSize = moduleSize * 7;

    final offset = (fullSize - finderSize) / 5;
    final x = moduleX * moduleSize + offset;
    final y = moduleY * moduleSize + offset;

    canvas.drawRect(Rect.fromLTWH(x, y, finderSize, finderSize), foregroundPaint);

    final whiteSize = finderSize * 5 / 7;
    final whitePaint = Paint()..color = backgroundColor..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(x + (finderSize - whiteSize) / 2, y + (finderSize - whiteSize) / 2, whiteSize, whiteSize), whitePaint);

    final centerSize = finderSize * 3 / 7;

    canvas.drawRect(Rect.fromLTWH(x + (finderSize - centerSize) / 2, y + (finderSize - centerSize) / 2, centerSize, centerSize), foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant _ChatifyQrPainter oldDelegate) {
    return oldDelegate.qrImage != qrImage ||
      oldDelegate.finderScale != finderScale ||
      oldDelegate.foregroundColor != foregroundColor ||
      oldDelegate.backgroundColor != backgroundColor;
  }
}