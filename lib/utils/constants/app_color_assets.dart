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
    blue: ChatifyVectors.strongboxBlue,
    red: ChatifyVectors.strongboxRed,
    green: ChatifyVectors.strongboxGreen,
    orange: ChatifyVectors.strongboxOrange,
  );

  static final scheduledCalls = ChatifyColorAssets(
    blue: ChatifyVectors.scheduledCallsBlue,
    red: ChatifyVectors.scheduledCallsRed,
    green: ChatifyVectors.scheduledCallsGreen,
    orange: ChatifyVectors.scheduledCallsOrange,
  );
}
