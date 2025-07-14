import 'package:flutter/widgets.dart';

class WindowFocusWatcher with WidgetsBindingObserver {
  final VoidCallback onAppUnfocused;

  WindowFocusWatcher({required this.onAppUnfocused}) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      onAppUnfocused();
    }
  }
}
