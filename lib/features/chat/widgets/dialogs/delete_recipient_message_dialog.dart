import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';

void showDeleteRecipientMessageDialog(BuildContext context, List<int> messageIndices, List<MessageModel> list, UserModel user) {
  final isMultiple = messageIndices.length > 1;
  final title = isMultiple ? 'Удалить сообщения?' : 'Удалить сообщение?';

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
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: const Text('Удалить у всех'),
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
                            ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text('Не удалось удалить сообщение')));
                          }
                        });
                      }
                      Navigator.of(currentContext).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: const Text('Удалить у меня'),
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
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Отмена'),
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
