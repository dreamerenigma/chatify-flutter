import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';

Future<bool> showResetFeedbackDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Сбросить отзыв?',
          style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
        ),
        content: Text(
          'Введённый текст и добавленные изображения будут удалены.',
          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Отмена',
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey
                  : ChatifyColors.darkerGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Сбросить',style: TextStyle(color: ChatifyColors.red, fontWeight: FontWeight.w500,)),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
