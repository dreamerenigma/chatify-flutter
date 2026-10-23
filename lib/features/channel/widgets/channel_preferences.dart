import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants/app_keys.dart';

class ChannelPreferences {
  static Future<bool> hasSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppKeys.introShownKey) ?? false;
  }

  static Future<void> markIntroAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppKeys.introShownKey, true);
  }
}
