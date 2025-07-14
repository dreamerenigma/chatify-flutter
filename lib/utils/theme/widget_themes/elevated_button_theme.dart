import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class ChatifyElevatedButtonTheme {
  ChatifyElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: ChatifyColors.light,
      backgroundColor: ChatifyColors.primary,
      disabledForegroundColor: ChatifyColors.darkGrey,
      disabledBackgroundColor: ChatifyColors.buttonDisabled,
      side: const BorderSide(color: ChatifyColors.primary),
      padding: const EdgeInsets.symmetric(vertical: ChatifySizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: ChatifyColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ChatifySizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: ChatifyColors.light,
      backgroundColor: ChatifyColors.primary,
      disabledForegroundColor: ChatifyColors.darkGrey,
      disabledBackgroundColor: ChatifyColors.darkerGrey,
      side: const BorderSide(color: ChatifyColors.primary),
      padding: const EdgeInsets.symmetric(vertical: ChatifySizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: ChatifyColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ChatifySizes.buttonRadius)),
    ),
  );
}
