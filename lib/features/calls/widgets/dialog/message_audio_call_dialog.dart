import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';

class MessageAudioCallDialog extends StatelessWidget {
  const MessageAudioCallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Не могу говорить. Что случилось?', style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Я сейчас перезвоню.', style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Я перезвоню позже.', style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Не могу говорить. Перезвоните позже?', style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Написать сообщение...', style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
