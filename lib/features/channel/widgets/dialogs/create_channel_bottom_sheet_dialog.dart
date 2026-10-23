import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/custom_scale_button_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_scale_button.dart';
import '../../screens/create_channel_screen.dart';
import '../channel_preferences.dart';

Future<void> showCreateChannelBottomSheet(BuildContext context, UserModel user) async {
  final hasSeenIntro = await ChannelPreferences.hasSeenIntro();

  if (!context.mounted) return;

  if (hasSeenIntro) {
    Navigator.push(context, createPageRoute(CreateChannelScreen(user: user)));
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: false,
    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.95),
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(left: 25, right: 25, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: StatefulBuilder(
            builder: (sheetContext, setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            SvgPicture.asset(ChatifyVectors.createChannel, width: 110, height: 110),
                            const SizedBox(height: 25),
                            Text('Создайте канал с неограниченным количеством подписчиков', textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                            const SizedBox(height: 30),
                            _buildChannelInfoItem(
                              context: sheetContext,
                              icon: Icons.public_outlined,
                              title: 'Любой пользователь может найти ваш канал',
                              description:
                              'Каналы находятся в общем доступе, поэтому любой пользователь может их найти и просмотреть историю действий за последние 30 дней.',
                            ),
                            const SizedBox(height: 18),
                            _buildChannelInfoItem(
                              context: sheetContext,
                              svgAsset: ChatifyVectors.eyeOff,
                              title: 'Люди видят ваш канал, а не вас',
                              description:
                              'Подписчики не видят ваши номера телефона, картинку профиля и имя, но эта информация видна другим админам.',
                            ),
                            const SizedBox(height: 18),
                            _buildChannelInfoItem(
                              context: sheetContext,
                              icon: Icons.shield_outlined,
                              title: 'Вы несёте ответственность за свой канал',
                              description: '',
                              richDescription: TextSpan(
                                text: 'Ваш канал должен отвечать нашим',
                                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, height: 1.4),
                                children: [
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Text(' правилам ', style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: 15, decoration: TextDecoration.none)),
                                    ),
                                  ),
                                  const TextSpan(text: 'и будет проверяться на соответствие им.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomScaleButton(
                        onPressed: () async {
                          await ChannelPreferences.markIntroAsShown();

                          if (!sheetContext.mounted) return;

                          Navigator.pop(sheetContext);
                          Navigator.push(context, createPageRoute(CreateChannelScreen(user: user)));
                        },
                        type: CustomScaleButtonType.filled,
                        label: Text(S.of(context).next, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      );
    }
  );
}

Widget _buildChannelInfoItem({
  required BuildContext context,
  IconData? icon,
  String? svgAsset,
  required String title,
  required String description,
  InlineSpan? richDescription,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 25,
        height: 25,
        child: Center(
          child: icon != null
            ? Icon(icon, size: 25, color: ChatifyColors.darkGrey,)
            : SvgPicture.asset(svgAsset!, width: 25, height: 25, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn),
          ),
        ),
      ),
      const SizedBox(width: 25),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1.5)),
            const SizedBox(height: 4),
            if (richDescription != null)
              Text.rich(richDescription)
            else
              Text(description, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.5)),
          ],
        ),
      ),
    ],
  );
}
