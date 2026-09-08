import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/enums/snack_bar_position_type.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AnimatedSnackBar extends StatefulWidget {
  final String message;
  final Widget? icon;
  final Color? iconColor;
  final SnackBarPositionType position;

  const AnimatedSnackBar({
    super.key,
    required this.message,
    this.icon,
    this.iconColor,
    this.position = SnackBarPositionType.top,
  });

  @override
  AnimatedSnackBarState createState() => AnimatedSnackBarState();
}

class AnimatedSnackBarState extends State<AnimatedSnackBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    final Offset beginOffset = widget.position == SnackBarPositionType.top ? const Offset(0.0, -1.0) : const Offset(0.0, 1.0);

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _offsetAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero,).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  Future<void> hideSnackBar() async {
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SlideTransition(
        position: _offsetAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20,),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: context.isDarkMode ? [ChatifyColors.white.withAlpha(35), ChatifyColors.white.withAlpha(15)] : [ChatifyColors.white.withAlpha(150), ChatifyColors.white.withAlpha(80)],
                ),
                border: Border.all(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white.withAlpha(180), width: 1),
                boxShadow: [
                  BoxShadow(color: ChatifyColors.black.withAlpha(context.isDarkMode ? 70 : 25), blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 6)),
                  BoxShadow(color: ChatifyColors.white.withAlpha(context.isDarkMode ? 12 : 70,), blurRadius: 10, spreadRadius: -2, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: widget.icon != null ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    IconTheme(data: IconThemeData(color: widget.iconColor ?? ChatifyColors.white), child: widget.icon!),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: context.isDarkMode ? ChatifyColors.white.withAlpha(220) : ChatifyColors.black.withAlpha(210),
                        fontSize: ChatifySizes.fontSizeMd,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                      ),
                      textAlign: widget.icon != null ? TextAlign.start : TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
