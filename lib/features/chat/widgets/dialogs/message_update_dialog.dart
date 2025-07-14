import 'package:chatify/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';

class ShowMessageUpdateDialog {
  static void showMessageUpdateDialog(BuildContext context, MessageModel message, VoidCallback onUpdate) {
    String updateMsg = message.msg;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        actionsPadding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.message, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
            SizedBox(width: DeviceUtils.getScreenWidth(context) * .05),
            Expanded(
              child: Text(S.of(context).updateMessage,
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
            initialValue: updateMsg,
            maxLines: null,
            onChanged: (value) => updateMsg = value,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.0),
              ),
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
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).cancel,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              APIs.updateMessage(message, updateMsg).then((_) {
                onUpdate();
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).update,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
        ],
      ),
    );
  }
}
