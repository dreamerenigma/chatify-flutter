import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showPinMessageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        contentPadding: EdgeInsets.zero,
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text('На сколько закрепить сообщение', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400, height: 1.3)),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            int selectedDuration = 1;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Открепить можно в любой момент', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 17, fontWeight: FontWeight.w400)),
                ),
                RadioGroup<int>(
                  groupValue: selectedDuration,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDuration = value;
                      });
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<int>(
                        title: Text('24 часа', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        value: 1,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        contentPadding: const EdgeInsets.only(left: 14),
                      ),
                      RadioListTile<int>(
                        title: Text('7 дней', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        value: 5,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        contentPadding: const EdgeInsets.only(left: 14),
                      ),
                      RadioListTile<int>(
                        title: Text('30 дней', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        value: 60,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        contentPadding: const EdgeInsets.only(left: 14),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: ChatifyColors.blue,
                                  backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                ),
                                child: Text(S.of(context).cancel, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                              ),
                            ),
                            SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: ChatifyColors.blue,
                                  backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                ),
                                child: Text('Закрепить', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actionsPadding: EdgeInsets.zero,
      );
    },
  );
}
