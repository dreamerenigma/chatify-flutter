import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';

Future<void> enableAutoLaunch({String appName = 'Chatify'}) async {
  final shell = Shell();
  final executablePath = Platform.resolvedExecutable;
  final startupFolder = Platform.environment['APPDATA']! + r'\Microsoft\Windows\Start Menu\Programs\Startup';
  final shortcutPath = p.join(startupFolder, '$appName.lnk');

  if (!File(shortcutPath).existsSync()) {
    await shell.run('''
      powershell "\$s=(New-Object -COM WScript.Shell).CreateShortcut('$shortcutPath'); 
      \$s.TargetPath='${executablePath.replaceAll(r'\', r'\\')}'; 
      \$s.Save()"
    ''');
  }
}

Future<void> disableAutoLaunch({String appName = 'Chatify'}) async {
  final startupFolder = Platform.environment['APPDATA']! + r'\Microsoft\Windows\Start Menu\Programs\Startup';
  final shortcutPath = p.join(startupFolder, '$appName.lnk');

  final file = File(shortcutPath);
  if (file.existsSync()) {
    await file.delete();
  }
}

bool isAutoLaunchEnabled({String appName = 'MyFlutterApp'}) {
  final startupFolder = Platform.environment['APPDATA']! + r'\Microsoft\Windows\Start Menu\Programs\Startup';
  final shortcutPath = p.join(startupFolder, '$appName.lnk');

  return File(shortcutPath).existsSync();
}
