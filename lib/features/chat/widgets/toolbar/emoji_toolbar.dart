import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class EmojiToolbar extends StatelessWidget {
  final List<String> emojis;
  final VoidCallback onAddPressed;
  final VoidCallback onToggleKeyboard;
  final Function(String) onReactionPressed;

  const EmojiToolbar({
    super.key,
    required this.emojis,
    required this.onAddPressed,
    required this.onToggleKeyboard,
    required this.onReactionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...emojis.map((emoji) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onReactionPressed(emoji),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: onToggleKeyboard,
              child: const CircleAvatar(
                backgroundColor: ChatifyColors.darkerGrey,
                child: Icon(Icons.add, color: ChatifyColors.darkGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
