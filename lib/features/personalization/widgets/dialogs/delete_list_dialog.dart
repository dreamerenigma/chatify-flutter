import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../authentication/screens/login_screen.dart';
import 'light_dialog.dart';

void showDeleteListDialog(BuildContext context, {required String title}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 12),
                child: Text('Удалить список "$title"', softWrap: true, maxLines: null, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 25, color: ChatifyColors.darkGrey),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Text(S.of(context).deleteResetListHidden, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
          TextButton(
            onPressed: () async {
              await APIs.deleteAccount();
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, createPageRoute(const LoginScreen()));
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
