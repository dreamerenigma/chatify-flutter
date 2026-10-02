import 'package:chatify/features/personalization/screens/settings/qr_code_link_phone_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class LinkGuardianPhoneScreen extends StatelessWidget {
  final UserModel user;
  final DateTime birthday;

  const LinkGuardianPhoneScreen({
    super.key,
    required this.user,
    required this.birthday,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      SvgPicture.asset(ChatifyVectors.parentalControls, width: 80, height: 80),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Свяжите с телефоном родителя или опекуна',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400,  height: 1.3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Аккаунтами пользователей младше 13 лет должны управлять родители. ',
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
                              ),
                              TextSpan(
                                text: 'Подробнее',
                                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildParentControlsOption(
                        context,
                        icon: SvgPicture.asset(ChatifyVectors.familyShield, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                        title: 'Вы будете помогать управлять настройками ребёнка.',
                      ),
                      _buildParentControlsOption(
                        context,
                        icon: Icon(Icons.notifications_none_rounded, size: 23, color: ChatifyColors.darkGrey),
                        title: 'Мы будем уведомлять вас о некоторых действиях, например когда ваш ребёнок добавит новый контакт.',
                      ),
                      const SizedBox(height: 10),
                      _buildParentControlsOption(
                        context,
                        icon: Icon(Icons.info_outline_rounded, size: 23, color: ChatifyColors.darkGrey),
                        title: 'Некоторые функции, например каналы и статус, станут недоступны для вашего ребёнка.',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Неправильно указали возраст? ',
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
                              ),
                              TextSpan(
                                text: 'Подтвердить возраст',
                                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomBottomButton(text: 'Далее', onTap: () => Navigator.push(context, createPageRoute(QrCodeLinkPhoneScreen(user: user)))),
          ],
        ),
      ),
    );
  }

  Widget _buildParentControlsOption(BuildContext context, {required Widget icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 32, child: Center(child: icon)),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4))),
        ],
      ),
    );
  }
}
