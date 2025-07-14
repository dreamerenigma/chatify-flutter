import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

class VibrationController extends GetxController {
  var selectedVibrationOption = 2.obs;
}

void showVibrationDialog(BuildContext context, Function(String) onOptionSelected) {
  final vibrationController = Get.put(VibrationController());
  String selectedText = 'По умолчанию';

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Вибрация', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<int>(
                        value: 1,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = 'Выкл.';
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: const Text('Выкл.'),
                      ),
                      RadioListTile<int>(
                        value: 2,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = 'По умолчанию';
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: const Text('По умолчанию'),
                      ),
                      RadioListTile<int>(
                        value: 3,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = 'Короткий';
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: const Text('Короткий'),
                      ),
                      RadioListTile<int>(
                        value: 4,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = 'Длинный';
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: const Text('Длинный'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            switch (vibrationController.selectedVibrationOption.value) {
                              case 1:
                                selectedText = 'Выкл.';
                                break;
                              case 2:
                                selectedText = 'По умолчанию';
                                break;
                              case 3:
                                selectedText = 'Короткий';
                                break;
                              case 4:
                                selectedText = 'Длинный';
                                break;
                            }
                            log('Selected Option: ${vibrationController.selectedVibrationOption.value}');
                            onOptionSelected(selectedText);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text('ОК', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

