import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

class LogoutDialog {
  static Future<void> showLogoutDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    required String logoutTitle,
    required String logoutMessage,
    required String cancelText,
    required String confirmText,
    required ColorScheme colorScheme,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(left: 25, right: 8, top: 6, bottom: 6),
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          actionsPadding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(logoutTitle, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 25),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(logoutMessage, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(cancelText, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
            TextButton(
              onPressed: onConfirm,
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: ChatifyColors.danger,
                backgroundColor: ChatifyColors.danger.withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(confirmText, style: TextStyle(color: ChatifyColors.danger, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
          ],
        );
      },
    );
  }
}
