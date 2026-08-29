import 'dart:io';
import 'dart:math' as math;
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/personalization/widgets/dialogs/edit_image_dialog.dart';

class FileUtil {
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  static Future<String> getUserName() async {
    if (kIsWeb) {
      throw UnsupportedError('getUserName is not supported on Web');
    }

    final directory = await getApplicationDocumentsDirectory();
    final username = directory.path.split(Platform.pathSeparator)[2];
    return username;
  }

  static Future<void> pickFileAndProcess({
    required BuildContext context,
    required Function(File) onFileSelected,
    required AnimationController animationController,
    required OverlayEntry? overlayEntry,
  }) async {
    if (kIsWeb) {
      return;
    }

    try {
      final String initialDirectory = "C:\\Users\\${await getUserName()}\\Pictures";
      final List<PlatformFile> files = await FilePicker.pickFiles(type: FileType.image, initialDirectory: initialDirectory);

      if (files.isEmpty) {
        log("Файл не выбран");
        return;
      }

      final PlatformFile file = files.single;
      final String? filePath = file.path;

      if (filePath == null) {
        log("Не удалось получить путь к файлу");
        return;
      }

      final File selectedFile = File(filePath);

      log("Выбран файл: $filePath");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        if (Platform.isWindows) {
          showEditImageDialog(context, position, selectedFile, onFileSelected);
        } else {
          onFileSelected(selectedFile);
        }
      });

      if (overlayEntry != null) {
        animationController.reverse().then((_) {
          overlayEntry.remove();
        });
      }
    } catch (e, stackTrace) {
      log("Ошибка при выборе файла: $e", stackTrace: stackTrace);
    }
  }

  static String cleanDeviceName(String name) {
    RegExp regExp = RegExp(r'([\p{L}\p{N}\s.\-/()]+)', unicode: true);
    Match? match = regExp.firstMatch(name);

    return match != null ? match.group(0) ?? 'Неизвестное устройство' : 'Неизвестное устройство';
  }

  static Future<String> getUserPicturesPath() async {
    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile != null) {
      return '$userProfile\\Pictures';
    }
    return r'C:\';
  }
}
