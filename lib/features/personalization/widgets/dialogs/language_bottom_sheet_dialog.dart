import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../controllers/language_controller.dart';
import 'custom_radio_list_tile.dart';

void showLanguageBottomSheetDialog(BuildContext context, LanguagesController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: false,
    backgroundColor: ChatifyColors.transparent,
    barrierColor: ChatifyColors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.96),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Text(S.of(context).applicationLanguage, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, size: 24),
                    splashRadius: 20,
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
                  SizedBox(width: 4),
                ],
              ),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, bottom: 6, color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.buttonDisabled),
              Expanded(
                child: Obx(() =>
                  RadioGroup<String>(
                    groupValue: controller.selectedLanguage.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.setLanguage(value);
                        Get.back();
                      }
                    },
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...controller.getOrderedLanguages(context).map((language) =>
                            CustomRadioListTile(
                              radioScale: 1.15,
                              padding: EdgeInsets.only(left: 20, right: 4, top: 8, bottom: 8),
                              title: Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(borderRadius: BorderRadius.circular(4), child: SvgPicture.asset(language.flag, width: 25, height: 25, fit: BoxFit.cover)),
                                        const SizedBox(width: 20),
                                        Text(language.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 45),
                                      child: Text(controller.getLanguageLabelByCode(language.nativeName, context), style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                              value: language.code,
                              iconColor: ChatifyColors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
