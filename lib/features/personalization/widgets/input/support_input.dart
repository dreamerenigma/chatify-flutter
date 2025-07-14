import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../dialogs/light_dialog.dart';

class SupportInput extends StatelessWidget {
  const SupportInput({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {

    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
        decoration: InputDecoration(
          filled: true,
          fillColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
          contentPadding: const EdgeInsets.all(16.0),
          hintText: S.of(context).describeProblem,
          hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
        ),
      ),
    );
  }
}
