import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class ChatBackupScreen extends StatefulWidget {
  const ChatBackupScreen({super.key});

  @override
  State<ChatBackupScreen> createState() => ChatBackupScreenState();
}

class ChatBackupScreenState extends State<ChatBackupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).chatsBackup, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              S.of(context).backupSettingsAccountStorage,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Последнее резервное копирование: 24 декабря, 6:45', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Объем: 12 МБ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  textStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(S.of(context).createBackupCopy, style: TextStyle(color: ChatifyColors.black)),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Управление хранилищем Input Studios', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    const SizedBox(height: 4),
                    Text('Использовано: 424 МБ из 50 ГБ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Аккаунт Input Studios', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('jarekismail@gmail.com', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Как часто', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Ежемесячно', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Сохранять видео', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                Switch(
                  value: true,
                  onChanged: (bool value) {},
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Резервное копирование через мобильный интернет', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                Switch(
                  value: false,
                  onChanged: (bool value) {},
                  activeColor: ChatifyColors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
        ],
      ),
    );
  }
}
