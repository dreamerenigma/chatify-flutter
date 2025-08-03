import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../screens/emoji_sticker_screen.dart';

void showEditImageCommunityBottomDialog(
  BuildContext context,
  Function(String?) onImagePicked,
  VoidCallback onDeletePressed,
  String communityId,
  String imageUrl,
  Function(String?) updateImagePath,
) {
  final mq = MediaQuery.of(context).size;

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: mq.height * .05, left: mq.height * .03, right: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).communityPicture, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, onImagePicked, onDeletePressed);
                  },
                ),
              ],
            ),
            SizedBox(height: mq.height * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: const BorderSide(color: ChatifyColors.darkerGrey, width: 2),
                          fixedSize: Size(mq.width * .1, mq.height * .1),
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            onImagePicked(image.path);
                            updateImagePath(image.path);
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(Icons.camera_alt_outlined, color: ChatifyColors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(S.of(context).camera, style: TextStyle(color: ChatifyColors.blue)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: const BorderSide(color: ChatifyColors.darkerGrey, width: 2),
                          fixedSize: Size(mq.width * .1, mq.height * .1),
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            onImagePicked(image.path);
                            updateImagePath(image.path);
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(Icons.image_sharp, color: ChatifyColors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(S.of(context).gallery, style: TextStyle(color: ChatifyColors.blue)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: const BorderSide(color: ChatifyColors.darkerGrey, width: 2),
                          fixedSize: Size(mq.width * .1, mq.height * .1),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, createPageRoute(EmojiStickerScreen(initialColor: Colors.red[200]!, initialEmoji: '')));
                        },
                        child: const Icon(Icons.emoji_emotions_outlined, color: ChatifyColors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(S.of(context).emoji, style: TextStyle(color: ChatifyColors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


void _showDeleteConfirmationDialog(
  BuildContext context,
  Function(String?) onImagePicked,
  VoidCallback onDeletePressed,
  ) {
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
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).cancel, style: TextStyle(color: ChatifyColors.blue, fontSize: ChatifySizes.fontSizeMd)),
          ),
          TextButton(
            onPressed: () {
              onImagePicked(null);
              onDeletePressed();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: ChatifyColors.blue,
              backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).delete, style: TextStyle(color: ChatifyColors.blue, fontSize: ChatifySizes.fontSizeMd)),
          ),
        ],
      );
    },
  );
}
