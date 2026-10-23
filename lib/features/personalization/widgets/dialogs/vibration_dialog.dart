import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/tiles/custom_radio_list_tile.dart';
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
                    child: Align(alignment: Alignment.centerLeft, child: Text(S.of(context).vibration, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))),
                  ),
                  const SizedBox(height: 12),
                  RadioGroup<int>(
                    groupValue: vibrationController.selectedVibrationOption.value,
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        vibrationController.selectedVibrationOption.value = value;
                        switch (value) {
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
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomRadioListTile<int>(
                          title: Text(S.of(context).off, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          value: 0,
                          radioScale: 1.13,
                          inactiveIconColor: ChatifyColors.steelGrey,
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 16, right: 12, top: 3, bottom: 3),
                        ),
                        CustomRadioListTile<int>(
                          title: Text(S.of(context).byDefault, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          value: 1,
                          radioScale: 1.13,
                          inactiveIconColor: ChatifyColors.steelGrey,
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 16, right: 12, top: 3, bottom: 3),
                        ),
                        CustomRadioListTile<int>(
                          title: Text(S.of(context).short, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          value: 2,
                          radioScale: 1.13,
                          inactiveIconColor: ChatifyColors.steelGrey,
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 16, right: 12, top: 3, bottom: 3),
                        ),
                        CustomRadioListTile<int>(
                          title: Text(S.of(context).long, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          value: 3,
                          radioScale: 1.13,
                          inactiveIconColor: ChatifyColors.steelGrey,
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 16, right: 12, top: 3, bottom: 3),
                        ),
                      ],
                    ),
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
                            splashFactory: NoSplash.splashFactory,
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
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
                            splashFactory: NoSplash.splashFactory,
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).ok, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
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
