import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';

void showSortBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: double.infinity,
              child: Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2)))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 8),
              child: Row(
                children: [
                  Text(
                    'Сортировка',
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    icon: const Icon(Icons.close_rounded, size: 25),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: SizedBox(width: double.infinity, child: Text('Новые', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                ),
              ),
            ),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: SizedBox(width: double.infinity, child: Text('Старые', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                ),
              ),
            ),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: SizedBox(width: double.infinity, child: Text('Большие', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}
