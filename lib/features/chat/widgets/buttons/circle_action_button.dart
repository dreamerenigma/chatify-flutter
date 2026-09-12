import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsets? iconPadding;

  const CircleActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconPadding,
  });

  @override
  Widget build(BuildContext context) {
    final Color containerColor = backgroundColor ?? (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightGrey);
    final Color resolvedIconColor = iconColor ?? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black);

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(28),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: Ink(
          width: 52,
          height: 52,
          decoration: BoxDecoration(shape: BoxShape.circle, color: containerColor),
          child: Padding(padding: iconPadding ?? EdgeInsets.zero, child: Icon(icon, size: 26, color: resolvedIconColor)),
        ),
      ),
    );
  }
}
