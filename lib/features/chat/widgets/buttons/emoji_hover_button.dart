import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_icons/iconoir_icons.dart';
import '../../../../utils/constants/app_colors.dart';
import '../dialogs/edit_message_dialog.dart';

class EmojiHoverButton extends StatefulWidget {
  final GlobalKey containerKey;

  const EmojiHoverButton({super.key, required this.containerKey});

  @override
  State<EmojiHoverButton> createState() => _EmojiHoverButtonState();
}

class _EmojiHoverButtonState extends State<EmojiHoverButton> {
  bool isHovered = false;
  bool isPressed = false;
  bool isDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            isPressed = true;
            isDialogVisible = true;
          });

          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          showEditMessageDialog(context, position, widget.containerKey, openAbove: false).then((_) {
            setState(() {
              isDialogVisible = false;
            });
          });
        },
        mouseCursor: SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(25),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: MouseRegion(
          onEnter: (_) {
            if (!isDialogVisible) {
              setState(() {
                isHovered = true;
              });
            }
          },
          onExit: (_) {
            if (!isDialogVisible) {
              setState(() {
                isHovered = false;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Iconoir(IconoirIcons.emoji, size: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                const SizedBox(width: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(0, isPressed ? 2.0 : 0, 0),
                  child: Icon(Icons.keyboard_arrow_down_sharp, size: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
