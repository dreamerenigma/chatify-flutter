import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class NoSoundDialog {
  void showNoSoundDialog(BuildContext context, int initialDuration, ValueChanged<int> onUpdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedDuration = initialDuration;
        bool isOptionSelected = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              title: Text('Без звука', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
              contentPadding: EdgeInsets.zero,
              actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                    child: Text(
                      'Другие участиники не увидят, что вы отключили звук чата. Если вас упомянут, вы получите уведомление.',
                      style: TextStyle(color: ChatifyColors.darkGrey),
                    ),
                  ),
                  RadioListTile<int>(
                    title: const Text('8 часов'),
                    value: 1,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                        isOptionSelected = true;
                      });
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                  RadioListTile<int>(
                    title: const Text('1 неделя'),
                    value: 5,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                        isOptionSelected = true;
                      });
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                  RadioListTile<int>(
                    title: const Text('Всегда'),
                    value: 60,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                        isOptionSelected = true;
                      });
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                ],
              ),
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
                  onPressed: () {
                    if (isOptionSelected) {
                      onUpdate(selectedDuration);
                    }
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
