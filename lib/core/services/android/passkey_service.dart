import 'dart:developer';
import '../../../utils/constants/app_keys.dart';

class PasskeyService {
  static Future<String?> createPasskey() async {
    try {
      final result = await AppKeys.channel.invokeMethod<String>('createPasskey');

      return result;
    } catch (e) {
      log('Passkey error: $e');
      return null;
    }
  }
}
