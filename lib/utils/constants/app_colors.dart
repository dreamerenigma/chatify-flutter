import 'package:flutter/material.dart';

class ChatifyColors {
  // App theme colors
  static const Color primary = Color(0xFF3ED0A0);
  static const Color primaryDark = Color(0xFF2DA27E);
  static const Color primaryCyan = Color(0xFFA8E5EC);
  static const Color blue = Color(0xFF2196F3);
  static const Color blueAccent = Color(0xFF90CAF9);
  static const Color accent = Color(0xFFB0C7FF);
  static const Color secondary = Color(0xFFFFE24B);

  // Error and validation colors
  static const Color error = Color(0xffFF5151);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = Color(0xFF388E3C);
  static const Color check = Color(0xFF25D22E);
  static const Color info = Color(0xFF1976D2);

  // Button colors
  static const Color buttonDarkGrey = Color(0xFF424242);
  static const Color buttonSecondaryDark = Color(0xFF2F3537);
  static const Color buttonLightGrey = Color(0xFF5D6068);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color iconGrey = Color(0xFFABABAB);
  static const Color buttonGrey = Color(0xFFBDBDBD);
  static const Color buttonDisabled = Color(0xFFC4C4C4);
  static const Color switcherPrimary = Color(0xff437967);
  static const Color buttonPrimary = Color(0xFF64BD9F);
  static const Color buttonRed = Color(0xffff6b6b);

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color dark = Color(0xFF272727);
  static const Color light = Color(0xFFF6F6F6);
  static const Color lightBackground = Color(0xFFF2F2F2);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container colors
  static Color darkContainer = ChatifyColors.white.withAlpha((0.1 * 255).toInt());
  static const Color lightContainer = Color(0xFFF6F6F6);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Neutral Shades
  static const Color transparent = Color(0x00FFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color softBlack = Color(0xFF070707);
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color nightGrey = Color(0xFF171717);
  static const Color deepNight = Color(0xFF1C1C1C);
  static const Color youngNight = Color(0xFF232323);
  static const Color mildNight = Color(0xFF2F2F2F);
  static const Color softNight = Color(0xFF363636);
  static const Color lightSoftNight = Color(0xFF424242);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color steelGrey = Color(0xFF6C6C6C);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

  // Other colors
  static const Color greyBlue = Color(0xFF0B141A);
  static const Color cardColor = Color(0xFF111111);
  static const Color blackGrey = Color(0xFF171717);
  static const Color popupColorDark = Color(0xFF202528);
  static const Color darkSlate = Color(0xFF252525);
  static const Color lightSlate = Color(0xFF2C3437);
  static const Color popupColor = Color(0xFF30333A);
  static const Color community = Color(0xFF2E5330);
  static const Color greenColor = Color(0xFF4CA173);
  static const Color ascentBlue = Color(0xFF155E93);
  static const Color yellow = Color(0xFFF7CC76);
  static const Color ascentRed = Color(0xFFC42B1C);
  static const Color red = Color(0xFFFF0000);

  // Circle button
  static const Color violet = Color(0xFF7F66FE);
  static const Color violetDark = Color(0xFF6F59DA);
  static const Color pink = Color(0xFFFE2E74);
  static const Color pinkDark = Color(0xFFE02B65);
  static const Color purple = Color(0xFFC861F9);
  static const Color purpleDark = Color(0xFFB156DA);
  static const Color orange = Color(0xFFF96533);
  static const Color orangeDark = Color(0xFFE05B2E);
  static const Color green = Color(0xFF1DA960);
  static const Color greenDark = Color(0xFF1A9A57);
  static const Color lightBlue = Color(0xFF009DE1);
  static const Color lightBlueDark = Color(0xFF038BC9);
  static const Color blueGreen = Color(0xFF02A698);
  static const Color blueGreenDark = Color(0xFF02968B);

  // Message colors
  static const Color greenMessageLight = Color(0xFFDAFFB0);
  static const Color greenMessageDark = Color(0xFF005C4B);
  static const Color greenMessageBorder = Color(0xFFD1FF98);
  static const Color greenMessageBorderDark = Color(0xFF005643);
  static const Color greenMessageBorderLight = Color(0xFF1A6A5C);
  static const Color greenMessageButton = Color(0xFF277366);
  static const Color greenMessageDivider = Color(0xFF175F53);
  static const Color blueMessageLight = Color(0xFFDDF5FF);
  static const Color blueMessageBorder = Color(0xFFCFF2FF);

  // Scheme colors
  static Color getColorByScheme(String scheme) {
    switch (scheme) {
      case 'red':
        return ChatifyColors.red;
      case 'green':
        return ChatifyColors.green;
      case 'orange':
        return ChatifyColors.orange;
      case 'blue':
      default:
        return ChatifyColors.blue;
    }
  }

  // Wallpaper chat color light
  static final List<Color> containerColorsLight = [
    Color(0xFFF1F1F1),
    Color(0xFFC3E1DC),
    Color(0xFF8DE7B7),
    Color(0xFF8FC0D9),
    Color(0xFFF7E5F8),
    Color(0xFFE794B1),
    Color(0xFFE16464),
    Color(0xFFE1D3A4),
    Color(0xFFD5CDAE),
    Color(0xFFB2B2B2),
  ];

  // Wallpaper chat color dark
  static final List<Color> containerColorsDark = [
    Color(0xFF383838),
    Color(0xFF595E53),
    Color(0xFF505946),
    Color(0xFF40565A),
    Color(0xFF57555C),
    Color(0xFF4E4D64),
    Color(0xFF683A43),
    Color(0xFF685D4F),
    Color(0xFF665B4E),
    Color(0xFF555555),
  ];
}
