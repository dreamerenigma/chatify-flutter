import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';

void showDeleteRecipientMessageDialog(BuildContext context, List<int> messageIndices, List<MessageModel> list, UserModel user) {
  final isMultiple = messageIndices.length > 1;
  final title = isMultiple ? S.of(context).deleteMessages : '${S.of(context).deleteMessage}?';

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.zero,
        backgroundColor: Theme.of(dialogContext).brightness == Brightness.dark ? ChatifyColors.blackGrey : ChatifyColors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ChatifyColors.blue,
                      backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: Text(S.of(context).deleteFromAll),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {
                      final currentContext = dialogContext;

                      for (int index in messageIndices) {
                        APIs.deleteMessage(list[index]).catchError((error) {
                          if (currentContext.mounted) {
                            ScaffoldMessenger.of(currentContext).showSnackBar(SnackBar(content: Text(S.of(context).failedToDeleteMessage)));
                          }
                        });
                      }
                      Navigator.of(currentContext).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ChatifyColors.blue,
                      backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: Text(S.of(context).deleteFromMe),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ChatifyColors.blue,
                      backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(S.of(context).cancel),
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
