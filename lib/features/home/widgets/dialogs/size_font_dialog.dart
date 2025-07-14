import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../personalization/controllers/fonts_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

OverlayEntry createFontOverlayEntry({
  required BuildContext context,
  required LayerLink layerLink,
  required double selectedOption,
  required Function(double font) onThemeSelected,
  required VoidCallback hideOverlay,
}) {
  final List<double> fontScales = [0.8, 0.9, 1.0, 1.1, 1.25, 1.35, 1.5];
  final FontsController fontsController = Get.find<FontsController>();
  final ScrollController scrollController = ScrollController();

  return OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          GestureDetector(
            onTap: hideOverlay,
            child: Container(color: ChatifyColors.transparent),
          ),
          Positioned(
            width: 200,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, -170),
              child: Material(
                color: ChatifyColors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: fontScales.length,
                      itemBuilder: (context, index) {
                        final scale = fontScales[index];
                        final isSelected = scale == fontsController.selectedFont.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                onThemeSelected(scale);
                                hideOverlay();
                              },
                              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? (context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text("${(scale * 100).toInt()}%", style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                                  ),
                                  if (isSelected)
                                  Positioned(
                                    left: 0,
                                    top: 8,
                                    bottom: 8,
                                    child: Container(
                                      width: 2.5,
                                      decoration: BoxDecoration(
                                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
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
              ),
            ),
          ),
        ],
      );
    },
  );
}
