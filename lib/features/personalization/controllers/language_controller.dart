import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialogs/light_dialog.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();
  var selectedLanguage = 'ru'.obs;
  final box = GetStorage();
  final String defaultLanguageCode = 'ru';
  bool get isUsingDefault {
    String? savedLanguage = box.read('selectedLanguage');

    if (savedLanguage == null || savedLanguage == defaultLanguageCode) {
      return true;
    }

    return false;
  }

  List<Map<String, dynamic>> getAvailableLanguages(BuildContext context) {
    return [
      {'code': 'af', 'image': ChatifyVectors.zaf, 'label': S.of(context).africanLanguage},
      {'code': 'ar', 'image': ChatifyVectors.sau, 'label': S.of(context).arabianLanguage},
      {'code': 'bg', 'image': ChatifyVectors.bgr, 'label': S.of(context).bulgarianLanguage},
      {'code': 'bn', 'image': ChatifyVectors.bgd, 'label': S.of(context).bengalianLanguage},
      {'code': 'ca', 'image': ChatifyVectors.cat, 'label': S.of(context).catalianLanguage},
      {'code': 'cs', 'image': ChatifyVectors.cze, 'label': S.of(context).czechLanguage},
      {'code': 'da', 'image': ChatifyVectors.dnk, 'label': S.of(context).danianLanguage},
      {'code': 'el', 'image': ChatifyVectors.grc, 'label': S.of(context).greekLanguage},
      {'code': 'ru', 'image': ChatifyVectors.rus, 'label': S.of(context).russianLanguage},
      {'code': 'en', 'image': ChatifyVectors.usa, 'label': S.of(context).englishLanguage},
      {'code': 'es', 'image': ChatifyVectors.esp, 'label': S.of(context).spanishLanguage},
      {'code': 'de', 'image': ChatifyVectors.deu, 'label': S.of(context).deutschLanguage},
      {'code': 'fr', 'image': ChatifyVectors.fra, 'label': S.of(context).frenchLanguage},
      {'code': 'it', 'image': ChatifyVectors.ita, 'label': S.of(context).italianLanguage},
      {'code': 'pt', 'image': ChatifyVectors.prt, 'label': S.of(context).portugueseLanguage},
    ];
  }

  @override
  void onInit() {
    super.onInit();
    String? savedLanguage = box.read('selectedLanguage');
    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
      Get.updateLocale(Locale(savedLanguage));
    } else {
      selectedLanguage.value = defaultLanguageCode;
      Get.updateLocale(Locale(defaultLanguageCode));
    }
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
    box.write('selectedLanguage', language);
    Get.updateLocale(Locale(language));
    selectedLanguage.refresh();
  }

  void resetToDefaultLanguage() {
    box.remove('selectedLanguage');
    selectedLanguage.value = defaultLanguageCode;
    Get.updateLocale(Locale(defaultLanguageCode));
    selectedLanguage.refresh();
  }

  String getLanguageLabel(BuildContext context) {
    if (selectedLanguage.value == defaultLanguageCode) {
      return S.of(context).byDefault;
    }

    switch (selectedLanguage.value) {
      case 'af': return S.of(context).africanLanguage;
      case 'ar': return S.of(context).arabianLanguage;
      case 'bg': return S.of(context).bulgarianLanguage;
      case 'bn': return S.of(context).bengalianLanguage;
      case 'ca': return S.of(context).catalianLanguage;
      case 'cs': return S.of(context).czechLanguage;
      case 'da': return S.of(context).danianLanguage;
      case 'el': return S.of(context).greekLanguage;
      case 'ru': return S.of(context).russianLanguage;
      case 'en': return S.of(context).englishLanguage;
      case 'es': return S.of(context).spanishLanguage;
      case 'de': return S.of(context).deutschLanguage;
      case 'fr': return S.of(context).frenchLanguage;
      case 'it': return S.of(context).italianLanguage;
      case 'pt': return S.of(context).portugueseLanguage;
      default: return selectedLanguage.value;
    }
  }

  String getLanguageLabelByCode(String code, BuildContext context) {
    switch (code) {
      case 'af': return S.of(context).africanLanguage;
      case 'ar': return S.of(context).arabianLanguage;
      case 'bg': return S.of(context).bulgarianLanguage;
      case 'bn': return S.of(context).bengalianLanguage;
      case 'ca': return S.of(context).catalianLanguage;
      case 'cs': return S.of(context).czechLanguage;
      case 'da': return S.of(context).danianLanguage;
      case 'el': return S.of(context).greekLanguage;
      case 'ru': return S.of(context).russianLanguage;
      case 'en': return S.of(context).englishLanguage;
      case 'es': return S.of(context).spanishLanguage;
      case 'de': return S.of(context).deutschLanguage;
      case 'fr': return S.of(context).frenchLanguage;
      case 'it': return S.of(context).italianLanguage;
      case 'pt': return S.of(context).portugueseLanguage;
      default: return code;
    }
  }

  String getSelectedLanguageSubtitle(BuildContext context) {
    return getLanguageLabel(context);
  }

  Future<void> selectLanguage(BuildContext context) async {
    final languages = getAvailableLanguages(context);

    return showModalBottomSheet(
      context: context,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.63,
        minChildSize: 0.3,
        maxChildSize: 0.63,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).applicationLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                          ],
                        ),
                      ),
                      const Divider(),
                      Obx(() => Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 6),
                        child: Column(
                          children: languages.map((lang) {
                            final code = lang['code'];
                            final image = lang['image'];
                            return RadioListTile<String>(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getLanguageLabelByCode(code, context), style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: SvgPicture.asset(image, width: 25, height: 25),
                                  ),
                                ],
                              ),
                              value: code,
                              groupValue: selectedLanguage.value,
                              onChanged: (value) {
                                if (value != null) {
                                  setLanguage(value);
                                  Navigator.of(context).pop();
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            );
                          }).toList(),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
