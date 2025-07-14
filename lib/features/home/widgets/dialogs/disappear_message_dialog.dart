import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class DisappearMessageDialog {
  static void showDisappearMessagesDialog(BuildContext context, int initialDuration, ValueChanged<int> onUpdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedDuration = initialDuration;

        return AlertDialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text('Исчезающие сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                    child: Text(
                      'Все новые сообщения в этом чате будут исчезать через выбранный промежуток времени.',
                      style: TextStyle(color: ChatifyColors.darkGrey),
                    ),
                  ),
                  RadioListTile<int>(
                    title: const Text('24 часа'),
                    value: 1,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                      });
                      onUpdate(selectedDuration);
                      Navigator.of(context).pop();
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                  RadioListTile<int>(
                    title: const Text('7 дней'),
                    value: 5,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                      });
                      onUpdate(selectedDuration);
                      Navigator.of(context).pop();
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                  RadioListTile<int>(
                    title: const Text('90 дней'),
                    value: 60,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                      });
                      onUpdate(selectedDuration);
                      Navigator.of(context).pop();
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                  RadioListTile<int>(
                    title: const Text('Выкл.'),
                    value: 1440,
                    groupValue: selectedDuration,
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                      });
                      onUpdate(selectedDuration);
                      Navigator.of(context).pop();
                    },
                    contentPadding: const EdgeInsets.only(left: 12),
                  ),
                  const SizedBox(height: 14),
                ],
              );
            },
          ),
          actionsPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
