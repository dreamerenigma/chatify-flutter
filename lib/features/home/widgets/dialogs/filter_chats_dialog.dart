import 'dart:async';
import 'dart:ui';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

Future <void> showFilterChatsDialog(BuildContext context, Offset position) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

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
                  completer.complete();
                  animationController.dispose();
                });
              },
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: SlideTransition(
              position: offsetAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 240,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
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
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Text(S.of(context).chatFilter, style: TextStyle(color: ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            _buildFilterChats(context: context, iconPath: ChatifyVectors.messageNotification, text: S.of(context).unread, iconSize: 18, icon: null),
                            _buildFilterChats(context: context, iconPath: '', text: S.of(context).favorite, iconSize: 20, icon: Icons.favorite_border_rounded),
                            _buildFilterChats(context: context, iconPath: ChatifyVectors.contact, text: S.of(context).contacts, iconSize: 20, icon: null),
                            _buildFilterChats(context: context, iconPath: ChatifyVectors.blockUser, text: S.of(context).areNotContacts, iconSize: 22, icon: null),
                            _buildFilterChats(context: context, iconPath: ChatifyVectors.newGroup, text: '${S.of(context).groups[0].toUpperCase()}${S.of(context).groups.substring(1)}', iconSize: 22, icon: null),
                            _buildFilterChats(context: context, iconPath: '', text: S.of(context).drafts, iconSize: 20, icon: JamIcons.pencil),
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
        ],
      );
    }
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
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: () {},
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
                  placeholderBuilder: (context) => Icon(icon ?? Icons.image_not_supported, size: iconSize, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
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
