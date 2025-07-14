import 'package:chatify/features/personalization/screens/privacy/privacy_calls_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/privacy_groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'blocked_users_screen.dart';

class SelectContactPrivacyCheckScreen extends StatefulWidget {
  const SelectContactPrivacyCheckScreen({super.key});

  @override
  State<SelectContactPrivacyCheckScreen> createState() => SelectContactPrivacyCheckScreenState();
}

class SelectContactPrivacyCheckScreenState extends State<SelectContactPrivacyCheckScreen> {
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
                        SvgPicture.asset(
                          ChatifyVectors.message,
                          height: 100,
                          width: 100,
                        ),
                        Positioned(
                          right: -35,
                          top: 30,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            child: Center(
                              child: SvgPicture.asset(
                                ChatifyVectors.user,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Выбери те, кто может связаться с вами', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: Text('Управляйте своей конфиденциальностью. Выберите, кто может связаться с вами, заблокировав звонки или сообщения от нежелательных контактов.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 10),
                    _buildCheckPrivacy(icon: Icons.group_add_outlined, text: 'Группы', subtitle: 'Укажите, кто может добавлять вас в группы: все пользователи или только ваши контакты', onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const PrivacyGroupsScreen()),
                      );
                    }),
                    _buildCheckPrivacy(icon: Icons.notifications_off_outlined, text: 'Отключение звука для неизвестных номеров', subtitle: 'Заблокируйте звонки с неизвестных номеров.', onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const PrivacyCallsScreen()),
                      );
                    }),
                    _buildCheckPrivacy(icon: Icons.person_off_outlined, text: 'Заблокированные контакты', subtitle: 'Заблокируйте звонки, сообщения и обновления статуса от отпределённых контактов.', onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(BlockedUsersScreen(blockedUser: const [], user: APIs.me)),
                      );
                    }),
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
    required IconData icon,
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
            Icon(icon, color: ChatifyColors.darkGrey, size: 26),
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
