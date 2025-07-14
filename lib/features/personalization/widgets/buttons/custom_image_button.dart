import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomImageButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const CustomImageButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      mouseCursor: SystemMouseCursors.basic,
      splashFactory: NoSplash.splashFactory,
      splashColor: ChatifyColors.transparent,
      borderRadius: BorderRadius.circular(8),
      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
        child: icon,
      ),
    );
  }
}
