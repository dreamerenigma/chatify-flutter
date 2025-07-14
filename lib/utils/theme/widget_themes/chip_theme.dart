import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ChatifyChipTheme {
  ChatifyChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
    labelStyle: const TextStyle(color: ChatifyColors.black),
    selectedColor: ChatifyColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: ChatifyColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: ChatifyColors.darkerGrey,
    labelStyle: TextStyle(color: ChatifyColors.white),
    selectedColor: ChatifyColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: ChatifyColors.white,
  );
}
