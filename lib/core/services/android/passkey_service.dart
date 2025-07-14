import 'dart:developer';
import 'package:flutter/services.dart';

class PasskeyService {
  static const _channel = MethodChannel('com.inputstudios.chatify/passkey');

  static Future<String?> createPasskey() async {
    try {
      final result = await _channel.invokeMethod<String>('createPasskey');
      return result;
    } catch (e) {
      log('Passkey error: $e');
      return null;
    }
  }
}

