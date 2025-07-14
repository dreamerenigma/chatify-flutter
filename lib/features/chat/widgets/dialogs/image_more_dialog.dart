import 'dart:ui';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showImageMoreDialog(BuildContext context, Offset position) {
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
          right: position.dx + 50,
          top: position.dy - 37,
          child: SlideTransition(
            position: slideAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 265,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildMenuItem(
                          context: context,
                          onTap: () {},
                          icon: SvgPicture.asset(ChatifyVectors.save,width: 15, height: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          text: 'Сохранить как...',
                          padding: const EdgeInsets.only(left: 13, right: 12, top: 6, bottom: 6),
                        ),
                        buildMenuItem(
                          context: context,
                          onTap: () {},
                          icon: const Icon(FluentIcons.open_48_regular, size: 20),
                          text: "Открыть в другом приложении",
                          padding: const EdgeInsets.only(left: 10, right: 12, top: 6, bottom: 6),
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

Widget buildMenuItem({required BuildContext context, required VoidCallback onTap, required Widget icon, required String text, required EdgeInsetsGeometry padding}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                icon,
                const SizedBox(width: 14),
                Expanded(child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
