import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> setupWindow() async {
  if (kIsWeb || !Platform.isWindows) {
    return;
  }

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(size: Size(800, 600), minimumSize: Size(500, 500), center: true, titleBarStyle: TitleBarStyle.hidden);

  await windowManager.waitUntilReadyToShow(
    windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );
}
