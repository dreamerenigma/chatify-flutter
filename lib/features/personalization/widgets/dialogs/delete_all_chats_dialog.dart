import 'package:chatify/features/home/widgets/checkboxes/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showDeleteAllChatsDialog(BuildContext context) {
  final RxList<bool> selectedOptions = <bool>[false].obs;
  bool deleteMediaFiles = false;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('${S.of(context).deleteAllChats}?', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      setState(() {
                        deleteMediaFiles = !deleteMediaFiles;
                        selectedOptions[0] = deleteMediaFiles;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            index: 0,
                            selectedOptions: selectedOptions,
                            onChanged: (bool value) {
                              setState(() {
                                deleteMediaFiles = value;
                                selectedOptions[0] = value;
                              });
                            },
                          ),
                          SizedBox(width: 16),
                          Text(S.of(context).deleteMediaFilesReceivedChats, style: TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
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
                child: Text(S.of(context).deleteAll, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
            ],
          );
        },
      );
    },
  );
}
