import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

class VibrationController extends GetxController {
  var selectedVibrationOption = 2.obs;
}

void showVibrationDialog(BuildContext context, Function(String) onOptionSelected) {
  final vibrationController = Get.put(VibrationController());
  String selectedText = S.of(context).system;

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
                      child: Text(S.of(context).vibration, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
                            selectedText = S.of(context).off;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: Text(S.of(context).off),
                      ),
                      RadioListTile<int>(
                        value: 2,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = S.of(context).byDefault;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: Text(S.of(context).byDefault),
                      ),
                      RadioListTile<int>(
                        value: 3,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = S.of(context).short;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: Text(S.of(context).short),
                      ),
                      RadioListTile<int>(
                        value: 4,
                        groupValue: vibrationController.selectedVibrationOption.value,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            vibrationController.selectedVibrationOption.value = value!;
                            selectedText = S.of(context).long;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: Text(S.of(context).long),
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
                          child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            switch (vibrationController.selectedVibrationOption.value) {
                              case 1:
                                selectedText = S.of(context).off;
                                break;
                              case 2:
                                selectedText = S.of(context).byDefault;
                                break;
                              case 3:
                                selectedText = S.of(context).short;
                                break;
                              case 4:
                                selectedText = S.of(context).long;
                                break;
                            }
                            onOptionSelected(selectedText);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).ok, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
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

