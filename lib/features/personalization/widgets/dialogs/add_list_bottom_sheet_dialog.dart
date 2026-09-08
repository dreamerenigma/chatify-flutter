import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:chatify/features/personalization/widgets/dialogs/new_list_bottom_dialog.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';

void showAddListBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(2)),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text('Выберите список', textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400)),
        const SizedBox(height: 10),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
            hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
            onTap: () {
              Navigator.pop(context);
              showNewListBottomSheetDialog(context);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.add_rounded, size: 26, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                  const SizedBox(width: 16),
                  Expanded(child: Text('Новый список', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 17, fontWeight: FontWeight.w400))),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
            hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.favorite_border, size: 26, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.softGrey),
                  const SizedBox(width: 16),
                  const Expanded(child: Text('Избранное', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))),
                  Icon(Icons.check_circle_rounded, size: 26, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                side: BorderSide.none,
              ),
              child: Text('Готово', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
          ),
        ),
      ],
    ),
  );
}
