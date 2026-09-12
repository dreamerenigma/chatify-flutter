import 'dart:io';

abstract class MediaService {
  Future<String?> uploadImage({required File file, required String path});

  Future<void> delete(String path);

  Future<String?> getUrl(String path);
}
