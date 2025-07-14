import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class ChatifyOutlinedButtonTheme {
  ChatifyOutlinedButtonTheme._();


  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: ChatifyColors.dark,
      side: const BorderSide(color: ChatifyColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: ChatifyColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: ChatifySizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ChatifySizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ChatifyColors.light,
      side: const BorderSide(color: ChatifyColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: ChatifyColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: ChatifySizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ChatifySizes.buttonRadius)),
    ),
  );
}
