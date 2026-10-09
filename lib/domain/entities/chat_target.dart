import 'dart:io';
import '../../features/chat/models/mention_data_model.dart';

abstract class ChatTarget {
  Future<void> sendText(String text, {String? replyToMessageId, List<MentionDataModel>? mentions});
  Future<void> sendImage(File file, {String? replyToMessageId});
  Future<void> sendVideo(File file, {String? fileName, String? fileSize, int? videoDuration, String? replyToMessageId});
  Future<void> sendDocument(File file, {String? fileSize, String? replyToMessageId});
  Future<void> sendAudio(File file, String fileName, {int? audioDuration, String? replyToMessageId});
}
