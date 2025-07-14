import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showResetNotificationSettingsDialog(BuildContext context) {
  bool deleteMediaFiles = false;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            elevation: 8.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      deleteMediaFiles = !deleteMediaFiles;
                    });
                  },
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text('Сбросить все настройки уведомлений, включая индивидуальные настройки уведомлений для чатов?', style: TextStyle(color: ChatifyColors.darkGrey)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text('Сброс', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ],
          );
        },
      );
    },
  );
}
