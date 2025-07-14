import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../controllers/user_controller.dart';

void showEditPhotoBottomSheet(BuildContext context, Function(String?) onImagePicked, VoidCallback onDeletePressed) {
  final mq = MediaQuery.of(context).size;

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: mq.height * .03, left: mq.height * .03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).profilePhoto,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, onImagePicked, onDeletePressed);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: mq.height * .03),
          Padding(
            padding: EdgeInsets.only(bottom: mq.height * .05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .1, mq.height * .1),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                      onImagePicked(image.path);
                      Navigator.pop(context);
                    }
                  },
                  child: const Image(image: AssetImage(ChatifyImages.gallery)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .1, mq.height * .1),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                      onImagePicked(image.path);
                      Navigator.pop(context);
                    }
                  },
                  child: const Image(image: AssetImage(ChatifyImages.camera)),
                ),
              ],
            ),
          ),
        ],
      );
    },
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
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(color: Colors.blue, fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
          TextButton(
            onPressed: () {
              log('Profile photo deleted');
              onImagePicked(null);
              onDeletePressed();
              Navigator.pop(context);
              Navigator.pop(context);

              Get.find<UserController>().clearUserImage();
            },
            style: TextButton.styleFrom(
              foregroundColor: ChatifyColors.blue,
              backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: ChatifyColors.blue, fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
        ],
      );
    },
  );
}
