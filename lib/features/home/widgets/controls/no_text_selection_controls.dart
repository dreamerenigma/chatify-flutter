import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NoTextSelectionControls extends TextSelectionControls {
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
    ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildHandle(
      BuildContext context,
      TextSelectionHandleType type,
      double textLineHeight, [
        void Function()? onTap,
      ]) {
    return const SizedBox.shrink();
  }

  @override
  Size getHandleSize(double textLineHeight) => Size.zero;

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) => Offset.zero;

  @override
  bool canCopy(TextSelectionDelegate delegate) => false;

  @override
  bool canCut(TextSelectionDelegate delegate) => false;

  @override
  bool canPaste(TextSelectionDelegate delegate) => false;

  @override
  bool canSelectAll(TextSelectionDelegate delegate) => false;

  @override
  void handleCopy(TextSelectionDelegate delegate) {}

  @override
  void handleCut(TextSelectionDelegate delegate) {}

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) async {}

  @override
  void handleSelectAll(TextSelectionDelegate delegate) {}
}
