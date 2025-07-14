import 'package:get/get.dart';

class EmojiStickersController extends GetxController {
  var selectedIndex = 0.obs;
  var panelSelectedIndex = 0.obs;
  var recentEmojis = <String>[].obs;
  var selectedCategory = <String>[].obs;
  var selectedEmojiInRow = RxnString();
  var selectedEmojiInCategory = RxnString();

  void addRecentEmoji(String emoji) {
    recentEmojis.remove(emoji);
    recentEmojis.insert(0, emoji);

    if (recentEmojis.length > 50) {
      recentEmojis.removeLast();
    }
  }

  void selectEmojiInRow(String emoji) {
    selectedEmojiInCategory.value = null;
    selectedEmojiInRow.value = emoji;
  }

  void selectEmojiInCategory(String emoji) {
    selectedEmojiInRow.value = null;
    selectedEmojiInCategory.value = emoji;
  }
}
