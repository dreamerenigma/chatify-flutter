import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../controllers/language_controller.dart';
import 'custom_radio_list_tile.dart';
import 'items/language_item.dart';

void showLanguageBottomSheetDialog(BuildContext context, LanguagesController controller) {
  final languages = [
    LanguageItem(code: 'ru', name: S.of(context).russianLanguage, flag: ChatifyVectors.rus),
    LanguageItem(code: 'en', name: S.of(context).englishLanguage, flag: ChatifyVectors.usa),
    LanguageItem(code: 'es', name: S.of(context).spanishLanguage, flag: ChatifyVectors.esp),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: false,
    backgroundColor: ChatifyColors.transparent,
    barrierColor: ChatifyColors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.94),
    builder: (_) {
      final height = MediaQuery.of(context).size.height;

      return Container(
        width: double.infinity,
        height: height * 0.95,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.grey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: const EdgeInsets.only(left: 20, right: 16, top: 10, bottom: 10), child: Text(S.of(context).selectLanguage, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w600))),
              ],
            ),
            Obx(() => RadioGroup<String>(
              groupValue: controller.selectedLanguage.value,
              onChanged: (value) {
                if (value != null) {
                  controller.setLanguage(value);
                  Get.back();
                }
              },
              child: Column(
                children: [
                  ...languages.map((language) => CustomRadioListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Row(
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(4), child: SvgPicture.asset(language.flag, width: 25, height: 25, fit: BoxFit.cover)),
                          const SizedBox(width: 16),
                          Text(language.name),
                        ],
                      ),
                    ),
                    value: language.code,
                    iconColor: ChatifyColors.transparent,
                  )),
                ],
              ),
            )),
          ],
        ),
      );
    },
  );
}
