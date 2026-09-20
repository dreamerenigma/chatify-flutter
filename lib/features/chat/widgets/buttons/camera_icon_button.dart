import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class CameraIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const CameraIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.iconSize = 27,
    this.backgroundColor = ChatifyColors.lightSoftNight,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor.withAlpha((0.3 * 255).toInt()),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: ChatifyColors.transparent,
        highlightColor: ChatifyColors.transparent,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}