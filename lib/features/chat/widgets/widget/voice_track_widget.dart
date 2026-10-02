import 'package:flutter/material.dart';
import '../painters/voice_waveform_painter.dart';

class VoiceTrackWidget extends StatefulWidget {
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

  @override
  State<VoiceTrackWidget> createState() => _VoiceTrackWidgetState();
}

class _VoiceTrackWidgetState extends State<VoiceTrackWidget> {
  final List<double> _amplitudes = [];

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
            widget.onChanged(_calculateProgress(details.localPosition, constraints.maxWidth));
          },
          onHorizontalDragUpdate: (details) {
            widget.onChanged(_calculateProgress(details.localPosition, constraints.maxWidth));
          },
          child: CustomPaint(
            painter: VoiceWaveformPainter(progress: widget.progress, color: widget.color, activeColor: widget.activeColor, markerColor: widget.markerColor, amplitudes: _amplitudes),
            size: Size(constraints.maxWidth, 30),
          ),
        );
      },
    );
  }
}
