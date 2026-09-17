import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import 'light_dialog.dart';

void showProfileBottomSheet(BuildContext context, void Function(String?) onImagePicked) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 14),
        Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(child: Center(child: Text(S.of(context).profilePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)))),
                SizedBox(
                  width: 48,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            _buildIconContainer(
              icon: Icon(
                Icons.camera_alt_outlined,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                size: 24,
              ),
              label: S.of(context).camera,
              onTap: () => handleContainerTap(context, 0),
              context: context,
            ),
            _buildIconContainer(
              icon: Icon(
                Icons.photo_outlined,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                size: 24,
              ),
              label: S.of(context).gallery,
              onTap: () => handleContainerTap(context, 1),
              context: context,
            ),
            _buildIconContainer(
              icon: SvgPicture.asset(
                ChatifyVectors.avatar,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
              ),
              label: S.of(context).avatar,
              onTap: () => handleContainerTap(context, 2),
              context: context,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildIconContainer({required BuildContext context, required Widget icon, required String label, required VoidCallback onTap}) {
  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            SizedBox(width: 32, child: Center(child: icon)),
            const SizedBox(width: 18),
            Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    ),
  );
}

Future<void> handleContainerTap(BuildContext context, int index,) async {
  switch (index) {
    case 0:
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (image != null) {
        await APIs.updateProfilePicture(File(image.path));

        if (context.mounted) {
          Navigator.pop(context);
        }
      }
      break;
    case 1:
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (image != null) {
        await APIs.updateProfilePicture(File(image.path));

        if (context.mounted) {
          Navigator.pop(context);
        }
      }
      break;
    case 2:
      break;
    default:
      Navigator.pop(context);
      break;
  }
}
