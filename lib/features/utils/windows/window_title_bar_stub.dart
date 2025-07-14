import 'package:flutter/widgets.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({
    super.key,
    required this.overlayEntry,
    required this.backButtonNotifier,
    required this.currentRouteNotifier,
  });

  final OverlayEntry overlayEntry;
  final ValueNotifier<bool> backButtonNotifier;
  final ValueNotifier<String?> currentRouteNotifier;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
