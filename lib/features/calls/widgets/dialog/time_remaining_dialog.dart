import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/create_link_call_screen.dart';

void showTimeRemainingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).callPreviewTimedOut),
        content: Text(S.of(context).pleaseTryAgain),
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ChatifyColors.blue, backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context, createPageRoute(const CreateLinkCallScreen()));
            },
            child: Text(S.of(context).ok, style: TextStyle(fontSize: ChatifySizes.fontSizeMd,  color: colorsController.getColor(colorsController.selectedColorScheme.value))),
          ),
        ],
      );
    },
  );
}
