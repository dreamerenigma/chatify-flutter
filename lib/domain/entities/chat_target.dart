import 'dart:io';

abstract class ChatTarget {
  Future<void> sendImage(File file);
  Future<void> sendVideo(File file);
  Future<void> sendDocument(File file);
  Future<void> sendAudio(File file, String fileName);
}
