import 'dart:async';
import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pauseDuration;
  final Duration scrollDuration;

  const MarqueeText({
    super.key,
    required this.text,
    this.style,
    this.pauseDuration = const Duration(seconds: 30),
    this.scrollDuration = const Duration(seconds: 8),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  final ScrollController _controller = ScrollController();
  bool _shouldScroll = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  @override
  void didUpdateWidget(covariant MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkOverflow();
      });
    }
  }

  void _checkOverflow() {
    if (!mounted || !_controller.hasClients) return;

    final maxScroll = _controller.position.maxScrollExtent;
    final shouldScroll = maxScroll > 0;

    if (_shouldScroll != shouldScroll) {
      setState(() {
        _shouldScroll = shouldScroll;
      });
    }

    if (shouldScroll) {
      _startAnimationCycle();
    }
  }

  void _startAnimationCycle() {
    _timer?.cancel();

    if (!_shouldScroll || !mounted) return;

    _controller.jumpTo(0);

    _timer = Timer(widget.pauseDuration, () {
      _scrollText();
    });
  }

  Future<void> _scrollText() async {
    if (!mounted || !_shouldScroll || !_controller.hasClients) {
      return;
    }

    await _controller.animateTo(_controller.position.maxScrollExtent, duration: widget.scrollDuration, curve: Curves.linear);

    if (!mounted || !_shouldScroll) return;

    _timer = Timer(widget.pauseDuration, () {
      _scrollText();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Text(widget.text, maxLines: 1, softWrap: false, style: widget.style),
          ),
        );
      },
    );
  }
}
