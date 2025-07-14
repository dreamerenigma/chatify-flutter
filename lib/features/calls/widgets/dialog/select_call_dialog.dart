import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/create_link_call_screen.dart';

void showSelectCallDialog(BuildContext context, String title, String initialCallType, ValueChanged<String> onSelected) {
  final CallTypeController callTypeController = Get.put(CallTypeController());

  callTypeController.updateCallType(initialCallType);

  Get.defaultDialog(
    title: title,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    titleStyle: TextStyle(fontSize: ChatifySizes.fontSizeMg, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Obx(() => RadioListTile<String>(
          title: Text('Видео', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
          value: 'Видео',
          activeColor: ChatifyColors.blue,
          groupValue: callTypeController.selectedCallType.value,
          onChanged: (String? value) {
            if (value != null) {
              callTypeController.updateCallType(value);
              onSelected(value);
              Get.back();
            }
          },
        )),
        Obx(() => RadioListTile<String>(
          title: Text('Аудио', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
          value: 'Аудио',
          activeColor: ChatifyColors.blue,
          groupValue: callTypeController.selectedCallType.value,
          onChanged: (String? value) {
            if (value != null) {
              callTypeController.updateCallType(value);
              onSelected(value);
              Get.back();
            }
          },
        )),
      ],
    ),
  );
}
