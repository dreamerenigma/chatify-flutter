import 'dart:developer';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../community/screens/emoji_sticker_screen.dart';
import 'light_dialog.dart';

void showEditImageGroupBottomDialog(
    BuildContext context,
    Function(String?) onImagePicked,
    VoidCallback onDeletePressed,
    String communityId,
    String imageUrl,
    bool showDeleteIcon,
    ) {
  final mq = MediaQuery.of(context).size;

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: mq.height * .05, left: mq.height * .03, right: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Картинка группы', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  showDeleteIcon
                      ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, onImagePicked, onDeletePressed);
                    },
                  )
                      : Container(),
                ],
              ),
              SizedBox(height: mq.height * .03),
              _buildImageGroup(context, onImagePicked),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildImageGroup(BuildContext context, Function(String?) onImagePicked) {
  return GridView.count(
    crossAxisCount: 3,
    crossAxisSpacing: 40,
    mainAxisSpacing: 18,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    children: [
      _buildImageButton(
        context: context,
        icon: Icons.camera_alt_outlined,
        backgroundColor: ChatifyColors.transparent,
        borderColor: ChatifyColors.popupColor,
        label: 'Камера',
        onTap: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 80,
          );
          if (image != null) {
            log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
            onImagePicked(image.path);
            Navigator.pop(context);
          }
        },
      ),
      _buildImageButton(
        context: context,
        icon: Icons.image_sharp,
        backgroundColor: ChatifyColors.transparent,
        borderColor: ChatifyColors.popupColor,
        label: 'Галерея',
        onTap: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
          );
          if (image != null) {
            log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
            onImagePicked(image.path);
            Navigator.pop(context);
          }
        },
      ),
      _buildImageButton(
        context: context,
        icon: Icons.emoji_emotions_outlined,
        backgroundColor: ChatifyColors.transparent,
        borderColor: ChatifyColors.popupColor,
        label: 'Смайлики и стикеры',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            createPageRoute(EmojiStickerScreen(initialColor: Colors.red[200]!, initialEmoji: '')),
          );
        },
      ),
    ],
  );
}

Widget _buildImageButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color borderColor,
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

void _showDeleteConfirmationDialog(BuildContext context, Function(String?) onImagePicked, VoidCallback onDeletePressed) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).deleteProfilePhoto),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
          TextButton(
            onPressed: () {
              onImagePicked(null);
              onDeletePressed();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
        ],
      );
    },
  );
}
