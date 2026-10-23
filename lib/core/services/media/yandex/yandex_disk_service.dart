import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chatify/core/services/media/yandex/yandex_disk_api.dart';
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
  Future<bool> uploadLargeFile({required File file, required String uploadUrl, String contentType = 'application/octet-stream'}) async {
    final uploadId = DateTime.now().microsecondsSinceEpoch;
    final stopwatch = Stopwatch()..start();

    log('UPLOAD[$uploadId]: starting');

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 30);

    try {
      if (!await file.exists()) {
        log('UPLOAD: file does not exist: ${file.path}');
        return false;
      }

      final fileLength = await file.length();

      if (fileLength == 0) {
        log('UPLOAD: file is empty');
        return false;
      }

      final uri = Uri.parse(uploadUrl);

      log('UPLOAD: starting');
      log('UPLOAD: size = $fileLength bytes');
      log('UPLOAD: host = ${uri.host}');

      final request = await client.openUrl('PUT', uri).timeout(
        const Duration(seconds: 30),
      );

      request.headers.set(HttpHeaders.contentTypeHeader, contentType);
      request.contentLength = fileLength;

      var uploaded = 0;
      var lastPercent = -5;

      final stopwatch = Stopwatch()..start();
      var lastLoggedBytes = 0;
      var lastLoggedSeconds = 0;

      final trackedStream = file.openRead().map((chunk) {
        uploaded += chunk.length;

        final percent = (uploaded * 100 / fileLength).floor();
        final elapsedSeconds = stopwatch.elapsed.inSeconds;

        if (percent >= lastPercent + 5 || percent == 100) {
          final elapsed = stopwatch.elapsedMilliseconds / 1000;
          final speedMBps = elapsed > 0 ? uploaded / elapsed / (1024 * 1024) : 0.0;

          lastPercent = percent;

          log('UPLOAD: $percent% | ''${(uploaded / (1024 * 1024)).toStringAsFixed(1)} MB / ''${(fileLength / (1024 * 1024)).toStringAsFixed(1)} MB | ''elapsed=${elapsed.toStringAsFixed(1)} s | ''average=${speedMBps.toStringAsFixed(2)} MB/s');

          final intervalBytes = uploaded - lastLoggedBytes;
          final intervalSeconds = elapsedSeconds - lastLoggedSeconds;

          if (intervalSeconds > 0) {
            final intervalSpeed = intervalBytes / intervalSeconds / (1024 * 1024);

            log('UPLOAD: recent speed = ''${intervalSpeed.toStringAsFixed(2)} MB/s');
          }

          lastLoggedBytes = uploaded;
          lastLoggedSeconds = elapsedSeconds;
        }

        return chunk;
      });

      log('UPLOAD: sending body');

      try {
        await request.addStream(trackedStream);
        log('UPLOAD: body stream completed');
      } catch (e, st) {
        log('UPLOAD: body stream failed: $e', stackTrace: st);
        rethrow;
      }

      log('UPLOAD: closing request and waiting for response');

      final response = await request.close().timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          throw TimeoutException('Timed out waiting for Yandex Disk response');
        },
      );

      log('UPLOAD: HTTP status = ${response.statusCode}');

      final responseBody = await response.transform(utf8.decoder).join().timeout(const Duration(seconds: 30));

      log('UPLOAD: response body = $responseBody');

      final success = response.statusCode >= 200 && response.statusCode < 300;

      log('UPLOAD: success = $success');

      return success;
    } catch (e, st) {
      log('UPLOAD: error = $e', stackTrace: st);
      return false;
    } finally {
      client.close(force: true);
    }
  }
}
