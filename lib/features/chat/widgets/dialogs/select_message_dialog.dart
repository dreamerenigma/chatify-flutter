import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'dart:ui';

import 'items/menu_item.dart';

OverlayEntry? _currentOverlayEntry;
AnimationController? _currentAnimationController;
bool _isDialogClosing = false;

void showSelectMessageDialog({required BuildContext context, required Offset position, required List<MenuItem> items, double width = 230}) async {
  if (_currentOverlayEntry != null && !_isDialogClosing) {
    await closeCurrentDialog();
  }

  await openDialog(context: context, position: position, items: items, width: width);
}

Future<void> closeCurrentDialog() async {
  if (_currentOverlayEntry == null) return;

  _isDialogClosing = true;

  try {
    await _currentAnimationController?.reverse();
  } catch (_) {}

  _currentOverlayEntry?.remove();
  _currentAnimationController?.dispose();

  _currentOverlayEntry = null;
  _currentAnimationController = null;
  _isDialogClosing = false;
}

Future<void> openDialog({required BuildContext context, required Offset position, required List<MenuItem> items, required double width}) async {
  final overlay = Overlay.of(context);
  final tickerProvider = Navigator.of(context);
  final animationController = AnimationController(vsync: tickerProvider, duration: const Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  late OverlayEntry overlayEntry;

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
                  if (_currentOverlayEntry == overlayEntry) {
                    _currentOverlayEntry = null;
                    _currentAnimationController = null;
                  }
                });
              },
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: SlideTransition(
              position: slideAnimation,
              child: Material(
                color: ChatifyColors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.lightGrey.withAlpha((0.7 * 255).toInt()),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: items.map((item) {
                            return _buildIconTextRow(
                              context: context,
                              icon: item.icon,
                              iconSize: item.iconSize ?? 18,
                              text: item.text,
                              onTap: () {
                                item.onTap();
                                animationController.reverse().then((_) {
                                  overlayEntry.remove();
                                  animationController.dispose();
                                  if (_currentOverlayEntry == overlayEntry) {
                                    _currentOverlayEntry = null;
                                    _currentAnimationController = null;
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
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

  _currentOverlayEntry = overlayEntry;
  _currentAnimationController = animationController;

  overlay.insert(overlayEntry);
  animationController.forward();
}

Widget _buildIconTextRow({
  required BuildContext context,
  IconData? icon,
  String? svgAsset,
  double iconSize = 18,
  required String text,
  String? trailingText,
  VoidCallback? onTap,
}) {
  final isDark = context.isDarkMode;

  Widget leadingIcon;
  if (svgAsset != null) {
    leadingIcon = SvgPicture.asset(svgAsset, width: iconSize, height: iconSize, color: isDark ? ChatifyColors.white : ChatifyColors.black);
  } else if (icon != null) {
    leadingIcon = Icon(icon, size: iconSize, color: isDark ? ChatifyColors.white : ChatifyColors.black);
  } else {
    leadingIcon = const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashColor: ChatifyColors.transparent,
        highlightColor: isDark ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: isDark ? ChatifyColors.softNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Row(
            children: [
              leadingIcon,
              const SizedBox(width: 10),
              Expanded(
                child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: isDark ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300)),
              ),
              if (trailingText != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(trailingText, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: isDark ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
