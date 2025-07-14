import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../personalization/controllers/language_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

void showSelectedLanguageDialog(BuildContext context) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final Offset buttonPosition = button.localToGlobal(Offset.zero);
  final double menuPositionY = buttonPosition.dy;
  final overlay = Overlay.of(context);
  late OverlayEntry languageMenuOverlayEntry;
  final ScrollController scrollController = ScrollController();
  final selectedLanguage = LanguageController.instance.selectedLanguage;
  final isDefaultSelected = LanguageController.instance.isUsingDefault;

  Map<String, Map<String, String>> languages = {
    "Африкаанс": {"name": "Afrikaans", "code": "af"},
    "Арабский": {"name": "العربية", "code": "ar"},
    "Болгарский": {"name": "Български", "code": "bg"},
    "Бенгальский": {"name": "বাংলা", "code": "bn"},
    "Каталанский": {"name": "Català", "code": "ca"},
    "Чешский": {"name": "Český", "code": "cs"},
    "Датский": {"name": "Dansk", "code": "da"},
    "Греческий": {"name": "Ελληνική", "code": "el"},
    "Русский": {"name": "Русский", "code": "ru"},
    "Английский": {"name": "English", "code": "en"},
    "Испанский": {"name": "Español", "code": "es"},
    "Немецкий": {"name": "Deutsch", "code": "de"},
    "Французский": {"name": "Français", "code": "fr"},
    "Итальянский": {"name": "Italiano", "code": "it"},
    "Португальский": {"name": "Português", "code": "pt"},
  };

  languageMenuOverlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                languageMenuOverlayEntry.remove();
              },
              child: Container(color: ChatifyColors.transparent),
            ),
          ),
          Positioned(
            left: buttonPosition.dx + 10,
            top: menuPositionY,
            child: Material(
              color: ChatifyColors.transparent,
              child: SizedBox(
                width: 250,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2, top: 5, bottom: 5),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
                      ),
                      child: Scrollbar(
                        controller: scrollController,
                        thickness: 2,
                        thumbVisibility: true,
                        radius: Radius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8 * 50.0,
                              child: ScrollConfiguration(
                                behavior: NoGlowScrollBehavior(),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        child: Material(
                                          color: ChatifyColors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              LanguageController.instance.resetToDefaultLanguage();
                                              languageMenuOverlayEntry.remove();
                                            },
                                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                            borderRadius: BorderRadius.circular(8),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: isDefaultSelected ? context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey : ChatifyColors.transparent,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(S.of(context).byDefault),
                                                    ],
                                                  ),
                                                ),
                                                if (isDefaultSelected)
                                                Positioned(
                                                  left: 0,
                                                  top: 8,
                                                  bottom: 8,
                                                  child: Container(
                                                    width: 2.5,
                                                    decoration: BoxDecoration(
                                                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(height: 11, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                                      ...languages.entries.map((entry) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: Material(
                                            color: ChatifyColors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                String languageCode = entry.value["code"]!;
                                                LanguageController.instance.setLanguage(languageCode);
                                                languageMenuOverlayEntry.remove();
                                                Get.updateLocale(Locale(languageCode));
                                              },
                                              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                              borderRadius: BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: selectedLanguage.value == entry.value["code"] ? context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey : ChatifyColors.transparent,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(entry.key),
                                                        if (selectedLanguage.value != entry.value["code"])
                                                          Text(entry.value["name"]!, style: TextStyle(fontWeight: FontWeight.w300)),
                                                      ],
                                                    ),
                                                  ),
                                                  if (selectedLanguage.value == entry.value["code"])
                                                  Positioned(
                                                    left: 0,
                                                    top: 8,
                                                    bottom: 8,
                                                    child: Container(
                                                      width: 2.5,
                                                      decoration: BoxDecoration(
                                                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(languageMenuOverlayEntry);
}
