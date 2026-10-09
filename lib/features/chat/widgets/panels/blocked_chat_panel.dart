import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import 'actions/blocked_chat_action.dart';

class BlockedChatPanel extends StatelessWidget {
  final VoidCallback onDeleteChat;
  final VoidCallback onUnblock;

  const BlockedChatPanel({
    super.key,
    required this.onDeleteChat,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softGrey,
        border: Border(top: BorderSide(color: ChatifyColors.softNight, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: BlockedChatAction(
              icon: FluentIcons.delete_24_regular,
              label: 'Удалить чат',
              color: ChatifyColors.danger,
              onTap: onDeleteChat,
            ),
          ),
          Expanded(
            child: BlockedChatAction(
              icon: Icons.block_flipped,
              label: 'Разблокировать',
              color: ChatifyColors.success,
              onTap: onUnblock,
            ),
          ),
        ],
      ),
    );
  }
}
