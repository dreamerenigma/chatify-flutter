import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'light_dialog.dart';

class BirthdayConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;

  const BirthdayConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Да',
    this.cancelText = 'Изменить',
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Dialog(
      backgroundColor: ChatifyColors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400, height: 1.3),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm?.call();
                },
                child: Text(confirmText, style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(cancelText, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
