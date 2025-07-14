import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showDeleteAllIntelligenceDialog(BuildContext context, VoidCallback onDeleteAll) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Вы действительно хотите удалить все Сведения?', style: TextStyle(color: ChatifyColors.darkGrey)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              TextButton(
                onPressed: () {
                  onDeleteAll();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text('Удалить все', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ],
          );
        }
      );
    }
  );
}
