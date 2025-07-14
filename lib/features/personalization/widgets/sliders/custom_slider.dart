import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
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
        thumbShape: CustomSliderThumbShape(),
        trackHeight: 4.0,
        activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        inactiveTrackColor: ChatifyColors.grey,
        overlayColor: ChatifyColors.transparent,
        thumbColor:  context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24.0, 24.0);
  }

  @override
  void paint(PaintingContext context, Offset center,
    {required SliderThemeData sliderTheme,
      required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required Size sizeWithOverflow,
      required TextDirection textDirection,
      required double textScaleFactor,
      required double value
    }) {
    final Canvas canvas = context.canvas;
    final Paint thumbPaint = Paint()..color = sliderTheme.thumbColor!..style = PaintingStyle.fill;
    const Radius thumbRadius = Radius.circular(12.0);
    final Rect thumbRect = Rect.fromCenter(center: center, width: 24.0, height: 24.0);
    final RRect thumbRRect = RRect.fromRectAndRadius(thumbRect, thumbRadius);

    canvas.drawRRect(thumbRRect, thumbPaint);

    _drawIconInsideThumb(canvas, center);
  }

  void _drawIconInsideThumb(Canvas canvas, Offset center) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.dark_mode_outlined.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: Icons.dark_mode_outlined.fontFamily,
          color: colorsController.getColor(colorsController.selectedColorScheme.value),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    const double thumbSize = 24.0;
    const double iconSize = thumbSize * 0.6;
    final Offset iconOffset = Offset(center.dx - iconSize / 1.2, center.dy - iconSize / 1.2);

    textPainter.paint(canvas, iconOffset);
  }
}
