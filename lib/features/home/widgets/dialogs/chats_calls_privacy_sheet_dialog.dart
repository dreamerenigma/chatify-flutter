import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import 'contents/chats_calls_privacy_content.dart';

void showChatsCallsPrivacyBottomSheet(BuildContext context, {required String headerText, required String titleText}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return ChatsCallsPrivacyContent(headerText: headerText, titleText: titleText);
    },
  );
}
