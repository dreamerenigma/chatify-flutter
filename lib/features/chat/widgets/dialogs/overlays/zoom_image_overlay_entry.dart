import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

OverlayEntry createZoomImageOverlayEntry({
  required BuildContext context,
  required LayerLink layerLink,
  required String selectedOption,
  required List<String> zoomOptions,
  required Function(String) onZoomImageSelected,
  required VoidCallback hideOverlay,
}) {
  List<String> zoomOptions = ['50%', '75%', '100%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '600%', '800%', '1000%'];

  return OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hideOverlay,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          ),
          Positioned(
            width: 77,
            height: 496,
            child: CompositedTransformFollower(
              link: layerLink,
              offset: const Offset(11, 40),
              showWhenUnlinked: false,
              child: Material(
                color: ChatifyColors.transparent,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white).withAlpha((0.8 * 255).toInt()),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: zoomOptions.map((option) {
                          return _buildOption(
                            context: context,
                            option: option,
                            isSelected: selectedOption == option,
                            onTap: () {
                              onZoomImageSelected(option);
                              hideOverlay();
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
        ],
      );
    },
  );
}

Widget _buildOption({required BuildContext context, required String option, required bool isSelected, required VoidCallback onTap}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          alignment: Alignment.centerLeft,
          child: Text(
            option,
            style: TextStyle(
              color: isSelected ? context.isDarkMode ? ChatifyColors.white : ChatifyColors.black : ChatifyColors.grey,
              fontWeight: FontWeight.w300,
              fontSize: ChatifySizes.fontSizeSm,
              fontFamily: 'Roboto'
            ),
          ),
        ),
      ),
    ),
  );
}
