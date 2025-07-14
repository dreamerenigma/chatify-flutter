import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class ChatifyAppBarTheme{
  ChatifyAppBarTheme._();

  static var lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: ChatifyColors.white,
    surfaceTintColor: ChatifyColors.transparent,
    iconTheme: const IconThemeData(color: ChatifyColors.black, size: ChatifySizes.iconMd),
    actionsIconTheme: const IconThemeData(color: ChatifyColors.black, size: ChatifySizes.iconMd),
    titleTextStyle: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600, color: ChatifyColors.black),
  );
  static var darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: ChatifyColors.blackGrey,
    surfaceTintColor: ChatifyColors.transparent,
    iconTheme: const IconThemeData(color: ChatifyColors.white, size: ChatifySizes.iconMd),
    actionsIconTheme: const IconThemeData(color: ChatifyColors.white, size: ChatifySizes.iconMd),
    titleTextStyle: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w600, color: ChatifyColors.white),
  );
}