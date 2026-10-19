import 'dart:developer';

import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

void showColorSchemeBottomSheetDialog(
  BuildContext context, {
  required List<String> colorAssets,
  required int selectedColorIndex,
  required ValueChanged<int> onColorSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    showDragHandle: false,
    builder: (sheetContext) {
      int currentSelectedIndex = selectedColorIndex;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: colorAssets.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          final colorAsset = colorAssets[index];
                          final isSelected = currentSelectedIndex == index;

                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                log('Нажат элемент сетки: $index');
                                setSheetState(() {
                                  currentSelectedIndex = index;
                                });

                                onColorSelected(index);
                              },
                              child: Container(
                                width: 68,
                                height: 68,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? (context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black) : ChatifyColors.transparent,
                                    width: isSelected ? 1.5 : 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(colorAsset, fit: BoxFit.cover),
                                      if (isSelected)
                                        Center(
                                          child: Container(
                                            width: 21,
                                            height: 21,
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.grey),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: SvgPicture.asset(ChatifyVectors.check, width: 15, height: 15, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
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
            ),
          );
        },
      );
    },
  );
}
