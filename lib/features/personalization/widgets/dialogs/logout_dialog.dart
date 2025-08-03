import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

class LogoutDialog {
  static Future<void> showLogoutDialog(BuildContext context, {
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required String logoutTitle,
    required String logoutMessage,
    required String cancelText,
    required String confirmText,
    required ColorScheme colorScheme,
    bool isDarkMode = false,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(left: 25, right: 8, top: 6, bottom: 6),
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          actionsPadding: EdgeInsets.only(left: 25, right: 25, bottom: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(logoutTitle),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(logoutMessage, style: TextStyle(color: isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(cancelText, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
            ),
            TextButton(
              onPressed: onConfirm,
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(confirmText, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
            ),
          ],
        );
      },
    );
  }
}
