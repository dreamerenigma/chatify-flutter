import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class EmojiMessage extends StatelessWidget {
  final String emoji;
  final bool isHovered;
  final bool isPressed;
  final Color borderColor;

  const EmojiMessage({
    super.key,
    required this.emoji,
    required this.isHovered,
    required this.isPressed,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHovered || isPressed ? borderColor.withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Text(emoji, style: TextStyle(fontSize: 50, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
    );
  }
}
