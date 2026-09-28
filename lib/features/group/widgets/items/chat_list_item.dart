import '../../../chat/models/message_model.dart';

class ChatListItem {
  final MessageModel? message;
  final DateTime? date;
  const ChatListItem.message(this.message) : date = null;
  const ChatListItem.date(this.date) : message = null;

  bool get isDate => date != null;
}
