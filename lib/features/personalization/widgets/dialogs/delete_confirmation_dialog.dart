import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../controllers/user_controller.dart';

void showDeleteConfirmationDialog(BuildContext context, Function(String?) onImagePicked, VoidCallback onDeletePressed) {
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
              foregroundColor: ChatifyColors.blue,
              backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).cancel, style: TextStyle(color: ChatifyColors.blue, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
          TextButton(
            onPressed: () {
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
            child: Text(S.of(context).delete, style: TextStyle(color: ChatifyColors.blue, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ],
      );
    },
  );
}
