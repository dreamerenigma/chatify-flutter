import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../api/chat_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';

void showDeleteSenderMessageDialog(BuildContext context, List<int> messageIndices, List<MessageModel> list, UserModel user, {VoidCallback? onDeleted}) {
  final isMultiple = messageIndices.length > 1;
  final title = (isMultiple ? S.of(context).deleteMessages : S.of(context).deleteMessage).replaceAll('?', '');
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
          ? '${S.of(context).delete} ${messageIndices.length} ${S.of(context).messagesFrom} $senderNames?'
          : '${S.of(context).deleteMessageFrom} $senderNames?'),
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
            child: Text(S.of(context).cancel, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ),
          TextButton(
            onPressed: () async {
              try {
                for (final index in messageIndices) {
                  await ChatApi.deleteMessage(list[index]);
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                onDeleted?.call();
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToDeleteMessage)));
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).delete, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ),
        ],
      );
    },
  );
}
