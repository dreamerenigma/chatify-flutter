import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class ChatifyTextFormFieldTheme {
  ChatifyTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: ChatifyColors.darkGrey,
    suffixIconColor: ChatifyColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: ChatifySizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: ChatifyColors.black.withAlpha((0.8 * 255).toInt())),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.grey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: ChatifyColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: ChatifyColors.darkGrey,
    suffixIconColor: ChatifyColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: ChatifySizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: ChatifyColors.white.withAlpha((0.8 * 255).toInt())),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: ChatifyColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: ChatifyColors.warning),
    ),
  );
}
