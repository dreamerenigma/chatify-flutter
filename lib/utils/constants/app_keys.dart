import 'package:flutter/services.dart';

class AppKeys {
  static const message = 'animation_message';
  static const emoji = 'animation_emoji';
  static const sticker = 'animation_sticker';
  static const gif = 'animation_gif';
  static const channel = MethodChannel('com.inputstudios.chatify/passkey');
  static const shortcutChannel = MethodChannel('com.inputstudios.chatify/shortcuts');
  static const String latestStatusesExpandedKey = 'latest_statuses_expanded';
  static const String privacyProtectionKey = 'chat_privacy_protection';
  static const String storageKey = 'backgroundImagePath';
  static const String selectedColorIndexKey = 'selected_chat_color_index';
  static const String accessKeyHiddenUntilKey = 'access_key_hidden_until';
  static const String eventManagementClosedAtKey = 'event_management_closed_at';
  static const String geolocationDialogShownKey = 'geolocation_dialog_shown';
  static const String introShownKey = 'create_channel_intro_shown';
}
