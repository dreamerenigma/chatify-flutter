import 'dart:io' show Platform;
import 'package:chatify/utils/shader_warm_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'app.dart';
import 'core/services/notifications/notification_service.dart';

/// Entry point of Flutter App
Future<void> main() async {
  /// Initialize application dependencies and services
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Notification service
  if (!kIsWeb && Platform.isWindows) {
    await NotificationService.init();
  }

  /// Initialize Media Kit
  MediaKit.ensureInitialized();

  /// Initialize application services
  await initApp();

  /// Shader Warm-Up
  preloadShader();

  /// Run the application
  runApp(const App());
}
