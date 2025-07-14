import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/emoji_data.dart';
import '../../../../utils/constants/app_colors.dart';

void showEmojiVariantDialog({
  required BuildContext emojiContext,
  required BuildContext overlayContext,
  required String baseEmoji,
  required Function(String) onVariantSelected,
}) {
  final RenderBox emojiBox = emojiContext.findRenderObject() as RenderBox;
  final RenderBox overlayBox = Overlay.of(overlayContext).context.findRenderObject() as RenderBox;
  final Offset emojiPosition = emojiBox.localToGlobal(Offset.zero, ancestor: overlayBox);
  final variants = peopleEmojisVariants[baseEmoji]!;
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => overlayEntry.remove(),
              behavior: HitTestBehavior.translucent,
              child: Container(),
            ),
          ),
          Positioned(
            left: emojiPosition.dx - 120,
            top: emojiPosition.dy - 55,
            child: Material(
              color: ChatifyColors.transparent,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: variants.map((variant) {
                    return GestureDetector(
                      onTap: () {
                        onVariantSelected(variant);
                        overlayEntry.remove();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(variant, style: TextStyle(fontSize: 28)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Overlay.of(overlayContext).insert(overlayEntry);
}
