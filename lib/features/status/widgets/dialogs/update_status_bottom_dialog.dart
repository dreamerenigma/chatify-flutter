import 'package:chatify/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showUpdateStatusSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Text(S.of(context).seeMyStatusUpdates, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 16.0),
          _buildRadioOption(
            context: context,
            title: S.of(context).myContacts,
            value: 1,
          ),
          _buildRadioOption(
            context: context,
            title: S.of(context).contactsOtherThan,
            value: 2,
            trailingText: S.of(context).exceptions,
          ),
          _buildRadioOption(
            context: context,
            title: S.of(context).only,
            value: 3,
            trailingText: S.of(context).onZero,
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  side: BorderSide.none,
                ),
                child: Text(S.of(context).ready, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildRadioOption({required BuildContext context, required String title, required int value, String? trailingText}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: RadioListTile<int>(
      value: value,
      groupValue: 1,
      activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      onChanged: (int? newValue) {},
      title: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
      secondary: trailingText != null ? Text(trailingText, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))) : null,
      contentPadding: EdgeInsets.zero,
    ),
  );
}
