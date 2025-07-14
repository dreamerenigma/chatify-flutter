import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showDeleteAllChatsDialog(BuildContext context) {
  bool deleteMediaFiles = false;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Удалить все чаты?', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Checkbox(
                          value: deleteMediaFiles,
                          onChanged: (bool? value) {
                            setState(() {
                              deleteMediaFiles = value ?? false;
                            });
                          },
                          activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        const Expanded(
                          child: Text('Также удалить медиафайлы, полученные в чатах, из галереи устройства', style: TextStyle(color: ChatifyColors.darkGrey)),
                        ),
                      ],
                    ),
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
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text('Удалить чаты', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ],
          );
        },
      );
    },
  );
}
