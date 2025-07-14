import 'dart:async';
import 'dart:ui';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/controllers/emoji_stickers_controller.dart';
import '../widget/emoji_content_widget.dart';
import '../widget/gif_content_widget.dart';
import '../widget/sticker_content_widget.dart';

Offset? lastPosition;

Future<void> showEmojiStickersDialog(
  BuildContext context,
  Offset position,
  Function(String) onEmojiSelected,
  Function(String) onGifSelected, {
  double width = 465,
  double leftOffset = 210,
  double bottomOffset = 8,
  bool hideTabButton = false,
  double topPadding = 20,
}) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final TextEditingController emojiController = TextEditingController();
  final TextEditingController stickerController = TextEditingController();
  final EmojiStickersController controller = Get.put(EmojiStickersController());
  final FocusNode focusNode = FocusNode();
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final ScrollController scrollController = ScrollController();
  GlobalKey categoryKey0 = GlobalKey();
  GlobalKey categoryKey1 = GlobalKey();
  GlobalKey categoryKey2 = GlobalKey();
  GlobalKey categoryKey3 = GlobalKey();
  GlobalKey categoryKey4 = GlobalKey();
  GlobalKey categoryKey5 = GlobalKey();
  GlobalKey categoryKey6 = GlobalKey();
  GlobalKey categoryKey7 = GlobalKey();
  GlobalKey categoryKey8 = GlobalKey();
  position = lastPosition ?? position;

  Future<void> closeOverlay() async {
    animationController.reverse().then((_) {
      overlayEntry.remove();
      completer.complete();
      lastPosition = position;
    });
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: closeOverlay)),
          Positioned(
            left: position.dx - leftOffset,
            bottom: position.dy + bottomOffset,
            child: SlideTransition(
              position: slideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: width,
                    height: 425,
                    decoration: BoxDecoration(
                      color: (context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey).withAlpha((0.9 * 255).toInt()),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!hideTabButton)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildTabButton('Смайлики', 0, controller, context),
                                SizedBox(width: 12),
                                _buildTabButton('GIF', 1, controller, context),
                                SizedBox(width: 12),
                                _buildTabButton('Стикеры', 2, controller, context),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Obx(() {
                              switch (controller.selectedIndex.value) {
                                case 0:
                                  return EmojiContentWidget(
                                    emojiController: emojiController,
                                    focusNode: focusNode,
                                    controller: controller,
                                    scrollController: scrollController,
                                    onEmojiSelected: onEmojiSelected,
                                    categoryKey0: categoryKey0,
                                    categoryKey1: categoryKey1,
                                    categoryKey2: categoryKey2,
                                    categoryKey3: categoryKey3,
                                    categoryKey4: categoryKey4,
                                    categoryKey5: categoryKey5,
                                    categoryKey6: categoryKey6,
                                    categoryKey7: categoryKey7,
                                    categoryKey8: categoryKey8,
                                    topPadding: topPadding,
                                  );
                                case 1:
                                  return GifContentWidget(
                                    stickerController: stickerController,
                                    focusNode: focusNode,
                                    controller: controller,
                                    scrollController: scrollController,
                                    onGifSelected: onGifSelected,
                                    onEmojiSelected: onEmojiSelected,
                                    onCloseParentOverlay: closeOverlay,
                                  );
                                case 2:
                                  return StickerContentWidget();
                                default:
                                  return SizedBox.shrink();
                              }
                            }),
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
      );
    }
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  return completer.future;
}

Widget _buildTabButton(String label, int index, EmojiStickersController controller, BuildContext context) {
  return InkWell(
    onTap: () {
      controller.selectedIndex.value = index;
    },
    mouseCursor: SystemMouseCursors.basic,
    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
    child: Obx(() => Text(
      label,
      style: TextStyle(
        color: controller.selectedIndex.value == index
          ? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)
          : (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey),
        fontSize: ChatifySizes.fontSizeLg,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    )),
  );
}
