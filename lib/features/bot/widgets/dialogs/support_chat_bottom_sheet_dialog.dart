import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';

void showSupportChatBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 14),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 25),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Text('Это безопасный официальный чат Chatify. В нём мы делимся полезными советами, объявлениями и информацией о новых функциях.', textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5)),
                  const SizedBox(height: 20),
                  Text('Мы никогда не запрашиваем личную информацию.', textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5)),
                  const SizedBox(height: 20),
                  CustomBottomButton(
                    text: 'Подробнее',
                    onTap: () async {
                      final uri = Uri.parse('https://faq.chatify.ru/chat-official/?locale=ru_RU');

                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  );
}
