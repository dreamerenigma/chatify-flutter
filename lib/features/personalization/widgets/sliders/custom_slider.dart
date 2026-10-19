import 'dart:math' as math;

import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../dialogs/light_dialog.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: CustomSliderThumbShape(
          iconLow: ChatifyVectors.brightnessLow,
          iconMedium: ChatifyVectors.brightnessMedium,
          iconHigh: ChatifyVectors.brightnessHigh,
        ),
        trackHeight: 4.0,
        activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        inactiveTrackColor: ChatifyColors.grey,
        overlayColor: ChatifyColors.transparent,
        thumbColor:  context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
      ),
      child: Slider(value: value, onChanged: onChanged),
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final String iconLow;
  final String iconMedium;
  final String iconHigh;

  CustomSliderThumbShape({
    required this.iconLow,
    required this.iconMedium,
    required this.iconHigh,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final canvas = context.canvas;

    const double thumbSize = 40.0;
    const double radius = thumbSize / 2;

    final Color thumbColor = sliderTheme.thumbColor ?? ChatifyColors.white;
    final Color fillColor = sliderTheme.activeTrackColor ?? ChatifyColors.grey;

    final double trackStart = textDirection == TextDirection.ltr ? radius : parentBox.size.width - radius;
    final double fillStart = textDirection == TextDirection.ltr ? math.min(trackStart, center.dx) : math.max(trackStart, center.dx);
    final double fillWidth = (center.dx - trackStart).abs();

    if (fillWidth > 0) {
      final Rect fillRect = Rect.fromLTRB(fillStart, center.dy - radius, fillStart + fillWidth, center.dy + radius);
      final Paint fillPaint = Paint()..color = fillColor..style = PaintingStyle.fill;

      canvas.drawRRect(RRect.fromRectAndRadius(fillRect, const Radius.circular(radius)), fillPaint);
    }

    const double thumbOffset = 0;

    final double direction = textDirection == TextDirection.ltr ? 1.0 : -1.0;
    final Offset thumbCenter = Offset(center.dx - direction * thumbOffset, center.dy);
    final Rect adjustedThumbRect = Rect.fromCircle(center: thumbCenter, radius: radius);
    final RRect adjustedThumbRRect = RRect.fromRectAndRadius(adjustedThumbRect, const Radius.circular(radius));
    final Paint thumbPaint = Paint()..color = thumbColor..style = PaintingStyle.fill;

    canvas.drawRRect(adjustedThumbRRect, thumbPaint);

    _drawIconInsideThumb(canvas, thumbCenter, value);
  }

  void _drawIconInsideThumb(Canvas canvas, Offset center, double value) {
    final IconData icon;

    if (value < 0.33) {
      icon = Icons.brightness_low;
    } else if (value < 0.66) {
      icon = Icons.brightness_medium;
    } else {
      icon = Icons.brightness_high;
    }

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontFamily: icon.fontFamily, package: icon.fontPackage, color: ChatifyColors.white),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    canvas.save();

    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 2);

    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

    canvas.restore();
  }
}
