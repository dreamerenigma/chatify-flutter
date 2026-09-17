import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/custom_radio_list_tile.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';

void showReminderCallBottomDialog(BuildContext context) {
  String selectedReminder = '15_minutes';

  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (bottomSheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RadioGroup<String>(
                groupValue: selectedReminder,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedReminder = value;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 14),
                    Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 14),
                    SizedBox(height: 6),
                    SizedBox(
                      height: 56,
                      child: Stack(
                        children: [
                          Center(child: Text('Напоминание', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400))),
                          Positioned(
                            right: 8,
                            top: 4,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 26),
                              onPressed: () {
                                Navigator.pop(bottomSheetContext);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0),
                    Padding(
                      padding: const EdgeInsets.only(left: 26, right: 26, top: 8, bottom: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Гости тоже получат уведомление о начале звонка.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center),
                      ),
                    ),
                    CustomRadioListTile(
                      title: const Text('За 15 минут'),
                      value: '15_minutes',
                      iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile(
                      title: const Text('За 30 минут'),
                      value: '30_minutes',
                      iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile(
                      title: const Text('За 1 час'),
                      value: 'hour',
                      iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile(
                      title: const Text('За 1 день'),
                      value: 'day',
                      iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile(
                      title: const Text('Никогда'),
                      value: 'never',
                      iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
