import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showProtectedEncryptionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 16),
                  const SizedBox(width: 8),
                  Text('Защищено сквозным шифрованием', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.softGrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text('Демонстрировать экран', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        const Spacer(),
                        const Icon(Icons.mobile_screen_share_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text('Отправить сообщение', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        const Spacer(),
                        const Icon(Icons.message_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.signal_cellular_alt_rounded, color: ChatifyColors.green),
                const SizedBox(width: 8),
                Text('Хорошее подключение', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey)),
              ],
            ),
          ],
        ),
      );
    },
  );
}
