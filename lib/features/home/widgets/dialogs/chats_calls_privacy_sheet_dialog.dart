import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showChatsCallsPrivacyBottomSheet(BuildContext context, {required String headerText, required String titleText}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: SvgPicture.asset(colorsController.getImagePath(), width: 100, height: 100),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Center(
                child: Text(
                  headerText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeBg),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
              child: Center(
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildIconTextRow(
              icon: Icons.message_outlined,
              text: 'Текстовые и голосовые сообщения',
            ),
            _buildIconTextRow(
              icon: Icons.call_outlined,
              text: 'Аудио- и видеозвонки',
            ),
            _buildIconTextRow(
              icon: Icons.attach_file,
              text: 'Фото, видео и документы',
            ),
            _buildIconTextRow(
              icon: Icons.location_on_outlined,
              text: 'Ваше местоположение',
            ),
            _buildIconTextRow(
              icon: Icons.update,
              text: 'Обновление статуса',
              isSvg: true,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://chatify.inputstudios.ru/security');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Не удалось открыть $url';
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    side: BorderSide.none,
                  ),
                  child: Text('Подробнее', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildIconTextRow({required IconData icon, required String text, bool isSvg = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isSvg
          ? SvgPicture.asset(ChatifyVectors.status, width: 24, height: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value))
          : Icon(icon, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ChatifySizes.fontSizeMd,
              fontWeight: FontWeight.w500,
              color: ChatifyColors.darkGrey,
            ),
          ),
        ),
      ],
    ),
  );
}
