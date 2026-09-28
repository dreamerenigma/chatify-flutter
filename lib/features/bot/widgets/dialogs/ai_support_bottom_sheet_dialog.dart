import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/items/profile_settings_item.dart';

void showAISupportBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 14),
                Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: Center(child: Text('Информация о чате Службы поддержки Chatify с использованием ИИ', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
                ),
                ProfileSettingsItem(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  icon: SvgPicture.asset(ChatifyVectors.handHeart, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: 'Получите помощь быстрее',
                  subtitle: 'Служба поддержки Chatify может использовать ИИ, чтобы быстро отвечать на ваши вопросы в круглосуточном режиме.',
                ),
                ProfileSettingsItem(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  icon: SvgPicture.asset(ChatifyVectors.aiOutline, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: 'Определяйте сообщения от ИИ',
                  subtitle: 'Сообщения, сгенерированные ИИ, помечены как сообщения ИИ. Вы можете оставить отзыв о сообщениях, генерируемых ИИ, чтобы помочь Chatify повысить их качество.',
                ),
                ProfileSettingsItem(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  icon: SvgPicture.asset(ChatifyVectors.question, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: 'Подробную информацию можно получить в Справочном центре',
                  subtitle: 'Посетите справочный центр, чтобы найти ответы на свои вопросы и ознакомиться со статьями, которые используются для генерирования сообщений с помощью ИИ.',
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
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
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            foregroundColor: context.isDarkMode ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.black,
                          ),
                          child: Text('Подробнее', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
