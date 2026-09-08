import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'custom_radio_list_tile.dart';
import 'light_dialog.dart';

Future<void> showColorSchemeSelectionDialog(BuildContext context) async {
  String tempColorScheme = colorsController.selectedColorScheme.value;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
          title: Text(S.of(context).selectColorScheme),
          content: SizedBox(
            width: 300,
            child: RadioGroup<String>(
              groupValue: tempColorScheme,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  tempColorScheme = value;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: S.of(context).system,
                    value: 'default',
                    color: ChatifyColors.blue,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: S.of(context).blueColor,
                    value: 'blue',
                    color: ChatifyColors.blue,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: S.of(context).redColor,
                    value: 'red',
                    color: ChatifyColors.red,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: S.of(context).greenColor,
                    value: 'green',
                    color: ChatifyColors.green,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                  buildColorOption(
                    icon: Icons.color_lens,
                    title: S.of(context).orangeColor,
                    value: 'orange',
                    color: ChatifyColors.orange,
                    groupValue: tempColorScheme,
                    onChanged: (value) => setState(() => tempColorScheme = value as String),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(S.of(context).cancel, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm)),
            ),
            TextButton(
              onPressed: () {
                colorsController.setColorScheme(tempColorScheme,);

                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(S.of(context).ok, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm)),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildColorOption({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
  required String groupValue,
  required void Function(String?) onChanged,
}) {
  return CustomRadioListTile(icon: icon, title: Text(title), value: value, iconColor: color);
}
