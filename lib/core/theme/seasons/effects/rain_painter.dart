import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RainPainter extends CustomPainter {
  final List<Raindrop> raindrops;
  final ui.Image raindropImage;

  RainPainter(this.raindrops, this.raindropImage);

  @override
  void paint(Canvas canvas, Size size) {
    for (final raindrop in raindrops) {
      final rect = Rect.fromLTWH(
        raindrop.x - raindrop.radius,
        raindrop.y - raindrop.radius,
        raindrop.radius * 2,
        raindrop.radius * 2,
      );
      canvas.drawImageRect(
        raindropImage,
        Rect.fromLTWH(0, 0, raindropImage.width.toDouble(), raindropImage.height.toDouble()),
        rect,
        Paint(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Raindrop {
  double x;
  double y;
  double radius;
  double speed;
  double angle;
  String asset;
  List<Offset> trail = [];
  double sizeVariation;
  int trailLength;

  Raindrop({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.asset,
    required this.trail,
    required this.sizeVariation,
    required this.trailLength,
  });
}
