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
}
