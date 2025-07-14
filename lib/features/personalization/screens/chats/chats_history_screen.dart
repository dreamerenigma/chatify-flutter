import 'package:chatify/features/personalization/screens/chats/select_chat_screen.dart';
import 'package:flutter/material.dart';
import '../../../../routes/custom_page_route.dart';
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
    switch (action) {
      case 'Экспорт чата':
        Navigator.push(
          context,
          createPageRoute(const SelectChatScreen()),
        );
        break;
      case 'Архивировать все чаты':
          showArchiveChatsDialog(context);
        break;
      case 'Очистить все чаты':
          showClearAllChatsDialog(context);
        break;
      case 'Удалить все чаты':
        showDeleteAllChatsDialog(context);
        break;
      default:
        break;
    }
  }

  Widget _buildHistoryChats(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {'icon': Icons.file_upload_outlined, 'text': 'Экспорт чата'},
      {'icon': Icons.archive_outlined, 'text': 'Архивировать все чаты'},
      {'icon': Icons.remove_circle_outline_rounded, 'text': 'Очистить все чаты'},
      {'icon': Icons.delete_outline_outlined, 'text': 'Удалить все чаты'},
    ];

    return ListView(
      children: chats.map((chat) {
        return ListTile(
          leading: Icon(chat['icon'], color: colorsController.getColor(colorsController.selectedColorScheme.value)),
          title: Text(chat['text'], style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
          onTap: () => _handleChatAction(context, chat['text']),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'История чатов',
          style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
        ),
      ),
      body: _buildHistoryChats(context),
    );
  }
}
