import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LeafPainter extends CustomPainter {
  final List<AutumnLeaf> autumnLeafs;
  final ui.Image autumnLeafImage;

  LeafPainter(this.autumnLeafs, this.autumnLeafImage);

  @override
  void paint(Canvas canvas, Size size) {
    for (final autumnLeaf in autumnLeafs) {
      final rect = Rect.fromLTWH(
        autumnLeaf.x - autumnLeaf.radius,
        autumnLeaf.y - autumnLeaf.radius,
        autumnLeaf.radius * 2,
        autumnLeaf.radius * 2,
      );
      canvas.drawImageRect(
        autumnLeafImage,
        Rect.fromLTWH(0, 0, autumnLeafImage.width.toDouble(), autumnLeafImage.height.toDouble()),
        rect,
        Paint(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AutumnLeaf {
  double x;
  double y;
  double radius;
  double speed;
  double rotation;
  String asset;
  double oscillationAmplitude;
  double oscillationSpeed;
  double oscillationOffset;

  AutumnLeaf({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    this.rotation = 0,
    required this.asset,
    required this.oscillationAmplitude,
    required this.oscillationSpeed,
    required this.oscillationOffset,
  });
}
