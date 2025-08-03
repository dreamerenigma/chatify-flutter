import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../confirmation_dialog.dart';

class ChatsOptionWidget extends StatefulWidget {
  const ChatsOptionWidget({super.key});

  @override
  State<ChatsOptionWidget> createState() => _ChatsOptionWidgetState();
}

class _ChatsOptionWidgetState extends State<ChatsOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).chats, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
          const SizedBox(height: 25),
          Text(S.of(context).historiesChats, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(PhosphorIcons.devices(), size: 20),
              const SizedBox(width: 10),
              Text(S.of(context).syncedWithPhone, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w200)),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Material(
              color: ChatifyColors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                ),
                child: InkWell(
                  onTap: () {
                    showConfirmationDialog(context: context, description: S.of(context).archiveAllChats, onConfirm: () {});
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    child: Text(S.of(context).archiveAllChats, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                  ),
                ),
              ),
            ),
          ),
          Text(S.of(context).receiveNewMessagesInArchivedChats, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w200)),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: ChatifyColors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                ),
                child: InkWell(
                  onTap: () {},
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(S.of(context).deleteAllMessages, style: TextStyle(color: ChatifyColors.buttonRed, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                  ),
                ),
              ),
            ),
          ),
          Text(S.of(context).deleteAllMessagesChatsAndGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w200)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: ChatifyColors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                ),
                child: InkWell(
                  onTap: () {},
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(S.of(context).deleteAllChats, style: TextStyle(color: ChatifyColors.buttonRed, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                  ),
                ),
              ),
            ),
          ),
          Text(S.of(context).deleteAllMessagesAndClearChatHistory, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w200)),
        ],
      ),
    );
  }
}
