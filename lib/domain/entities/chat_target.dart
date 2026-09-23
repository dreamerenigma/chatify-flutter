import 'dart:io';

abstract class ChatTarget {
  Future<void> sendText(String text);
  Future<void> sendImage(File file);
  Future<void> sendVideo(File file, {String? fileName, String? fileSize, int? videoDuration});
  Future<void> sendDocument(File file);
  Future<void> sendAudio(File file, String fileName, {
    int? audioDuration
  });
}
