import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showArchiveChatsDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Вы действительно хотите архивировать ВСЕ чаты?',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey),
            ),
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(left: 25, right: 25, top: 20),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('ОК'),
              ),
            ],
          );
        },
      );
    },
  );
}
