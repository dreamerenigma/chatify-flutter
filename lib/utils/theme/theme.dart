import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'widget_themes/app_bar_theme.dart';
import 'widget_themes/bottom_sheet_theme.dart';
import 'widget_themes/checkbox_theme.dart';
import 'widget_themes/chip_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

class ChatifyAppTheme {
  ChatifyAppTheme._();

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Satoshi',
      disabledColor: ChatifyColors.grey,
      brightness: Brightness.light,
      primaryColor: ChatifyColors.primary,
      textTheme: ChatifyTextTheme.lightTextTheme,
      chipTheme: ChatifyChipTheme.lightChipTheme,
      scaffoldBackgroundColor: kIsWeb || Platform.isWindows ? ChatifyColors.transparent : ChatifyColors.white,
      appBarTheme: ChatifyAppBarTheme.lightAppBarTheme,
      checkboxTheme: ChatifyCheckboxTheme.lightCheckboxTheme,
      bottomSheetTheme: ChatifyBottomSheetTheme.lightBottomSheetTheme,
      elevatedButtonTheme: ChatifyElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: ChatifyOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: ChatifyTextFormFieldTheme.lightInputDecorationTheme,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Satoshi',
      disabledColor: ChatifyColors.grey,
      brightness: Brightness.dark,
      primaryColor: ChatifyColors.primary,
      textTheme: ChatifyTextTheme.darkTextTheme,
      chipTheme: ChatifyChipTheme.darkChipTheme,
      scaffoldBackgroundColor: kIsWeb || Platform.isWindows ? ChatifyColors.transparent : ChatifyColors.darkBackground,
      appBarTheme: ChatifyAppBarTheme.darkAppBarTheme,
      checkboxTheme: ChatifyCheckboxTheme.darkCheckboxTheme,
      bottomSheetTheme: ChatifyBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: ChatifyElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: ChatifyOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: ChatifyTextFormFieldTheme.darkInputDecorationTheme,
    );
  }
}
