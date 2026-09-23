import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final ui.Image snowflakeImage;

  SnowPainter(this.snowflakes, this.snowflakeImage);

  @override
  void paint(Canvas canvas, Size size) {
    for (final snowflake in snowflakes) {
      final rect = Rect.fromLTWH(
        snowflake.x - snowflake.radius,
        snowflake.y - snowflake.radius,
        snowflake.radius * 2,
        snowflake.radius * 2,
      );
      canvas.drawImageRect(
        snowflakeImage,
        Rect.fromLTWH(0, 0, snowflakeImage.width.toDouble(), snowflakeImage.height.toDouble()),
        rect,
        Paint(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snowflake {
  double x;
  double y;
  double radius;
  double speed;
  double rotation;
  double oscillationAmplitude;
  double oscillationSpeed;
  double oscillationOffset;

  Snowflake({
    this.x = 0,
    this.y = 0,
    this.radius = 1,
    this.speed = 1,
    this.rotation = 0,
    this.oscillationAmplitude = 0,
    this.oscillationSpeed = 0,
    this.oscillationOffset = 0,
  });
}
