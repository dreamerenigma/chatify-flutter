import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../privacy/automatic_timer_screen.dart';
import 'enable_timer_chat_screen.dart';

class DisappearingMessagesScreen extends StatelessWidget {
  const DisappearingMessagesScreen({super.key});

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
            title: Text('Исчезающие сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildHeader(context),
              const SizedBox(height: 30),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
              const SizedBox(height: 20),
              _buildMessageOption(
                context,
                title: 'Установлено для вашего аккаунта',
                icon: Icons.person_outline_rounded,
                itemTitle: 'Таймер',
                itemDescription: 'В новых чатах автоматический таймер исчезающих сообщений будет включен по умолчанию',
                onTap: () {
                  Navigator.push(context, createPageRoute(AutomaticTimerScreen()));
                },
              ),
              const SizedBox(height: 15),
              _buildMessageOption(
                context,
                title: 'Установлено для ваших текущих чатов',
                icon: Icons.list_alt_rounded,
                itemTitle: 'Включить таймер  чатах',
                itemDescription: 'Новые сообщения будут исчезать в выбранных вами чатах',
                onTap: () {
                  Navigator.push(context, createPageRoute(EnableTimerChatScreen()));
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SvgPicture.asset(ChatifyVectors.disappearingMessage, width: 80, height: 80),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Настройте автоматическое исчезновение сообщений. Участники чата увидят, что вы включили эту функцию. ',
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3),
                ),
                TextSpan(text: 'Подробнее', style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String itemTitle,
    required String itemDescription,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
        ),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 30, top: 14, bottom: 14),
              child: Row(
                children: [
                  Container(width: 44, height: 44, alignment: Alignment.center, child: Icon(icon, size: 24, color: ChatifyColors.green)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itemTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 3),
                        Text(
                          itemDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
