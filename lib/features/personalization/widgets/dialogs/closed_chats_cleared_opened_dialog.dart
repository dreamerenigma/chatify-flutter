import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showClosedChatsClearedOpenDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Закрытые чаты будут очищены и открыты', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 25),
            titlePadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Все сообщения, фото и видео в закрытых чатах будут удалены, а сами чаты станут открытыми в основном списке чатов.',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Также будет сброшен секретный код (при наличии).',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.3),
                ),
              ],
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        foregroundColor: ChatifyColors.red,
                        backgroundColor: ChatifyColors.red.withAlpha((0.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text('Открыть и очистить', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      );
    }
  );
}
