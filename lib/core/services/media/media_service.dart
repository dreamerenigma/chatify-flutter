import 'dart:io';

abstract class MediaService {
  Future<String?> uploadFile({required File file, required String path});

  Future<void> delete(String path);

  Future<String?> getUrl(String path);

  Future<void> clearUrlCache(String path);
}
