import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:chatify/features/personalization/widgets/dialogs/take_photo_dialog.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/file_util.dart';

Future<void> showAttachFileDialog(BuildContext context, Offset position, Future<void> Function(File) onImageSelected) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final animationController = AnimationController(vsync: Navigator.of(context), duration: const Duration(milliseconds: 300));
  final slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: const Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  void closeOverlay() {
    animationController.reverse().then((_) {
      overlayEntry.remove();
      completer.complete();
    });
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: closeOverlay)),
          Positioned(
            left: position.dx + 2,
            bottom: position.dy + 9,
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
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 154,
                    decoration: BoxDecoration(
                      color: (context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white).withAlpha((0.6 * 255).toInt()),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Column(
                            children: [
                              _buildFilterChats(context: context, iconPath: '', text: 'Фото и видео', iconSize: 18, icon: Ionicons.image_outline, onTap: () async {
                                await FileUtil.pickFileAndProcess(
                                  context: context,
                                  onFileSelected: onImageSelected,
                                  animationController: animationController,
                                  overlayEntry: overlayEntry,
                                );
                                closeOverlay();
                              }),
                              _buildFilterChats(context: context, iconPath: '', text: S.of(context).camera, iconSize: 20, icon: Icons.camera_alt_outlined, onTap: () async {
                                overlayEntry.remove();
                                showTakePhotoDialog(context);
                                closeOverlay();
                              }),
                              _buildFilterChats(context: context, iconPath: '', text: S.of(context).documents, iconSize: 20, icon: FluentIcons.document_16_regular, onTap: () {
                                overlayEntry.remove();
                              }),
                              _buildFilterChats(context: context, iconPath: ChatifyVectors.contact, text: S.of(context).contact, iconSize: 22, icon: null, onTap: () {
                                overlayEntry.remove();
                                closeOverlay();
                              }),
                              _buildFilterChats(context: context, iconPath: ChatifyVectors.survey, text: S.of(context).survey, iconSize: 22, icon: null, onTap: () {
                                overlayEntry.remove();
                                closeOverlay();
                              }),
                              _buildFilterChats(context: context, iconPath: '', text: S.of(context).event, iconSize: 20, icon: FluentIcons.calendar_16_regular, onTap: () {
                                overlayEntry.remove();
                                closeOverlay();
                              }),
                              _buildFilterChats(context: context, iconPath: ChatifyVectors.feather, text: S.of(context).drawing, iconSize: 20, icon: null, onTap: () {
                                overlayEntry.remove();
                                closeOverlay();
                              }),
                              const SizedBox(height: 6),
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

  return completer.future;
}

Widget _buildFilterChats({
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
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.softGrey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.softGrey,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                Icon(icon ?? Icons.image_not_supported, size: iconSize, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      ),
    ),
  );
}
