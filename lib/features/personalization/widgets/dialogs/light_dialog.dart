import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../controllers/colors_controller.dart';

int selectedRadioButton = 2;
final colorsController = Get.find<ColorsController>();

void showLightDialog(BuildContext context) {
  final radioOptions = [
    {'value': 1, 'title': 'Нет'},
    {'value': 2, 'title': 'Белый'},
    {'value': 3, 'title': 'Красный'},
    {'value': 4, 'title': 'Жёлтый'},
    {'value': 5, 'title': 'Зелёный'},
    {'value': 6, 'title': 'Голубой'},
    {'value': 7, 'title': 'Синий'},
    {'value': 8, 'title': 'Фиолетовый'},
  ];

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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Свет', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: radioOptions.map((option) {
                      return RadioListTile<int>(
                        value: option['value'] as int,
                        groupValue: selectedRadioButton,
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        onChanged: (value) {
                          setState(() {
                            selectedRadioButton = value!;
                          });
                        },
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        title: Text(option['title'] as String),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value,).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                          ),
                          child: Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            log('Selected Option: $selectedRadioButton');
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value,).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text('ОК', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
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
