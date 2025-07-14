import 'dart:io';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../home/widgets/dialogs/confirmation_dialog.dart';
import '../../../models/gif_model.dart';
import 'package:flutter/material.dart';
import '../../panels/media_content_bottom_panel.dart';
import '../emoji_stickers_dialog.dart';

Future<void> showSelectGifOverlay(
  BuildContext context,
  Offset position,
  GifModel gif,
  TextEditingController stickerController,
  FocusNode focusNode,
  Function(String) onEmojiSelected,
  Function(String) onGifSelected,
  List<String> frameUrls,
) async {
  final overlay = Overlay.of(context);
  final FocusNode captionFocusNode = FocusNode();
  final ValueNotifier<bool> isFocused = ValueNotifier(false);
  late OverlayEntry overlayEntry;
  late Animation<double> animation;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  animation = Tween<double>(begin: position.dy - 50, end: position.dy).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutQuad));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final List<ImageProvider> frames = frameUrls.map((path) => FileImage(File(path))).toList();

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                showConfirmationDialog(
                  context: context,
                  title: 'Сбросить неотправленное сообщение?',
                  description: 'Ваше сообщение и прикреплённые медиафайлы не будут отправлены, если вы закроете этот экран.',
                  confirmText: 'Сбросить',
                  cancelText: 'Назад',
                  width: 530,
                  onConfirm: () async {
                    Get.back();
                    await animationController.reverse();
                    overlayEntry.remove();

                    final RenderBox renderBox = context.findRenderObject() as RenderBox;
                    final Offset globalPosition = renderBox.localToGlobal(position);

                    await showEmojiStickersDialog(context, globalPosition, onEmojiSelected, onGifSelected);
                  },
                );
              },
            ),
          ),
          Positioned(
            left: position.dx + 200,
            bottom: 53,
            child: SlideTransition(
              position: slideAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    width: 560,
                    decoration: BoxDecoration(
                      color: (context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.9 * 255).toInt()) : ChatifyColors.lightGrey)..withAlpha((0.9 * 255).toInt()),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            _buildTopPanel(context, frames),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Image.network(gif.url, fit: BoxFit.contain),
                              ),
                            ),
                            Column(
                              children: [
                                MediaContentBottomPanel(
                                  isFocused: isFocused,
                                  captionFocusNode: captionFocusNode,
                                  animationController: animationController,
                                  overlayEntry: overlayEntry,
                                  onEmojiSelected: onEmojiSelected,
                                  onGifSelected: onEmojiSelected,
                                  user: APIs.me,
                                  gifUrl: gif.url,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
}

Widget _buildTopPanel(BuildContext context, List<ImageProvider> frames) {
  return Container(
    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softNight, borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 14),
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.grey, borderRadius: BorderRadius.circular(8)),
          child: SvgPicture.asset(ChatifyVectors.arrowLeftWide, width: 27, height: 27, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(9, (index) {
              return Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () {},
                  mouseCursor: SystemMouseCursors.basic,
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Ink(
                      width: 53,
                      height: 36,
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.grey,
                        image: DecorationImage(image: frames[index], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 14),
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.grey, borderRadius: BorderRadius.circular(8)),
          child: SvgPicture.asset(ChatifyVectors.arrowRightWide, width: 27, height: 27, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
        ),
      ],
    ),
  );
}
