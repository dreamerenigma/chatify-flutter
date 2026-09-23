import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/custom_radio_list_tile.dart';
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
          title: Text(S.of(context).disappearingMessages, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return RadioGroup<int>(
                groupValue: selectedDuration,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedDuration = value;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                      child: Text(S.of(context).allNewMessagesDisappearSelected, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.5)),
                    ),
                    CustomRadioListTile<int>(
                      title: Text(S.of(context).duration24h),
                      value: 1,
                      radioScale: 1.13,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      inactiveIconColor: ChatifyColors.steelGrey,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile<int>(
                      title: Text(S.of(context).duration7d),
                      value: 5,
                      radioScale: 1.13,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      radioPosition: RadioPositionType.left,
                      inactiveIconColor: ChatifyColors.steelGrey,
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile<int>(
                      title: Text(S.of(context).duration90d),
                      value: 60,
                      radioScale: 1.13,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      inactiveIconColor: ChatifyColors.steelGrey,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile<int>(
                      title: Text(S.of(context).off),
                      value: 1440,
                      radioScale: 1.13,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      inactiveIconColor: ChatifyColors.steelGrey,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
          actionsPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
