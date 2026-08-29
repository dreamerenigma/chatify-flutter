import 'dart:async';
import 'dart:ui';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../input/search_text_input.dart';

Future<void> showAddFavoriteOverlay(BuildContext context, Offset position, TextEditingController userGroupController) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: Navigator.of(context));
  final Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));

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
                    width: 350,
                    height: 550,
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
                          padding: EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 4),
                          child: Text(S.of(context).addToFavorites, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w600, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                        ),
                        SearchTextInput(
                          hintText: 'Поиск пользователя или группы',
                          controller: userGroupController,
                          padding: EdgeInsets.all(16),
                          showPrefixIcon: false,
                          showSuffixIcon: false,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text(S.of(context).allContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
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
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  return completer.future;
}
