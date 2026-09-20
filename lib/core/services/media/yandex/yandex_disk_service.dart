import 'dart:io';
import 'package:chatify/core/services/media/yandex/yandex_disk_api.dart';
import '../media_service.dart';

class YandexDiskService implements MediaService {
  final YandexDiskApi _api;

  YandexDiskService(this._api);

  @override
  Future<String?> uploadFile({required File file, required String path}) async {
    return await _api.uploadFile(file: file, path: path);
  }

  @override
  Future<void> delete(String path) async {
    await _api.delete(path);
  }

  @override
  Future<String?> getUrl(String path) async {

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final result = await _api.getDownloadUrl(path);

    return result;
  }
}
