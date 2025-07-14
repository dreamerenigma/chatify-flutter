import 'package:chatify/features/personalization/screens/privacy/privacy_blocked_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../account/two_step_verification_screen.dart';

class ProtectionAccountsPrivacyCheckScreen extends StatefulWidget {
  const ProtectionAccountsPrivacyCheckScreen({super.key});

  @override
  State<ProtectionAccountsPrivacyCheckScreen> createState() => ProtectionAccountsPrivacyCheckScreenState();
}

class ProtectionAccountsPrivacyCheckScreenState extends State<ProtectionAccountsPrivacyCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text('Проверка конфиденциальности', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.dragged)) {
                  return ChatifyColors.darkerGrey;
                }
                return ChatifyColors.darkerGrey;
              }
            ),
          ),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          child: Center(
                            child: SvgPicture.asset(
                              ChatifyVectors.user,
                              height: 70,
                              width: 70,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -40,
                          top: 10,
                          child: Center(
                            child: SvgPicture.asset(
                              ChatifyVectors.accountProtection,
                              height: 65,
                              width: 65,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Дополнительная защита для вашего аккаунта', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: Text('Обеспечте дополнительную защиту для вашего аккаунта', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 10),
                    _buildCheckPrivacy(
                      icon: Icons.fingerprint_outlined,
                      text: 'Блокировка приложения',
                      subtitle: 'Используйте отпечаток пальца или функцию распознавания лица дял открытия Chatify на своем устройстве.',
                      onTap: () {
                        Navigator.push(
                          context,
                          createPageRoute(const PrivacyBlockedAppScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildCheckPrivacy(
                      svgIconPath: ChatifyVectors.pinCode,
                      text: 'Двухшаговая проверка',
                      subtitle: 'Создайте PIN для повторной регистрации вашего номера телефона в Chatify.',
                      onTap: () {
                        Navigator.push(
                          context,
                          createPageRoute(const TwoStepVerificationScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckPrivacy({
    IconData? icon,
    String? svgIconPath,
    required String text,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: ChatifyColors.darkGrey, size: 26)
            else if (svgIconPath != null)
              SvgPicture.asset(
                svgIconPath,
                color: ChatifyColors.darkGrey,
                width: 26,
                height: 26,
              )
            else
              const SizedBox(width: 26, height: 26),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal, height: 1.3)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, height: 1.3, color: ChatifyColors.darkGrey)),
                ],
              ),
            ),
            const SizedBox(width: 35),
            const Icon(Icons.arrow_forward_rounded, color: ChatifyColors.darkGrey, size: 24),
          ],
        ),
      ),
    );
  }
}
