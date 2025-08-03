import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/file_util.dart';

void showEditProfileImageDialog(BuildContext context, TickerProvider vsync, Future<void> Function(File) onImageSelected) {
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
          left: position.dx - 40,
          top: position.dy + 75,
          child: SlideTransition(
            position: slideAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Material(
                          color: ChatifyColors.transparent,
                          child: InkWell(
                            onTap: () {},
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(padding: EdgeInsets.only(left: 12, top: 8, bottom: 8), child: Text(S.of(context).deleteImage)),
                            ),
                          ),
                        ),
                      ),
                      Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Material(
                          color: ChatifyColors.transparent,
                          child: InkWell(
                            onTap: () {},
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8), child: Text(S.of(context).viewImage)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                        child: Material(
                          color: ChatifyColors.transparent,
                          child: InkWell(
                            onTap: () async {
                              await FileUtil.pickFileAndProcess(
                                context: context,
                                onFileSelected: onImageSelected,
                                animationController: animationController,
                                overlayEntry: overlayEntry,
                              );
                            },
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                child: Text(S.of(context).changeImage),
                              ),
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
        ),
      ],
    ),
  );

  overlayState.insert(overlayEntry);
  animationController.forward();
}
