import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showReportGroupDialog(BuildContext context) {
  final box = GetStorage();
  bool isChecked = box.read('isChecked') ?? false;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(child: Text('Пожаловаться в Chatify на эту группу?', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal), textAlign: TextAlign.center)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Text('Последние 5 сообщений в этой группе будут переслан в Chatify. Если вы выйдете из группы и удалите чат, сообщения будут удалены только с этого устройства и с ваших устройств с более новыми версиями Chatify.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Text('Участники группы не будут об этом оповещены.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                                box.write('isChecked', isChecked);
                              });
                            },
                            activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                        ),
                        Text('Выйти из группы и удалить чат', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(S.of(context).cancel, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () async {},
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text('Пожаловаться', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
