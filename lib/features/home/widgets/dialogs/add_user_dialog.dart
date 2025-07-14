import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class ShowAddUserDialog {
  static void showAddUserDialog(BuildContext context) {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        backgroundColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.person_add, color: ChatifyColors.blue, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                S.of(context).addUser,
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          ),
          child: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: S.of(context).emailOrId,
              prefixIcon: const Icon(Icons.email, color: Colors.blue),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blue, width: 2.0)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).cancel, style: TextStyle(color: Colors.blue, fontSize: ChatifySizes.fontSizeMd)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar(context, S.of(context).userNotExists);
                  }
                });
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).add, style: TextStyle(color: Colors.blue, fontSize: ChatifySizes.fontSizeMd)),
          ),
        ],
      ),
    );
  }
}
