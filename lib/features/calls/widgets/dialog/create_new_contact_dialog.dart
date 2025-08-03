import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/add_new_contact_bottom_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CreateNewContactDialog extends StatelessWidget {
  const CreateNewContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showCreateNewContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.softGrey,
          title: Text(S.of(context).createNewContactOrAddExistingOne,
            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                const intent = AndroidIntent(
                  action: 'android.intent.action.VIEW',
                  data: 'content://contacts/people',
                  package: 'com.android.contacts',
                );
                await intent.launch();
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                S.of(context).existing,
                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
              ),
            ),
            TextButton(
              onPressed: () {
                final double maxHeight = MediaQuery.of(context).size.height * 0.62;
                Navigator.pop(context);
                showAddNewContactBottomSheetDialog(context, maxHeight);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(S.of(context).createNewContact,
                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
              ),
            ),
          ]
        );
      }
    );
  }
}
