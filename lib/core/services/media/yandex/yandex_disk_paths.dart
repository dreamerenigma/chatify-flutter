class YandexDiskPaths {
  static String communityAvatar(String communityId) => 'communities/$communityId/avatar.jpg';
  static String userAvatar(String userId) => 'users/$userId/avatar.jpg';
  static String messageImage(String messageId) => 'messages/$messageId/image.jpg';
  static String messageAudio(String conversationId, String messageId) => 'Chats/$conversationId/messages/audio/$messageId.m4a';
  static String messageVideo(String conversationId, String messageId) => 'Chats/$conversationId/messages/video/$messageId.mp4';
  static String messageDocument(String messageId, String fileName) => 'messages/$messageId/$fileName';
}
