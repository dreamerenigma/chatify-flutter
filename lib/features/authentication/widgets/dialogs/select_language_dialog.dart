import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/controllers/language_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../buttons/custom_radio_button.dart';

void showLanguageDialog(BuildContext context) {
  final LanguageController languageController = Get.find<LanguageController>();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, String>> languages = [
    {'code': 'af', 'image': ChatifyVectors.zaf, 'title': S.of(context).africanLanguage},
    {'code': 'ar', 'image': ChatifyVectors.sau, 'title': S.of(context).arabianLanguage},
    {'code': 'bg', 'image': ChatifyVectors.bgr, 'title': S.of(context).bulgarianLanguage},
    {'code': 'bn', 'image': ChatifyVectors.bgd, 'title': S.of(context).bengalianLanguage},
    {'code': 'ca', 'image': ChatifyVectors.cat, 'title': S.of(context).catalianLanguage},
    {'code': 'cs', 'image': ChatifyVectors.cze, 'title': S.of(context).czechLanguage},
    {'code': 'da', 'image': ChatifyVectors.dnk, 'title': S.of(context).danianLanguage},
    {'code': 'el', 'image': ChatifyVectors.grc, 'title': S.of(context).greekLanguage},
    {'code': 'ru', 'image': ChatifyVectors.rus, 'title': S.of(context).russianLanguage},
    {'code': 'en', 'image': ChatifyVectors.usa, 'title': S.of(context).englishLanguage},
    {'code': 'es', 'image': ChatifyVectors.esp, 'title': S.of(context).spanishLanguage},
    {'code': 'de', 'image': ChatifyVectors.deu, 'title': S.of(context).deutschLanguage},
    {'code': 'fr', 'image': ChatifyVectors.fra, 'title': S.of(context).frenchLanguage},
    {'code': 'it', 'image': ChatifyVectors.ita, 'title': S.of(context).italianLanguage},
    {'code': 'pt', 'image': ChatifyVectors.prt, 'title': S.of(context).portugueseLanguage},
  ];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        titlePadding: EdgeInsets.only(left: 25, right: 20, top: 16),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).applicationLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InkWell(
              onTap: () => Navigator.pop(context),
              mouseCursor: SystemMouseCursors.basic,
              borderRadius: BorderRadius.circular(6),
              splashColor: ChatifyColors.transparent,
              highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.close, size: 24, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black),
              )),
          ],
        ),
        content: Obx(() => SizedBox(
          width: DeviceUtils.getScreenWidth(context) < 600 ? DeviceUtils.getScreenWidth(context) * 0.5 : DeviceUtils.getScreenWidth(context) < 900 ? DeviceUtils.getScreenWidth(context) * 0.40 : DeviceUtils.getScreenWidth(context) * 0.25,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey),
                ),
                child: Scrollbar(
                  controller: scrollController,
                  thickness: 2,
                  thumbVisibility: true,
                  radius: Radius.circular(12),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: languages.map((lang) {
                          return InkWell(
                            onTap: () {
                              languageController.setLanguage(lang['code']!);
                              Navigator.pop(context);
                            },
                            mouseCursor: SystemMouseCursors.basic,
                            splashFactory: NoSplash.splashFactory,
                            splashColor: ChatifyColors.transparent,
                            highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                            hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
                            child: CustomRadioButton(
                              title: lang['title']!,
                              imagePath: lang['image']!,
                              value: lang['code']!,
                              groupValue: languageController.selectedLanguage.value,
                              onChanged: (value) {
                                if (value != null) {
                                  languageController.setLanguage(value);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ).copyWith(
              mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
          ),
        ],
      );
    },
  );
}
