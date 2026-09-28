import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/items/profile_settings_item.dart';

void showSecuritySupportBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
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
              padding: const EdgeInsets.only(top: 20, bottom: 15),
              child: Center(child: SvgPicture.asset(ChatifyVectors.securitySupport, width: 90, height: 90)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Center(child: Text('Обратитесь за помощью в Службу поддержки Chatify', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
            ),
            ProfileSettingsItem(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              icon: SvgPicture.asset(ChatifyVectors.shieldCheck, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: 'Защитите чаты с Chatify',
            ),
            ProfileSettingsItem(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              icon: SvgPicture.asset(ChatifyVectors.aiOutline, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: 'Ответы могут быть сгенерированы ИИ',
            ),
            ProfileSettingsItem(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              icon: SvgPicture.asset(ChatifyVectors.likeDislike, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
              title: 'Оставьте отзыв, чтобы помочь нам стать лучше',
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 32),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                    children: [
                      TextSpan(
                        text: 'Некоторые ответы сгенерированы ИИ с помощью защищенной технологии от Input Studios. Chatify использует вашу переписку со Службой поддержки Chatify, чтобы давать актуальные ответы на ваши вопросы. Ваши личные сообщения и звонки по прежнему защищены сквозным шифрованием. ',
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),
                      ),
                      TextSpan(
                        text: 'Подробнее',
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    side: BorderSide.none,
                  ),
                  child: Text(S.of(context).ok, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
