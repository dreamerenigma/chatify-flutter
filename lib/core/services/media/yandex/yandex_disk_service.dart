import 'dart:developer';
import 'dart:io';
import 'package:chatify/core/services/media/yandex/yandex_disk_api.dart';
import 'package:http/http.dart' as http;
import '../media_service.dart';

class YandexDiskService implements MediaService {
  final YandexDiskApi _api;

  YandexDiskService(this._api);

  final Map<String, String> _urlCache = {};

  @override
  Future<String?> uploadFile({required File file, required String path}) async {
    final result = await _api.uploadFile(file: file, path: path);

    _urlCache.remove(path);

    return result;
  }

  @override
  Future<void> delete(String path) async {
    await _api.delete(path);
  }

  @override
  Future<String?> getUrl(String path) async {
    if (path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final cachedUrl = _urlCache[path];

    if (cachedUrl != null && cachedUrl.isNotEmpty) {
      return cachedUrl;
    }

    final result = await _api.getDownloadUrl(path);

    if (result != null && result.isNotEmpty) {
      _urlCache[path] = result;
    }

    return result;
  }

  @override
  Future<void> clearUrlCache(String path) async {
    _urlCache.remove(path);
  }

  @override
  Future<String?> createUploadUrl({required String path}) async {
    return _api.createUploadUrl(path: path);
  }

  @override
  Future<bool> uploadLargeFile({
    required File file,
    required String uploadUrl,
    String contentType = 'application/octet-stream',
  }) async {
    final client = http.Client();

    try {
      final fileLength = await file.length();

      log('YANDEX DIRECT: started');
      log('YANDEX DIRECT: file = ${file.path}');
      log('YANDEX DIRECT: size = $fileLength');
      log('YANDEX DIRECT: contentType = $contentType');

      final request = http.StreamedRequest(
        'PUT',
        Uri.parse(uploadUrl),
      );

      request.headers['Content-Type'] = contentType;
      request.contentLength = fileLength;

      log('YANDEX DIRECT: request created');
      log('YANDEX DIRECT: starting HTTP request...');

      // КРИТИЧЕСКИ ВАЖНО:
      // send() запускаем ДО записи данных в sink.
      final responseFuture = client.send(request);

      log('YANDEX DIRECT: HTTP request started');
      log('YANDEX DIRECT: sending file stream...');

      int uploaded = 0;
      int lastPercent = -1;

      try {
        await for (final chunk in file.openRead()) {
          request.sink.add(chunk);

          uploaded += chunk.length;

          final percent =
          ((uploaded / fileLength) * 100).floor();

          if (percent != lastPercent &&
              (percent % 5 == 0 || percent == 100)) {
            lastPercent = percent;

            log(
              'YANDEX DIRECT: progress '
                  '$percent% '
                  '($uploaded / $fileLength bytes)',
            );
          }
        }

        log('YANDEX DIRECT: file stream finished');

        await request.sink.close();

        log('YANDEX DIRECT: request body closed');
      } catch (e, st) {
        log(
          'YANDEX DIRECT: stream error = $e',
          stackTrace: st,
        );

        try {
          await request.sink.close();
        } catch (_) {}

        rethrow;
      }

      log('YANDEX DIRECT: waiting response...');

      final response = await responseFuture;

      log(
        'YANDEX DIRECT: response status = '
            '${response.statusCode}',
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        log('YANDEX DIRECT: upload successful');

        client.close();

        return true;
      }

      final responseBody =
      await response.stream.bytesToString();

      log(
        'YANDEX DIRECT: upload failed: '
            '${response.statusCode}',
      );

      log(
        'YANDEX DIRECT: response body = '
            '$responseBody',
      );

      client.close();

      return false;
    } catch (e, st) {
      log(
        'YANDEX DIRECT: error = $e',
        stackTrace: st,
      );

      client.close();

      return false;
    }
  }
}
