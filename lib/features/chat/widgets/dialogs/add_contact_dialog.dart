import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/add_new_contact_bottom_dialog.dart';

void showAddContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                final double maxHeight = MediaQuery.of(context).size.height * 0.62;
                showAddNewContactBottomSheetDialog(context, maxHeight);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(S.of(context).createNewContactDialog, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(S.of(context).addExistingContact, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
