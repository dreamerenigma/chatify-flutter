import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import 'package:heroicons/heroicons.dart';

class EmojiPanel extends StatelessWidget {
  final void Function(String emoji)? onEmojiTap;
  final VoidCallback? onAddTap;

  const EmojiPanel({
    super.key,
    this.onEmojiTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    List<String> emojis = ['👍', '❤️', '😂', '😮', '😥', '🙏'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...emojis.map((emoji) => _buildEmojiButton(context, emoji)),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildEmojiButton(BuildContext context, String emoji) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Text(emoji, style: TextStyle(fontSize: ChatifySizes.fontSizeXl)),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: () {
          log('Add button clicked');
        },
        borderRadius: BorderRadius.circular(30),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: ChatifyColors.transparent,
            child: HeroIcon(HeroIcons.plus, size: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ),
      ),
    );
  }
}
