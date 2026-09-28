import 'dart:io';

abstract class MediaService {
  Future<String?> uploadFile({required File file, required String path});

  Future<String?> createUploadUrl({required String path});

  Future<bool> uploadLargeFile({required File file, required String uploadUrl, String contentType = 'application/octet-stream'});

  Future<void> delete(String path);

  Future<String?> getUrl(String path);

  Future<void> clearUrlCache(String path);
}
