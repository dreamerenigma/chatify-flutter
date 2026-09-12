import 'dart:developer';
import 'dart:io';
import 'package:chatify/core/services/media/yandex/yandex_disk_api.dart';
import '../media_service.dart';

class YandexDiskService implements MediaService {
  final YandexDiskApi _api;

  YandexDiskService(this._api);

  @override
  Future<String?> uploadImage({required File file, required String path}) async {
    return await _api.uploadFile(file: file, path: path);
  }

  @override
  Future<void> delete(String path) async {
    await _api.delete(path);
  }

  @override
  Future<String?> getUrl(String path) async {
    log('YANDEX SERVICE getUrl INPUT: $path');

    if (path.startsWith('http://') || path.startsWith('https://')) {
      log('YANDEX SERVICE: path уже является URL');
      return path;
    }

    log('YANDEX SERVICE: вызываем _api.getDownloadUrl()');

    final result = await _api.getDownloadUrl(path);

    log('YANDEX SERVICE: getDownloadUrl RESULT: $result');

    return result;
  }
}
