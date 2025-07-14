import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

Future<Set<String>?> showAutoLoadedMediaDialog(BuildContext context, Set<String> selectedAutoLoadedMedia) {

  String getMediaTypeFromKey(String key) {
    switch (key) {
      case 'photo':
        return 'Фото';
      case 'audio':
        return 'Аудио';
      case 'video':
        return 'Видео';
      case 'document':
        return 'Документы';
      default:
        return '';
    }
  }

  void toggleCheckbox(String key, StateSetter setState) {
    setState(() {
      String mediaType = getMediaTypeFromKey(key);
      if (selectedAutoLoadedMedia.contains(mediaType)) {
        selectedAutoLoadedMedia.remove(mediaType);
      } else {
        selectedAutoLoadedMedia.add(mediaType);
      }
    });
  }

  Widget buildCheckboxItem(BuildContext context, StateSetter setState, String key, String title) {
    return InkWell(
      onTap: () {
        toggleCheckbox(key, setState);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Checkbox(
              value: selectedAutoLoadedMedia.contains(getMediaTypeFromKey(key)),
              onChanged: (bool? value) {
                toggleCheckbox(key, setState);
              },
              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  return showDialog<Set<String>?>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Мобильная сеть', style: TextStyle(fontSize: ChatifySizes.fontSizeMg)),
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            actionsPadding: const EdgeInsets.all(16),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildCheckboxItem(context, setState, 'photo', 'Фото'),
                buildCheckboxItem(context, setState, 'audio', 'Аудио'),
                buildCheckboxItem(context, setState, 'video', 'Видео'),
                buildCheckboxItem(context, setState, 'document', 'Документы'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cancel
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
                  Navigator.of(context).pop(selectedAutoLoadedMedia);
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

