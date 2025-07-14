import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showVerifyCodeBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, size: 25),
                color: ChatifyColors.darkGrey,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            child: const Icon(Icons.message, color: ChatifyColors.white, size: 25),
          ),
          const SizedBox(height: 16),
          Text(S.of(context).receiveYourConfirmCode, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(S.of(context).pleaseCheckYourSmsMessagesNewCode, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ChatifyColors.ascentBlue,
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.message, color: ChatifyColors.white, size: 20),
                    label: Text(S.of(context).repeatSms, style: TextStyle(color: ChatifyColors.white, fontWeight: FontWeight.w400)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      backgroundColor: ChatifyColors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: Icon(Icons.call_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 20),
                    label: Text(S.of(context).callMe, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
