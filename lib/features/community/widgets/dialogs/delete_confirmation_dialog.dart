import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

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
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
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
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).delete, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ],
      );
    },
  );
}
