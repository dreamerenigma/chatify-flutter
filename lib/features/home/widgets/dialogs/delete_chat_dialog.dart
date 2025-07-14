import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../chat/models/user_model.dart';

void showDeleteChatDialog(BuildContext context, List<UserModel> users, List<int> userIndices, UserModel currentUser) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Удалить чаты?'),
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              for (int index in userIndices) {
                final user = users[index];
                APIs.deleteChat(user.id).then((value) {
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось удалить чат')));
                });
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Удалить чаты'),
          ),
        ],
      );
    },
  );
}
