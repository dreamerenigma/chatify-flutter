class YandexDiskPaths {
  static String communityAvatar(String communityId) => 'communities/$communityId/avatar.jpg';
  static String userAvatar(String userId) => 'users/$userId/avatar.jpg';
  static String messageImage(String messageId) => 'messages/$messageId/image.jpg';
}
