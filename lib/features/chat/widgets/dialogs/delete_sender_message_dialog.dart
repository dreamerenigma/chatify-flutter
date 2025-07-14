import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';

void showDeleteSenderMessageDialog(BuildContext context, List<int> messageIndices, List<MessageModel> list, UserModel user) {
  final isMultiple = messageIndices.length > 1;
  final title = isMultiple ? 'Удалить сообщения' : 'Удалить сообщение';
  final senderNames = messageIndices.map((index) {
    final message = list[index];
    return APIs.user.uid == message.fromId ? 'Вы' : user.name;
  }).toSet().join(', ');

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(isMultiple
          ? 'Удалить ${messageIndices.length} сообщений от $senderNames?'
          : 'Удалить сообщение от $senderNames?'),
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              for (int index in messageIndices) {
                APIs.deleteMessage(list[index]).then((value) {
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось удалить сообщение')));
                });
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Удалить'),
          ),
        ],
      );
    },
  );
}
