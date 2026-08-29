import 'dart:io' show Platform;
import 'package:chatify/utils/shader_warm_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:media_kit/media_kit.dart';
import 'app.dart';
import 'bindings/general_bindings.dart';
import 'core/services/notifications/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  /// -- Initialize application dependencies and services
  WidgetsFlutterBinding.ensureInitialized();

  /// -- Initialize Notification service
  if (!kIsWeb && Platform.isWindows) {
    await NotificationService.init();
  }

  /// -- Initialize Media Kit
  MediaKit.ensureInitialized();

  /// -- GetX Local Storage
  await GetStorage.init();

  /// -- Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((FirebaseApp value) {});

  /// -- Initialize bindings here to ensure they're ready
  GeneralBindings().dependencies();

  /// -- Initialize application services
  await initApp();

  /// -- Shader Warm-Up
  preloadShader();

  /// -- Run the application
  runApp(const App());
}
