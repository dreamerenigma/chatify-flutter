import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
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
import '../../widgets/dialogs/light_dialog.dart';
import 'birthday_user_screen.dart';

class ParentalControlsScreen extends StatelessWidget {
  final UserModel user;

  const ParentalControlsScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
                        'Настройка родительского контроля для аккаунта ${user.name}',
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
                              text: 'Выберите подходящие настройки для вашего ребенка, установив связь с его аккаунтом. ',
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
                      icon: SvgPicture.asset(ChatifyVectors.smartphone, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                      title: 'Убедитесь, что вы настраиваете элементы управления на телефоне пользователя ${user.name}, но не убирайте свой телефон далеко.',
                    ),
                    _buildParentControlsOption(
                      context,
                      icon: Icon(Icons.qr_code, size: 23, color: ChatifyColors.darkGrey),
                      title: 'Отсканируйте QR-код или примите приглашение на телефоне, чтобы подключиться к аккаунту ${user.name}.',
                    ),
                    const SizedBox(height: 10),
                    _buildParentControlsOption(
                      context,
                      icon: SvgPicture.asset(ChatifyVectors.familyShield, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                      title: 'Завершите настройку родительского контроля на телефоне пользователя ${user.name}.',
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomBottomButton(text: 'Продолжить', onTap: () => Navigator.push(context, createPageRoute(BirthdayUserScreen(user: user)))),
        ],
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
