import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/closed_chats_cleared_opened_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class ClosingChatScreen extends StatefulWidget {
  const ClosingChatScreen({super.key});

  @override
  State<ClosingChatScreen> createState() => ClosingChatScreenState();
}

class ClosingChatScreenState extends State<ClosingChatScreen> {
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
            title: Text('Закрытие чата', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
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
              },
            ),
          ),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          ChatifyVectors.message,
                          height: 100,
                          width: 100,
                        ),
                        Positioned(
                          top: 22,
                          right: -45,
                          child: SvgPicture.asset(
                            ChatifyVectors.lock,
                            height: 65,
                            width: 65,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Center(
                      child: Text(
                        'Закрытые чаты не отображаются в общем списке',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: RichText(
                      text: TextSpan(
                        text: 'Если у вас есть закрытые чаты, потяните список чатов вниз или введите свой секретный код в строке поиска, чтобы найти их. ',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                        children: [
                          TextSpan(
                            text: 'Подробнее',
                            style: TextStyle(
                              fontSize: ChatifySizes.fontSizeSm,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                  InkWell(
                    onTap: () {
                      showClosedChatsClearedOpenDialog(context);
                    },
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Открыть и очистить все закрытые чаты',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            'Если вы забыли свой секретный код, его можно сбросить. При этом сообщения, фото и видео в закрытых чатах будут удалены, а сами чаты будут открыты.',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey, height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
