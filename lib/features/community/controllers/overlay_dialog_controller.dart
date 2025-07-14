import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OverlayDialogController {
  static final OverlayDialogController _instance = OverlayDialogController._internal();

  factory OverlayDialogController() => _instance;

  OverlayDialogController._internal();

  OverlayEntry? _currentEntry;
  AnimationController? _currentAnimationController;

  void show({
    required BuildContext context,
    required OverlayEntry entry,
    required AnimationController animationController,
  }) {
    _removeCurrent();
    _currentEntry = entry;
    _currentAnimationController = animationController;
    Overlay.of(context).insert(entry);
    animationController.forward();
  }

  void _removeCurrent() {
    if (_currentEntry != null && _currentAnimationController != null) {
      _currentAnimationController!.reverse().then((_) {
        _currentEntry?.remove();
        _currentEntry = null;
        _currentAnimationController = null;
      });
    }
  }

  void close() => _removeCurrent();
}
