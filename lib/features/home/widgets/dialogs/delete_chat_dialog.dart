import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../chat/models/user_model.dart';

void showDeleteChatDialog(BuildContext context, List<UserModel> users, UserModel currentUser) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).deleteChats),
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: ChatifyColors.blue,
              backgroundColor: ChatifyColors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                for (final user in users) {
                  await APIs.deleteChat(user.id);
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedDeleteChat)));
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text('${S.of(context).deleteChats}?'),
          ),
        ],
      );
    },
  );
}
