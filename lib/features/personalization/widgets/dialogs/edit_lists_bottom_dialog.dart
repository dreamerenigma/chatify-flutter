import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showEditListsBottomSheet(BuildContext context) {
  List<Map<String, String>> presets = [
    {'title': 'Непрочитанное', 'subtitle': 'Предустановка'},
    {'title': 'Избранное', 'subtitle': ''},
    {'title': 'Группы', 'subtitle': 'Предустановка'},
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 26),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('Изменить списки', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.normal)),
                IconButton(
                  icon: const Icon(Icons.check, size: 26),
                  onPressed: () => {
                    Navigator.pop(context),
                  }
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Вы можете редактировать списки и фильтры здесь, либо, изменять их отображение на вкладке "Чаты".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ваши списки', style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Непрочитанное', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 8),
                          Text(
                            'Предустановка',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(FluentIcons.delete_24_regular, size: 24, color: ChatifyColors.buttonSecondary),
                          SizedBox(width: 16),
                          Icon(AkarIcons.two_line_horizontal, size: 24, color: ChatifyColors.buttonSecondary),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Избранное', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                      const Icon(AkarIcons.two_line_horizontal, size: 24, color: ChatifyColors.buttonSecondary),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Группы', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 8),
                          Text(
                            'Предустановка',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(FluentIcons.delete_24_regular, size: 24, color: ChatifyColors.buttonSecondary),
                          SizedBox(width: 16),
                          Icon(AkarIcons.two_line_horizontal, size: 24, color: ChatifyColors.buttonSecondary),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Доступные предустановки',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Если вы удалите один из преустановленных списков, например "Непрочитанное" или "Группы", он будет доступен здесь.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
