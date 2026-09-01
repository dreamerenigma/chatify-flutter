import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/app_colors.dart';

class ActionOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double width;
  final double height;

  const ActionOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.width = 65,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Material(
            color: ChatifyColors.softNight,
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(40),
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              child: Center(child: Icon(icon, size: 26, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: width,
          child: Text(
            label,
            style: const TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
