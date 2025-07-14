import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AnimatedSnackBar extends StatefulWidget {
  final String message;
  final Widget? icon;
  final Color? iconColor;

  const AnimatedSnackBar({super.key, required this.message, this.icon, this.iconColor});

  @override
  AnimatedSnackBarState createState() => AnimatedSnackBarState();
}

class AnimatedSnackBarState extends State<AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _offsetAnimation = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero,).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    final theme = Theme.of(context);

    return SlideTransition(
      position: _offsetAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt())),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
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
                      color: theme.brightness == Brightness.dark ? ChatifyColors.white.withAlpha((0.85 * 255).toInt()) : ChatifyColors.black.withAlpha((0.85 * 255).toInt()),
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
    );
  }
}
