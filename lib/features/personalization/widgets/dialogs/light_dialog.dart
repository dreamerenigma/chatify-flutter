import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/tiles/custom_radio_list_tile.dart';
import '../../controllers/colors_controller.dart';

final colorsController = Get.find<ColorsController>();

void showLightDialog(BuildContext context, Function(int, String) onColorSelected) {
  final storage = GetStorage();
  int selectedValue = storage.read<int>('notificationLightValue') ?? 2;

  final radioOptions = [
    {'value': 1, 'title': S.of(context).none},
    {'value': 2, 'title': S.of(context).white},
    {'value': 3, 'title': S.of(context).red},
    {'value': 4, 'title': S.of(context).yellow},
    {'value': 5, 'title': S.of(context).green},
    {'value': 6, 'title': S.of(context).lightBlue},
    {'value': 7, 'title': S.of(context).blue},
    {'value': 8, 'title': S.of(context).purple},
  ];

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, setDialogState) {
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
                      child: Text(S.of(context).lightNotify, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RadioGroup<int>(
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedValue = value;
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: radioOptions.map((option) {
                        final value = option['value'] as int;
                        final title = option['title'] as String;

                        return CustomRadioListTile<int>(
                          value: value,
                          title: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          radioScale: 1.14,
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          inactiveIconColor: ChatifyColors.steelGrey,
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                        );
                      }).toList(),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                          ),
                          child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            final title = getLightName(context, selectedValue);

                            storage.write('notificationLightValue', selectedValue);
                            onColorSelected(selectedValue, title);

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

String getLightName(BuildContext context, int value) {
  switch (value) {
    case 1:
      return S.of(context).notAvailable;
    case 2:
      return S.of(context).white;
    case 3:
      return S.of(context).red;
    case 4:
      return S.of(context).yellow;
    case 5:
      return S.of(context).green;
    case 6:
      return S.of(context).lightBlue;
    case 7:
      return S.of(context).blue;
    case 8:
      return S.of(context).purple;
    default:
      return S.of(context).white;
  }
}
