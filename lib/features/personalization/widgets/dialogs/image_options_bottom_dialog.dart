import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';

void showImageOptionsBottomSheet(BuildContext context, int index, List<AssetEntity> selectedImages, void Function(int) onRemoveImage) {
  if (selectedImages.isNotEmpty) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(thickness: 2, color: ChatifyColors.grey),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onRemoveImage(index);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset(ChatifyImages.appLogoSplash, height: 40, alignment: Alignment.center),
                    ),
                    const SizedBox(height: 5),
                    Text(S.of(context).appName, style: TextStyle(fontSize: ChatifySizes.fontSizeSm), textAlign: TextAlign.center),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(S.of(context).delete, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}