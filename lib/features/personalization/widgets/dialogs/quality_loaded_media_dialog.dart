import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

Future<String?> showQualityLoadedMediaDialog(BuildContext context, String currentQuality) {
  final ValueNotifier<String> selectedQualityNotifier = ValueNotifier<String>(currentQuality);

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).mediaDownloadQuality, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        contentPadding: EdgeInsets.zero,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actionsPadding: const EdgeInsets.all(16),
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        content: ValueListenableBuilder<String>(
          valueListenable: selectedQualityNotifier,
          builder: (context, selectedQuality, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 25, bottom: 16),
                  child: Text(
                    S.of(context).mediaDownloadQuality,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                  ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: Text(S.of(context).standardQuality),
                  subtitle: Text(S.of(context).fasterSendingSmallerFile),
                  value: 'standard',
                  groupValue: selectedQuality,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (String? value) {
                    if (value != null) {
                      selectedQualityNotifier.value = value;
                    }
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                RadioListTile<String>(
                  title: Text(S.of(context).hdQuality),
                  subtitle: Text(S.of(context).slowerShippingSixTimesBigger),
                  value: 'hd',
                  groupValue: selectedQuality,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (String? value) {
                    if (value != null) {
                      selectedQualityNotifier.value = value;
                    }
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedQualityNotifier.value);
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              S.of(context).save,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm),
            ),
          ),
        ],
      );
    },
  );
}
