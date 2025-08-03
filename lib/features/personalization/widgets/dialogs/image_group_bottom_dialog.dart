import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../status/widgets/images/camera_screen.dart';
import 'light_dialog.dart';

void showImageGroupBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(S.of(context).groupPicture, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 40,
              mainAxisSpacing: 18,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildRoundedIconContainer(
                icon: index == 0
                  ? Icons.camera_alt_outlined
                  : index == 1
                  ? Icons.photo_outlined
                  : index == 2
                  ? Icons.emoji_emotions_outlined
                  : Icons.search,
                backgroundColor: ChatifyColors.transparent,
                borderColor: ChatifyColors.popupColor,
                label: index == 0
                  ? S.of(context).camera
                  : index == 1
                  ? S.of(context).gallery
                  : index == 2
                  ? S.of(context).emoticonsStickers
                  : S.of(context).searchInternet,
                onTap: () => handleContainerTap(context, index),
                context: context,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget _buildRoundedIconContainer({
  required BuildContext context,
  required IconData icon,
  required Color backgroundColor,
  required Color borderColor,
  required String label,
  required VoidCallback onTap,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 24),
        ),
      ),
      const SizedBox(height: 8),
      Flexible(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    ],
  );
}

void handleContainerTap(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.push(context, createPageRoute(const CameraScreen()));
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    default:
      break;
  }
}
