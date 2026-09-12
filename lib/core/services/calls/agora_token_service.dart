import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../utils/constants/app_links.dart';

class AgoraTokenService {
  AgoraTokenService._();

  static Future<String> fetchToken({required String channelName, int uid = 0}) async {
    log('[AGORA_TOKEN] 🔵 Request token ''channel=$channelName uid=$uid', name: 'AgoraTokenService');

    try {
      final response = await http.post(
        Uri.parse('${AppLinks.agoraServer}/agora/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'channelName': channelName,
          'uid': uid,
        }),
      ).timeout(
        const Duration(seconds: 120),
      );

      log('[AGORA_TOKEN] 📥 Response ''status=${response.statusCode}', name: 'AgoraTokenService');

      if (response.statusCode != 200) {
        log('[AGORA_TOKEN] ❌ Server error: ${response.statusCode}', name: 'AgoraTokenService');

        throw Exception('Failed to fetch Agora token: ''HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        log('[AGORA_TOKEN] ❌ Empty token in server response', name: 'AgoraTokenService');

        throw Exception('Agora token is empty');
      }

      log('[AGORA_TOKEN] ✅ Token received ''channel=${data['channelName']} ''uid=${data['uid']} ''expiresIn=${data['expiresIn']}', name: 'AgoraTokenService');

      return token;
    } on TimeoutException {
      log('[AGORA_TOKEN] ⏰ Request timeout', name: 'AgoraTokenService');

      throw Exception('Agora token server did not respond in time');
    } catch (e, stackTrace) {
      log('[AGORA_TOKEN] ❌ Token request failed: $e', name: 'AgoraTokenService', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }

  static Future<void> testServer() async {
    try {
      final url = Uri.parse(
        'https://chatify-agora-server.onrender.com',
      );

      log(
        '[AGORA_TEST] 🌐 Testing URL: $url',
        name: 'AgoraTokenService',
      );

      final response = await http.get(url);

      log(
        '[AGORA_TEST] 📥 status=${response.statusCode}',
        name: 'AgoraTokenService',
      );

      log(
        '[AGORA_TEST] 📄 body=${response.body}',
        name: 'AgoraTokenService',
      );
    } catch (e, stackTrace) {
      log(
        '[AGORA_TEST] ❌ $e',
        name: 'AgoraTokenService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
