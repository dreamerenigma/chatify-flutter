import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class PressScaleIcon extends StatefulWidget {
  final Widget child;
  final Color pressedColor;
  final double scale;
  final bool isPressed;

  const PressScaleIcon({
    super.key,
    required this.child,
    required this.pressedColor,
    required this.isPressed,
    this.scale = 0.93,
  });

  @override
  State<PressScaleIcon> createState() => _PressScaleIconState();
}

class _PressScaleIconState extends State<PressScaleIcon> {
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isPressed ? widget.scale : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: ColorFiltered(
        colorFilter: widget.isPressed ? ColorFilter.mode(widget.pressedColor, BlendMode.srcIn) : const ColorFilter.mode(ChatifyColors.transparent, BlendMode.dst),
        child: widget.child,
      ),
    );
  }
}
