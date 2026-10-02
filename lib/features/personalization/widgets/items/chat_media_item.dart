import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/enums/chat_media_type.dart';

class ChatMediaItem {
  final String messageId;
  final ChatMediaType type;
  final String path;
  final String? fileName;
  final String? fileSize;
  final Timestamp sent;
  final int? duration;
  final String? thumbnail;

  const ChatMediaItem({
    required this.messageId,
    required this.type,
    required this.path,
    required this.sent,
    this.fileName,
    this.fileSize,
    this.duration,
    this.thumbnail,
  });
}
