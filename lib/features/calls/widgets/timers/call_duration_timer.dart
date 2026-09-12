import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class CallDurationTimer extends StatefulWidget {
  final bool isRunning;

  const CallDurationTimer({
    super.key,
    required this.isRunning,
  });

  @override
  State<CallDurationTimer> createState() => _CallDurationTimerState();
}

class _CallDurationTimerState extends State<CallDurationTimer> {
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    if (widget.isRunning) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant CallDurationTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRunning && !oldWidget.isRunning) {
      _startTimer();
    } else if (!widget.isRunning && oldWidget.isRunning) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          _duration += const Duration(seconds: 1);
        });
      },
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_duration),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: ChatifySizes.fontSizeSm,
        color: ChatifyColors.grey,
        shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
      ),
    );
  }
}
