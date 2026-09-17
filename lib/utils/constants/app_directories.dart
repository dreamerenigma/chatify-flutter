import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AppDirectories {
  /// Create app directories.
  static Future<void> createDirectories() async {
    if (kIsWeb) {
      return;
    }

    Directory? baseDir;

    if (defaultTargetPlatform == TargetPlatform.windows) {
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getExternalStorageDirectory();
    }

    if (baseDir != null) {
      String mediaPath = path.join(baseDir.path, 'Android', 'media', 'com.chatify', 'Chatify', 'Media');

      List<String> directories = [
        'WallPaper',
        'Chatify Audio',
        'Chatify Documents',
        'Chatify Images',
        'Chatify Profile Photos',
        'Chatify Stickers',
        'Chatify Video',
        'Chatify Voice',
      ];

      for (String dirName in directories) {
        String dirPath = path.join(mediaPath, dirName);
        Directory directory = Directory(dirPath);

        if (!(await directory.exists())) {
          await directory.create(recursive: true);
          log('Создан каталог: $dirPath');
        }
      }
    }
  }

  /// .
  static Future<String?> getVoiceDirectory() async {
    if (kIsWeb) {
      return null;
    }

    Directory? baseDir;

    if (defaultTargetPlatform == TargetPlatform.windows) {
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getExternalStorageDirectory();
    }

    if (baseDir == null) {
      return null;
    }

    final voicePath = path.join(baseDir.path, 'Android', 'media', 'com.chatify', 'Chatify', 'Media', 'Chatify Voice');
    final directory = Directory(voicePath);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return voicePath;
  }
}
