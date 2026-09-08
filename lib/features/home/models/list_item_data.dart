import '../../../core/enums/chat_list_type.dart';

class ListItemData {
  final String title;
  final String? subtitle;
  final bool canDelete;
  final ChatListType type;

  const ListItemData({
    required this.title,
    this.subtitle,
    required this.canDelete,
    required this.type,
  });
}
