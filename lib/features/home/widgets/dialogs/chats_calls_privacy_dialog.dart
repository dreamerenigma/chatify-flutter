import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import 'contents/chats_calls_privacy_content.dart';

void showChatsCallsPrivacyDialog(BuildContext context, {required String headerText, required String titleText}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: ChatsCallsPrivacyContent(headerText: headerText, titleText: titleText, isDialog: true),
        ),
      );
    }
  );
}
