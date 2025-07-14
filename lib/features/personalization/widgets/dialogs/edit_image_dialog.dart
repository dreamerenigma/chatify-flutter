import 'dart:io';
import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconoir_icons/iconoir_icons.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../home/widgets/dialogs/confirmation_dialog.dart';
import '../panels/media_content_bottom_panel.dart';
import 'light_dialog.dart';

Future<void> showEditImageDialog(
  BuildContext context,
  Offset position,
  File selectedFile,
  Function(File) onImageConfirmed,
) async {
  final FocusNode captionFocusNode = FocusNode();
  final ValueNotifier<bool> isFocused = ValueNotifier(false);
  final hoveredIcon = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectedIcon = ValueNotifier<String?>(ChatifyVectors.pen);
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final animationController = AnimationController(vsync: Navigator.of(context), duration: const Duration(milliseconds: 300));
  final slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: const Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  captionFocusNode.addListener(() {
    isFocused.value = captionFocusNode.hasFocus;
  });

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showConfirmationDialog(
                  context: context,
                  width: 550,
                  title: 'Сбросить неотправленное сообщение',
                  description: 'Ваше сообщение и прикреплённые медиафайлы не будут отправлены, если вы закроете этот экран.',
                  confirmText: 'Сбросить',
                  cancelText: 'Назад',
                  onConfirm: () {
                    overlayEntry.remove();
                    captionFocusNode.dispose();
                    isFocused.dispose();
                    hoveredIcon.dispose();
                    selectedIcon.dispose();
                    animationController.dispose();
                  },
                );
              },
            ),
          ),
          Positioned(
            left: position.dx + 2,
            bottom: position.dy - 35,
            child: SlideTransition(
              position: slideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 550,
                    decoration: BoxDecoration(
                      color: (context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white).withAlpha((0.6 * 255).toInt()),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softNight,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                ),
                                child: ValueListenableBuilder<String?>(
                                  valueListenable: selectedIcon,
                                  builder: (context, selected, _) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...[
                                          ChatifyVectors.pen,
                                          ChatifyVectors.pencil,
                                          ChatifyVectors.highlighter,
                                          ChatifyVectors.eraser,
                                          ChatifyVectors.arrowCancel,
                                        ].map((iconPath) {
                                          return ValueListenableBuilder<String?>(
                                            valueListenable: hoveredIcon,
                                            builder: (context, hovered, _) {
                                              final isHovered = hovered == iconPath;
                                              final isSelected = selected == iconPath;
                                              final backgroundColor = isHovered || isSelected
                                                ? (context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.3 * 255).toInt()))
                                                : ChatifyColors.transparent;

                                              return MouseRegion(
                                                onEnter: (_) => hoveredIcon.value = iconPath,
                                                onExit: (_) => hoveredIcon.value = null,
                                                child: GestureDetector(
                                                  onTap: () => selectedIcon.value = iconPath == selected ? null : iconPath,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(right: 4),
                                                    padding: const EdgeInsets.all(9),
                                                    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(6)),
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          iconPath,
                                                          color: iconPath == ChatifyVectors.highlighter
                                                            ? null
                                                            : (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                        if (isSelected)
                                                        Positioned(
                                                          bottom: -12,
                                                          child: Icon(
                                                            Icons.keyboard_arrow_down_rounded,
                                                            size: 16,
                                                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                        Container(width: 1, height: 18, margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                                        ...['rotation', 'crop', 'delete'].map((iconId) {
                                          return ValueListenableBuilder<String?>(
                                            valueListenable: hoveredIcon,
                                            builder: (context, hovered, _) {
                                              final isHovered = hovered == iconId;
                                              final backgroundColor = isHovered
                                                ? (context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.3 * 255).toInt()))
                                                : ChatifyColors.transparent;

                                              String tooltipMessage = '';
                                              switch (iconId) {
                                                case 'rotation':
                                                  tooltipMessage = 'Повернуть';
                                                  break;
                                                case 'crop':
                                                  tooltipMessage = 'Обрезать';
                                                  break;
                                                case 'delete':
                                                  tooltipMessage = 'Удалить';
                                                  break;
                                                default:
                                                  tooltipMessage = '';
                                              }

                                              return MouseRegion(
                                                onEnter: (_) => hoveredIcon.value = iconId,
                                                onExit: (_) => hoveredIcon.value = null,
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Tooltip(
                                                    message: tooltipMessage,
                                                    verticalOffset: -50,
                                                    waitDuration: Duration(milliseconds: 800),
                                                    exitDuration: Duration(milliseconds: 200),
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                    textStyle: TextStyle(
                                                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                                      fontSize: ChatifySizes.fontSizeLm,
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                        color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey,
                                                        width: 1,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: Offset(0, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 8),
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: backgroundColor),
                                                      child: iconId == 'rotation'
                                                        ? SvgPicture.asset(ChatifyVectors.rotation, width: 23, height: 23, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)
                                                        : Icon(iconId == 'crop' ? Ionicons.crop_outline : FluentIcons.delete_20_regular, size: 24),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                        const Spacer(),
                                        Material(
                                          color: ChatifyColors.transparent,
                                          child: InkWell(
                                            mouseCursor: SystemMouseCursors.basic,
                                            borderRadius: BorderRadius.circular(8),
                                            splashColor: ChatifyColors.transparent,
                                            highlightColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.3 * 255).toInt()),
                                            hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.3 * 255).toInt()),
                                            onTapDown: (details) {
                                              final globalOffset = details.globalPosition;
                                              late OverlayEntry overlayMenu;
                                              final overlayState = Overlay.of(context);
                                              final animationController = AnimationController(vsync: Navigator.of(context), duration: const Duration(milliseconds: 200));
                                              final animation = Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));

                                              overlayMenu = OverlayEntry(
                                                builder: (context) {
                                                  return Stack(
                                                    children: [
                                                      Positioned.fill(
                                                        child: GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            animationController.reverse().then((_) => overlayMenu.remove());
                                                          },
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: globalOffset.dx - 45,
                                                        top: globalOffset.dy - 25,
                                                        child: Material(
                                                          color: ChatifyColors.transparent,
                                                          child: SlideTransition(
                                                            position: animation,
                                                            child: Container(
                                                              width: 160,
                                                              decoration: BoxDecoration(
                                                                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                                                                borderRadius: BorderRadius.circular(8),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.black26,
                                                                    blurRadius: 6,
                                                                    offset: Offset(0, 4),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      animationController.reverse().then((_) => overlayMenu.remove());
                                                                    },
                                                                    mouseCursor: SystemMouseCursors.basic,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                                      child: Center(
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Text('Отправить как файл', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              overlayState.insert(overlayMenu);
                                              animationController.forward();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Iconoir(IconoirIcons.moreHoriz, size: 24),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Image.file(selectedFile, fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.58),
                              MediaContentBottomPanel(
                                isFocused: isFocused,
                                captionFocusNode: captionFocusNode,
                                animationController: animationController,
                                overlayEntry: overlayEntry,
                                onEmojiSelected: (String ) {},
                                onGifSelected: (String ) {},
                                user: APIs.me,
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
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();
}
