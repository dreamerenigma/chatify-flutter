import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
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
            title: Text(S.of(context).cantTalkWhatHappened, style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(S.of(context).callYouBackNow, style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(S.of(context).callBackLater, style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(S.of(context).cantTalkCallBackLater, style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(S.of(context).writeMessage, style: TextStyle(color: ChatifyColors.darkGrey)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
