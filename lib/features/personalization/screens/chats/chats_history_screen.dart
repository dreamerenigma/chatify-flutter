import 'package:chatify/features/personalization/screens/chats/select_chat_screen.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/archive_chats_dialog.dart';
import '../../widgets/dialogs/clear_all_chats_dialog.dart';
import '../../widgets/dialogs/delete_all_chats_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';

class ChatsHistoryScreen extends StatefulWidget {
  const ChatsHistoryScreen({super.key});

  @override
  State<ChatsHistoryScreen> createState() => _ChatsHistoryScreenState();
}

class _ChatsHistoryScreenState extends State<ChatsHistoryScreen> {
  void _handleChatAction(BuildContext context, String action) {
    final s = S.of(context);

    switch (action) {
      case 'Экспорт чата':
      case var _ when action == s.exportChat:
        Navigator.push(context, createPageRoute(const SelectChatScreen()));
        break;
      case var _ when action == s.archiveAllChats:
        showArchiveChatsDialog(context);
        break;
      case var _ when action == s.clearAllChats:
        showClearAllChatsDialog(context);
        break;
      case var _ when action == s.deleteAllChats:
        showDeleteAllChatsDialog(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).historiesChats, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildHistoryChats(context),
    );
  }

  Widget _buildHistoryChats(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {'icon': Icons.file_upload_outlined, 'text': S.of(context).exportChat},
      {'icon': Icons.archive_outlined, 'text': S.of(context).archiveAllChats},
      {'icon': Icons.remove_circle_outline_rounded, 'text': S.of(context).clearAllChats},
      {'icon': FluentIcons.delete_24_regular, 'text': S.of(context).deleteAllChats},
    ];

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView(
        children: chats.map((chat) {
          return Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () => _handleChatAction(context, chat['text']),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(chat['icon'], size: 25, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(chat['text'], style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
