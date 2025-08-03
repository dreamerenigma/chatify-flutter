import 'dart:developer';
import 'dart:ui';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showEditTextDialog(BuildContext context, Offset localPosition, TextEditingController textController) async {
  final overlay = Overlay.of(context);
  OverlayEntry? overlayEntry;
  OverlayState overlayState = overlay;
  RenderBox renderBox = context.findRenderObject() as RenderBox;
  Offset position = renderBox.localToGlobal(localPosition);
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final ValueNotifier<bool> showBottomBarNotifier = ValueNotifier(true);

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
          right: position.dx,
          top: position.dy - 110,
          child: SlideTransition(
            position: slideAnimation,
            child: StatefulBuilder(
              builder: (context, setState) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                        borderRadius: BorderRadius.circular(8),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              key: ValueKey(showBottomBarNotifier.value),
                              width: double.infinity,
                              decoration: BoxDecoration(border: Border(
                                bottom: showBottomBarNotifier.value
                                  ? BorderSide(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, width: 1)
                                  : BorderSide.none,
                              )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 4, top: 4, bottom: 4),
                                    decoration: BoxDecoration(
                                      color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.lightGrey.withAlpha((0.7 * 255).toInt()),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        buildIconButton(
                                          icon: SvgPicture.asset(ChatifyVectors.bold, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                          onTap: () {},
                                          context: context,
                                        ),
                                        buildIconButton(
                                          icon: SvgPicture.asset(ChatifyVectors.italic, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                          onTap: () {},
                                          context: context,
                                        ),
                                        buildIconButton(
                                          icon: SvgPicture.asset(ChatifyVectors.strikethrough, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                          onTap: () {},
                                          context: context,
                                        ),
                                        buildIconButton(
                                          icon: Icon(PhosphorIcons.brackets_curly_light, size: 19, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                          onTap: () {},
                                          context: context,
                                        ),
                                        buildIconButton(
                                          icon: Icon(FluentIcons.more_horizontal_16_regular, size: 19, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                          onTap: () {
                                            showBottomBarNotifier.value = !showBottomBarNotifier.value;
                                          },
                                          context: context,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: showBottomBarNotifier,
                            builder: (context, showBottomBar, _) {
                              return AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: showBottomBar
                                  ? Container(
                                      key: ValueKey('bottomBar'),
                                      width: double.infinity,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        child: Material(
                                          color: ChatifyColors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              final clipboardData = await Clipboard.getData('text/plain');
                                              if (clipboardData?.text?.isNotEmpty == true) {
                                                final currentText = textController.text;
                                                final selection = textController.selection;
                                                final newText = currentText.replaceRange(selection.start, selection.end, clipboardData!.text!);

                                                textController.text = newText;
                                                textController.selection = TextSelection.collapsed(offset: selection.start + clipboardData.text!.length);
                                              }
                                              animationController.reverse().then((_) => overlayEntry?.remove());
                                            },
                                            mouseCursor: SystemMouseCursors.basic,
                                            borderRadius: BorderRadius.circular(6),
                                            splashFactory: NoSplash.splashFactory,
                                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(width: 8),
                                                SvgPicture.asset(ChatifyVectors.clipboard, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                                const SizedBox(width: 10),
                                                Text(S.of(context).insert, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(key: ValueKey('empty')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    overlayState.insert(overlayEntry!);
    animationController.forward().then((_) {
      log('Dialog animation completed');
    });
  });
}

Widget buildIconButton({
  required Widget icon,
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(6),
      splashFactory: NoSplash.splashFactory,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: icon,
      ),
    ),
  );
}
