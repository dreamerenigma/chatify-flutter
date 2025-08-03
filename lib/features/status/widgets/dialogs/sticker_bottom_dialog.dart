import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class StickerBottomSheet extends StatelessWidget {
  final VoidCallback onClose;

  const StickerBottomSheet({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Icons.tag_faces,
      ChatifyVectors.avatar,
      PhosphorIcons.sticker,
    ];

    final bottomIcons = [
      Icons.emoji_emotions,
      Icons.favorite,
      Icons.star,
      Icons.cake,
      Icons.flash_on,
      Icons.music_note,
      Icons.face,
      Icons.wb_sunny,
      Icons.ac_unit,
    ];

    Widget buildIcon(dynamic icon, {double size = 24}) {
      if (icon is String && icon.endsWith('.svg')) {
        return SvgPicture.asset(icon, width: size, height: size);
      } else if (icon is IconData) {
        return Icon(icon, size: size);
      } else {
        return const SizedBox();
      }
    }

    return FractionallySizedBox(
      heightFactor: 0.96,
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.search, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: ChatifyColors.darkerGrey,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: tabs.map((icon) {
                        final isSelected = icon == tabs[1];
                        return Container(
                          width: 65,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? ChatifyColors.blackGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.darkerGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? ChatifyColors.white : ChatifyColors.darkerGrey, width: 1.5),
                          ),
                          child: Center(child: buildIcon(icon)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: bottomIcons.map((icon) {
                    return Icon(icon, size: 24);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
