import 'package:flutter/material.dart';

class WindowObserver extends WidgetsBindingObserver {
  final Function(Size, Offset) onSizeChanged;

  WindowObserver({required this.onSizeChanged});

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    onSizeChanged(size, Offset(0, 0));
  }
}

