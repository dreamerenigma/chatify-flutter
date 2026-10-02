import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../utils/constants/app_links.dart';

class YandexDiskApi {
  /// Uploads a file to Yandex Disk through our backend.
  ///
  /// [file] - local file to upload.
  /// [path] - logical path inside Chatify storage.
  ///
  /// Example:
  /// communities/abc123.jpg
  /// users/userId/audio/1758123456789.m4a
  Future<String?> createUploadUrl({required String path}) async {
    try {
      final uri = Uri.parse('${AppLinks.baseUrl}/api/yandex-disk/upload-url');

      log('YANDEX API: requesting direct upload URL');
      log('YANDEX API: path = $path');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'path': path,
        }),
      );

      log('YANDEX API: upload URL status = ''${response.statusCode}');
      log('YANDEX API: upload URL body = ''${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final json = jsonDecode(response.body);

      if (json['success'] != true) {
        log('YANDEX API: backend returned success=false');

        return null;
      }

      final uploadUrl =
      json['data']['href'] as String?;

      if (uploadUrl == null || uploadUrl.isEmpty) {
        log('YANDEX API: upload URL is empty');

        return null;
      }

      log('YANDEX API: direct upload URL received');

      return uploadUrl;
    } catch (e, st) {
      log('YANDEX API: create upload URL error: $e', stackTrace: st);

      return null;
    }
  }

  Future<String?> uploadFile({required File file, required String path}) async {
    try {
      log('YANDEX API: upload started');
      log('YANDEX API: file = ${file.path}');
      log('YANDEX API: path = $path');

      final uri = Uri.parse('${AppLinks.baseUrl}/api/yandex-disk/upload');

      log('YANDEX API: endpoint = $uri');

      final request = http.MultipartRequest('POST', uri);

      request.fields['path'] = path;

      log('YANDEX API: adding multipart file');

      final multipartFile = await http.MultipartFile.fromPath('file', file.path, filename: file.uri.pathSegments.last);

      request.files.add(multipartFile);

      log('YANDEX API: file exists before upload = ''${await file.exists()}');

      log('YANDEX API: file size before upload = ''${await file.length()}');

      log('YANDEX API: multipart request prepared');

      log('YANDEX API: file field = ''${multipartFile.field}');

      log('YANDEX API: file filename = ''${multipartFile.filename}');

      log('YANDEX API: file length = ''${multipartFile.length}');

      log('YANDEX API: request fields = ''${request.fields}');

      log('YANDEX API: request files = ''${request.files.length}');

      log('YANDEX API: request content type = ''${request.headers['content-type']}');

      log('YANDEX API: sending request...');

      final streamedResponse = await request.send().timeout(const Duration(minutes: 5));

      log('YANDEX API: response received: ''${streamedResponse.statusCode}');

      log('YANDEX API: response received: ''${streamedResponse.statusCode}');

      final response = await http.Response.fromStream(streamedResponse);

      log('YANDEX API: response body = ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        log('YANDEX API: upload failed: ''${response.statusCode} ${response.body}');

        return null;
      }

      final json = jsonDecode(response.body);

      log('YANDEX API: decoded response = $json');

      if (json['success'] != true) {
        log('YANDEX API: backend returned success=false');

        return null;
      }

      final uploadedPath = json['data']['path'] as String?;

      log('YANDEX API: uploaded path = $uploadedPath');

      return uploadedPath;
    } on TimeoutException {
      log('YANDEX API: upload TIMEOUT after 30 seconds');

      return null;
    } catch (e, stackTrace) {
      log('YANDEX API: upload error: $e', stackTrace: stackTrace);

      return null;
    }
  }

  /// Returns a temporary download URL for a file.
  ///
  /// [path] is the logical path returned by uploadFile().
  Future<String?> getDownloadUrl(String path) async {
    try {
      final uri = Uri.parse('${AppLinks.baseUrl}/api/yandex-disk/url').replace(queryParameters: {'path': path});

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
