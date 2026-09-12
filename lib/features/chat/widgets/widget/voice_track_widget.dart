import 'package:flutter/material.dart';
import '../painters/voice_track_painter.dart';

class VoiceTrackWidget extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onChanged;
  final Color color;
  final Color activeColor;
  final Color markerColor;

  const VoiceTrackWidget({
    super.key,
    required this.progress,
    required this.onChanged,
    required this.color,
    required this.activeColor,
    required this.markerColor,
  });

  double _calculateProgress(Offset localPosition, double width) {
    return (localPosition.dx / width).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            onChanged(_calculateProgress(details.localPosition, constraints.maxWidth));
          },
          onHorizontalDragUpdate: (details) {
            onChanged(_calculateProgress(details.localPosition, constraints.maxWidth));
          },
          child: CustomPaint(
            painter: VoiceTrackPainter(progress: progress, color: color, activeColor: activeColor, markerColor: markerColor),
            size: Size(constraints.maxWidth, 30),
          ),
        );
      },
    );
  }
}
