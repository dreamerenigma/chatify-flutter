import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final Uuid uuid = Uuid();

class NotificationService {
  static Future<void> init() async {
    String generatedGuid = uuid.v4();

    var initializationSettings = InitializationSettings(
      windows: WindowsInitializationSettings(
        appName: 'Chatify',
        appUserModelId: 'com.inputstudios.chatify',
        guid: generatedGuid,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        showMessageDialog(response);
      },
    );
  }

  static void show(String title, String body) {
    var notificationDetails = NotificationDetails(
      windows: WindowsNotificationDetails(subtitle: body),
    );

    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  static void showMessageDialog(NotificationResponse response) {
    log('Открыть окно с сообщением');
    if (response.payload != null) {
      log('Payload: ${response.payload}');
    }
  }
}
