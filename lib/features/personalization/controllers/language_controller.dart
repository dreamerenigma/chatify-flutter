import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';

class LanguagesController extends GetxController {
  final box = GetStorage();

  var selectedLanguage = 'ru'.obs;

  static LanguagesController get instance => Get.find();
  static const String defaultLanguageCode = 'ru';
  static const List<String> supportedLanguageCodes = ['af', 'ar', 'bg', 'bn', 'ca', 'cs', 'da', 'el', 'ru', 'en', 'es', 'de', 'fr', 'it', 'pt'];

  bool get isUsingDefault {
    String? savedLanguage = box.read('selectedLanguage');

    if (savedLanguage == null || savedLanguage == defaultLanguageCode) {
      return true;
    }

    return false;
  }

  @override
  void onInit() {
    super.onInit();
    final String language = box.read<String>('selectedLanguage') ?? defaultLanguageCode;

    selectedLanguage.value = language;
    Get.updateLocale(Locale(language));
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
    box.write('selectedLanguage', language);
    Get.updateLocale(Locale(language));
  }

  void resetToDefaultLanguage() {
    box.remove('selectedLanguage');
    selectedLanguage.value = defaultLanguageCode;
    Get.updateLocale(Locale(defaultLanguageCode));
  }

  String getLanguageLabel(BuildContext context) {
    if (selectedLanguage.value == defaultLanguageCode) {
      return S.of(context).byDefault;
    }

    return getLanguageLabelByCode(selectedLanguage.value, context);
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
}
