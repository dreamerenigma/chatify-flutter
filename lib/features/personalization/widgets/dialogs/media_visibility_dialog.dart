import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/tiles/custom_radio_list_tile.dart';
import 'light_dialog.dart';

void showMediaVisibilityDialog(BuildContext context, {required int selectedValue, required ValueChanged<int> onSelected}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 16),
                  child: Text('Показывать скачанные в этом чате медиафайлы в галерее устройства?', textAlign: TextAlign.left, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                ),
                RadioGroup<int>(
                  groupValue: selectedValue,
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedValue = value;
                    });
                  },
                  child: Column(
                    children: [
                      CustomRadioListTile<int>(
                        title: Text('По умолчанию (да)', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        value: 1,
                        radioScale: 1.13,
                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        inactiveIconColor: ChatifyColors.steelGrey,
                        radioPosition: RadioPositionType.left,
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                      ),
                      CustomRadioListTile<int>(
                        title: Text('Да', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        value: 2,
                        radioScale: 1.13,
                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        inactiveIconColor: ChatifyColors.steelGrey,
                        radioPosition: RadioPositionType.left,
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                      ),
                      CustomRadioListTile<int>(
                        title: Text('Нет', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        value: 3,
                        radioScale: 1.13,
                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        inactiveIconColor: ChatifyColors.steelGrey,
                        radioPosition: RadioPositionType.left,
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 20),
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
                        child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          onSelected(selectedValue);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
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
          );
        }
      );
    },
  );
}
