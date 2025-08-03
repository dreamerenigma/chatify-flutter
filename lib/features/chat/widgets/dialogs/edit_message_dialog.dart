import 'dart:developer';
import 'dart:ui';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../common/widgets/panels/emoji_panel.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import 'delete_message_dialog.dart';

OverlayEntry? currentOverlayEntry;

Future<void> showEditMessageDialog(
  BuildContext context,
  Offset position,
  GlobalKey containerKey,
  {bool openAbove = false,
  VoidCallback? onDialogClosed}
) async {
  final RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
  final containerOffset = renderBox.localToGlobal(Offset.zero);
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final overlayHeight = 250.0;
  final windowWidth = 240.0;

  double offsetX = containerOffset.dx;
  double offsetY = containerOffset.dy - overlayHeight - 190;

  if (offsetX + windowWidth > screenWidth) {
    offsetX = screenWidth - windowWidth;
  }

  if (offsetY + overlayHeight > screenHeight) {
    offsetY = screenHeight - overlayHeight - 10;
  }

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));

  final Animation<Offset> slideAnimation = Tween<Offset>(
    begin: Offset(0, 0.1),
    end: Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.easeOutCubic,
  ));

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) {
                  overlayEntry.remove();
                  onDialogClosed?.call();
                  currentOverlayEntry = null;
                });
              },
            ),
          ),
          Positioned(
            left: offsetX,
            top: offsetY,
            child: SlideTransition(
              position: slideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 270,
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey.withAlpha((0.6 * 255).toInt()),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              EmojiPanel(
                                onEmojiTap: (emoji) {
                                  log('Выбран эмодзи: $emoji');
                                },
                                onAddTap: () {
                                  log('Нажата кнопка добавления');
                                },
                              ),
                              Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                              _buildEditMessage(context: context, iconPath: ChatifyVectors.arrowLeft, text: S.of(context).answer, iconSize: 18, icon: null, onTap: () {}),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).copy, iconSize: 20, icon: FluentIcons.copy_24_regular, onTap: () {}),
                              Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                              _buildEditMessage(context: context, iconPath: ChatifyVectors.arrowRight, text: S.of(context).forward.replaceAll('...', ''), iconSize: 20, icon: null, onTap: () {}),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).addToFavoritesDialog, iconSize: 22, icon: BootstrapIcons.star, onTap: () {}),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).pinIt, iconSize: 22, icon: BootstrapIcons.pin_angle, onTap: () {}),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).delete, iconSize: 20, icon: FluentIcons.delete_24_regular, onTap: () {
                                overlayEntry.remove();
                                showDeleteMessageDialog(context, title: '${S.of(context).deleteMessage}?', description: S.of(context).youCanDeleteMessageYourself);
                              }),
                              Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).choose, iconSize: 20, icon: Ionicons.checkbox_outline, onTap: () {}),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).share, iconSize: 20, icon: FluentIcons.share_24_regular, onTap: () {}),
                              Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                              _buildEditMessage(context: context, iconPath: '', text: S.of(context).data, iconSize: 20, icon: Icons.info_outline_rounded, onTap: () {}),
                              SizedBox(height: 8),
                            ],
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
}

Widget _buildEditMessage({
  required BuildContext context,
  required String iconPath,
  required IconData? icon,
  required String text,
  required double iconSize,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
        highlightColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              if (iconPath.isNotEmpty)
                SvgPicture.asset(
                  iconPath,
                  width: iconSize,
                  height: iconSize,
                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  placeholderBuilder: (context) => Icon(
                    icon ?? Icons.image_not_supported,
                    size: iconSize,
                    color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  ),
                )
              else
                Icon(
                  icon ?? Icons.image_not_supported,
                  size: iconSize,
                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                ),
              SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      ),
    ),
  );
}
