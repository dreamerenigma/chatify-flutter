import 'app_vectors.dart';

class ChatifyColorAssets {
  final String blue;
  final String red;
  final String green;
  final String orange;

  const ChatifyColorAssets({
    required this.blue,
    required this.red,
    required this.green,
    required this.orange,
  });

  String get(String colorScheme) {
    switch (colorScheme) {
      case 'red':
        return red;
      case 'green':
        return green;
      case 'orange':
        return orange;
      case 'blue':
      default:
        return blue;
    }
  }
}

class ChatifyColorAssetsList {
  ChatifyColorAssetsList._();

  static const strongbox = ChatifyColorAssets(
    red: ChatifyVectors.strongboxRed,
    green: ChatifyVectors.strongboxGreen,
    blue: ChatifyVectors.strongboxBlue,
    orange: ChatifyVectors.strongboxOrange,
  );

  static final scheduledCalls = ChatifyColorAssets(
    red: ChatifyVectors.scheduledCallsRed,
    green: ChatifyVectors.scheduledCallsGreen,
    blue: ChatifyVectors.scheduledCallsBlue,
    orange: ChatifyVectors.scheduledCallsOrange,
  );

  static final addFavorite = ChatifyColorAssets(
    red: ChatifyVectors.addFavoriteRed,
    green: ChatifyVectors.addFavoriteGreen,
    blue: ChatifyVectors.addFavoriteBlue,
    orange: ChatifyVectors.addFavoriteOrange,
  );

  static final createGroup = ChatifyColorAssets(
    red: ChatifyVectors.createGroupRed,
    green: ChatifyVectors.createGroupGreen,
    blue: ChatifyVectors.createGroupBlue,
    orange: ChatifyVectors.createGroupOrange,
  );
}
