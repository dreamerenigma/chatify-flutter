import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class EmojiToolbar extends StatelessWidget {
  final List<String> emojis;
  final Set<String> selectedReactions;
  final VoidCallback onAddPressed;
  final VoidCallback onToggleKeyboard;
  final Function(String) onReactionPressed;

  const EmojiToolbar({
    super.key,
    required this.emojis,
    required this.selectedReactions,
    required this.onAddPressed,
    required this.onToggleKeyboard,
    required this.onReactionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey, borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 2),
                  child: ScrollConfiguration(
                    behavior: const EmojiScrollBehavior(),
                    child: SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...emojis.map((emoji) {
                            final isSelected = selectedReactions.contains(emoji);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => onReactionPressed(emoji),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: isSelected
                                    ? BoxDecoration(color: context.isDarkMode ? ChatifyColors.buttonLightGrey : ChatifyColors.white, shape: BoxShape.circle)
                                    : null,
                                  alignment: Alignment.center,
                                  child: Center(child: Text(emoji, style: TextStyle(fontSize: ChatifySizes.fontSizeGl, fontWeight: FontWeight.w400))),
                                ),
                              ),
                            );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey, (context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey).withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      width: 15,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            (context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey).withAlpha(0), context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggleKeyboard,
              child: const CircleAvatar(
                radius: 17,
                backgroundColor: ChatifyColors.darkerGrey,
                child: Icon(Icons.add, color: ChatifyColors.darkGrey, size: 21),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiScrollBehavior extends ScrollBehavior {
  const EmojiScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(axisDirection: details.direction, child: child);
  }
}
