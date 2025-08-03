import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import 'light_dialog.dart';

void showProfileBottomSheet(BuildContext context, void Function(String?) onImagePicked) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              const Spacer(),
              Text(S.of(context).profilePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
              const Spacer(flex: 2),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
            itemCount: 3,
            itemBuilder: (context, index) {
              Widget iconWidget;
              if (index == 0) {
                iconWidget = Icon(Icons.camera_alt_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 24);
              } else if (index == 1) {
                iconWidget = Icon(Icons.photo_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 24);
              } else {
                iconWidget = SvgPicture.asset(
                  ChatifyVectors.avatar,
                  width: 24,
                  height: 24,
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                );
              }

              return _buildRoundedIconContainer(
                icon: iconWidget,
                backgroundColor: ChatifyColors.transparent,
                borderColor: ChatifyColors.popupColor,
                label: index == 0 ? S.of(context).camera : index == 1 ? S.of(context).gallery : S.of(context).avatar,
                onTap: () => handleContainerTap(context, index, onImagePicked),
                context: context,
              );
            }
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget _buildRoundedIconContainer({
  required BuildContext context,
  required Widget icon,
  required Color backgroundColor,
  required Color borderColor,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle, border: Border.all(color: borderColor, width: 2)),
          child: Center(child: icon),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
      ],
    ),
  );
}


void handleContainerTap(BuildContext context, int index, void Function(String?) onImagePicked) async {
  switch (index) {
    case 0:
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (image != null) {
        onImagePicked(image.path);
        Navigator.pop(context);
      }
      break;
    case 1:
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        onImagePicked(image.path);
        Navigator.pop(context);
      }
      break;
    case 2:
      break;
    default:
      Navigator.pop(context);
      break;
  }
}

