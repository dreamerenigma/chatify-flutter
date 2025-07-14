import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/lists/add_list_screen.dart';

void showEditListsFavoriteBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Редактирование: Избранное',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.normal),
                ),
                IconButton(
                  icon: const Icon(Icons.check, size: 24),
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
                'Используйте карандаш, чтобы изменять порядок списков на вкладке "Чаты".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Включены в список', style: TextStyle(color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal)),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(AddListScreen(user: APIs.me)),
                );
              },
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.darkerGrey,
                      child: Icon(Icons.add_rounded, size: 26, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                    ),
                    const SizedBox(width: 16),
                    Text('Добавить людей или группы', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    const Divider(height: 0, thickness: 1),
                  ],
                ),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
              child: Text(
                'Вы можете отредактировать "Избранное" здесь или изменить порядок отображения "Избранного" на вкладке "Звонки"',
                textAlign: TextAlign.center,
                style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
