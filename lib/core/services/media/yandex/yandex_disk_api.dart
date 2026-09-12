import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

class YandexDiskApi {
  static const String _baseUrl = 'https://chatify-yandex-disk-server.onrender.com';

  /// Uploads a file to Yandex Disk through our backend.
  ///
  /// [file] - local file to upload.
  /// [path] - logical path inside Chatify storage.
  ///
  /// Example:
  /// communities/abc123.jpg
  /// users/userId/audio/1758123456789.m4a
  Future<String?> uploadFile({required File file, required String path}) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/yandex-disk/upload');
      final request = http.MultipartRequest('POST', uri);

      request.fields['path'] = path;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        log('Yandex Disk upload failed: ''${response.statusCode} ${response.body}');

        return null;
      }

      final json = jsonDecode(response.body);

      log('Yandex upload response: ${response.body}');

      if (json['success'] != true) {
        log('Yandex Disk upload failed: ${response.body}');
        return null;
      }

      return json['data']['path'] as String?;
    } catch (e) {
      log('Yandex Disk upload error: $e');

      return null;
    }
  }

  /// Returns a temporary download URL for a file.
  ///
  /// [path] is the logical path returned by uploadFile().
  Future<String?> getDownloadUrl(String path) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/yandex-disk/url').replace(queryParameters: {'path': path});

      final response = await http.get(uri);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        log('Yandex Disk get URL failed: ''${response.statusCode} ${response.body}');

        return null;
      }

      final json = jsonDecode(response.body);

      if (json['success'] != true) {
        log('Yandex Disk get URL failed: ${response.body}');

        return null;
      }

      return json['data']['url'] as String?;
    } catch (e) {
      log('Yandex Disk get URL error: $e');

      return null;
    }
  }

  /// Deletes a file from Yandex Disk.
  ///
  /// NOTE:
  /// The corresponding backend endpoint still needs to be
  /// implemented on the Node.js server.
  Future<void> delete(String path) async {}
}
