import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

void showPhoneNumberDialog(BuildContext context, Offset position) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: Navigator.of(context));
  final Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));

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
                  animationController.dispose();
                });
              },
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: Positioned(
                    left: (MediaQuery.of(context).size.width - 300) / 2,
                    right: (MediaQuery.of(context).size.width - 300) / 2,
                    child: Material(
                      color: ChatifyColors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: 300,
                        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();
}
