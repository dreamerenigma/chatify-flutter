class YandexDiskPaths {
  static String communityAvatar(String communityId) => 'communities/$communityId/avatar.jpg';
  static String userAvatar(String userId) => 'users/$userId/avatar.jpg';
  static String messageImage(String messageId) => 'messages/$messageId/image.jpg';
  static String messageAudio(String conversationId, String messageId) => 'Chats/$conversationId/messages/audio/$messageId.m4a';
  static String messageVoice(String conversationId, String messageId) => 'Chats/$conversationId/messages/voices/$messageId.m4a';
  static String messageVideo(String conversationId, String messageId) => 'Chats/$conversationId/messages/videos/$messageId.mp4';
  static String messageDocument(String conversationId, String messageId, String fileName) => 'Chats/$conversationId/messages/documents/$messageId/$fileName';
}
