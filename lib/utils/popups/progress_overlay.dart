import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/home/controllers/dialog_controller.dart';
import '../constants/app_colors.dart';

class ProgressOverlay {
  late OverlayEntry _overlayEntry;
  final BuildContext context;
  Timer? _timer;
  int _dotsCount = 0;

  ProgressOverlay(this.context);

  void show() {
    final overlay = Overlay.of(context);
    final dialogController = Get.find<DialogController>();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        dialogController.openWindowsDialog();

        return Material(
          color: ChatifyColors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: close,
                behavior: HitTestBehavior.opaque,
                child: Container(color: ChatifyColors.black.withAlpha((0.3 * 256).toInt())),
              ),
              Center(
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.buttonDarkGrey : ChatifyColors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      _buildDotLoadingIndicator(),
                      const SizedBox(height: 20),
                      Text('Начало чата', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry);

    _startDotAnimation();

    Future.delayed(Duration(seconds: 1), () {
      close();
    });
  }

    Widget _buildDotLoadingIndicator() {
    const int totalDots = 10;
    const double radius = 20;
    final List<Widget> dots = List.generate(totalDots, (index) {
      double angle = (2 * pi / totalDots) * index;

      return Positioned(
        left: radius + radius * cos(angle) - 5,
        top: radius + radius * sin(angle) - 5,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _getDotOpacity(index),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: _getDotColor(index), shape: BoxShape.circle),
          ),
        ),
      );
    });

    return SizedBox(
      width: 2 * radius,
      height: 2 * radius,
      child: Stack(
        clipBehavior: Clip.none,
        children: dots,
      ),
    );
  }

  double _getDotOpacity(int index) {
    if (index <= _dotsCount) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  Color _getDotColor(int index) {
    if (index <= _dotsCount) {
      return ChatifyColors.primary;
    } else {
      return Colors.transparent;
    }
  }

  void _startDotAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _dotsCount = (_dotsCount + 1) % 20;
      if (_overlayEntry.mounted) {
        _overlayEntry.markNeedsBuild();
      }
    });
  }

  void close() {
    _timer?.cancel();
    _overlayEntry.remove();
  }
}
