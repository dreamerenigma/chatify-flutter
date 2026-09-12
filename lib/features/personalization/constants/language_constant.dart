import 'package:flutter/material.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_vectors.dart';
import '../widgets/dialogs/items/language_item.dart';

List<LanguageItem> getLanguages(BuildContext context) => [
  LanguageItem(code: 'af', name: S.of(context).africanLanguage, nativeName: 'Afrikaans', flag: ChatifyVectors.zaf),
  LanguageItem(code: 'ar', name: S.of(context).arabianLanguage, nativeName: 'العربية', flag: ChatifyVectors.sau),
  LanguageItem(code: 'bg', name: S.of(context).bulgarianLanguage, nativeName: 'Български', flag: ChatifyVectors.bgr, ),
  LanguageItem(code: 'bn', name: S.of(context).bengalianLanguage, nativeName: 'বাংলা', flag: ChatifyVectors.bgd),
  LanguageItem(code: 'ca', name: S.of(context).catalianLanguage, nativeName: 'Català', flag: ChatifyVectors.cat),
  LanguageItem(code: 'cs', name: S.of(context).czechLanguage, nativeName: 'Čeština', flag: ChatifyVectors.cze),
  LanguageItem(code: 'da', name: S.of(context).danianLanguage, nativeName: 'Dansk', flag: ChatifyVectors.dnk),
  LanguageItem(code: 'el', name: S.of(context).greekLanguage, nativeName: 'Ελληνικά', flag: ChatifyVectors.grc),
  LanguageItem(code: 'ru', name: S.of(context).russianLanguage, nativeName: '(язык устройства)', flag: ChatifyVectors.rus),
  LanguageItem(code: 'en', name: S.of(context).englishLanguage, nativeName: 'English', flag: ChatifyVectors.usa),
  LanguageItem(code: 'es', name: S.of(context).spanishLanguage, nativeName: 'Español', flag: ChatifyVectors.esp),
  LanguageItem(code: 'de', name: S.of(context).deutschLanguage, nativeName: 'Deutsch', flag: ChatifyVectors.deu),
  LanguageItem(code: 'fr', name: S.of(context).frenchLanguage, nativeName: 'Français', flag: ChatifyVectors.fra),
  LanguageItem(code: 'it', name: S.of(context).italianLanguage, nativeName: 'Italiano', flag: ChatifyVectors.ita),
  LanguageItem(code: 'pt', name: S.of(context).portugueseLanguage, nativeName: 'Português', flag: ChatifyVectors.prt),
];
