import 'package:flutter/material.dart';
import '../../utils/windows/window_title_bar.dart';

class MainWindow extends StatefulWidget {
  final Widget child;
  final ValueNotifier<bool> backButtonNotifier;
  final ValueNotifier<String?> currentRouteNotifier;

  const MainWindow({
    super.key,
    required this.child,
    required this.backButtonNotifier,
    required this.currentRouteNotifier,
  });

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  late OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    overlayEntry = OverlayEntry(
      builder: (context) {
        return WindowTitleBar(
          overlayEntry: overlayEntry,
          backButtonNotifier: widget.backButtonNotifier,
          currentRouteNotifier: widget.currentRouteNotifier,
        );
      },
    );
  }

  @override
  void dispose() {
    overlayEntry.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WindowTitleBar(
            overlayEntry: overlayEntry,
            backButtonNotifier: widget.backButtonNotifier,
            currentRouteNotifier: widget.currentRouteNotifier,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
