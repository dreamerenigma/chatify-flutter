import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/panels/emoji_panel.dart';
import '../../../../utils/constants/app_colors.dart';

void showSelectEmojiDialog(BuildContext context, Offset position) {
  final overlay = Overlay.of(context);
  OverlayEntry? overlayEntry;
  OverlayState overlayState = overlay;
  RenderBox renderBox = context.findRenderObject() as RenderBox;
  Offset position = renderBox.localToGlobal(Offset.zero);
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              animationController.reverse().then((_) => overlayEntry?.remove());
            },
          ),
        ),
        Positioned(
          right: position.dx + 5,
          top: position.dy,
          child: SlideTransition(
            position: slideAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 265,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmojiPanel(
                          onEmojiTap: (emoji) {
                            log('Выбран эмодзи: $emoji');
                          },
                          onAddTap: () {
                            log('Нажата кнопка добавления');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlayState.insert(overlayEntry);
  animationController.forward();
}
