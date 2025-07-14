import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/popups/progress_overlay.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../controllers/dialog_controller.dart';

class ContactingSupportOverlay {
  late OverlayEntry _overlayEntry;
  final bool showStartChatButton;
  final BuildContext context;
  final TextEditingController controller = TextEditingController();

  ContactingSupportOverlay(this.context, {this.showStartChatButton = true});

  void show() {
    final overlay = Overlay.of(context);
    final dialogController = Get.find<DialogController>();
    final ValueNotifier<bool> isHovering = ValueNotifier(false);
    bool hasCreatedSupportChat = false;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        dialogController.openWindowsDialog();

        return Material(
          color: ChatifyColors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: close,
                behavior: HitTestBehavior.opaque,
                child: Container(color: ChatifyColors.black.withAlpha((0.3 * 256).toInt())),
              ),
              Center(
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.buttonDarkGrey : ChatifyColors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Center(child: SvgPicture.asset(ChatifyVectors.contactSupport, width: 60, height: 60)),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text('Обращение за помощью в официальную Службу поддержки Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem(ChatifyVectors.shieldCheck, 'Защитите чаты с Chatify', spacing: 12),
                      _buildInfoItem(ChatifyVectors.questionAi, 'Ответы могут быть сгенерированные ИИ', spacing: 12),
                      _buildInfoItem(ChatifyVectors.review, 'Оставьте отзыв, чтобы помочь нам стать лучше', spacing: 7),
                      const SizedBox(height: 16),
                      Divider(height: 1, thickness: 0, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                ),
                            children: [
                              TextSpan(
                                text: 'Некоторые ответы сгенерированы ИИ с помощью защищённой технологии от Input Studios. Chatify использует вашу переписку со Службой поддержки Chatify, чтобы дать актуальные ответы на ваши вопросы. Ваши личные сообщения и звонки по-прежнему защищены сквозным шифрованием. ',
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeLm,
                                  fontWeight: FontWeight.w300,
                                  height: 1.2,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: isHovering,
                                  builder: (context, hovering, _) {
                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      onEnter: (_) => isHovering.value = true,
                                      onExit: (_) => isHovering.value = false,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Подробнее',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                            decoration: hovering ? TextDecoration.none : TextDecoration.underline,
                                            decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                          border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey, width: 0.5)),
                        ),
                        child: showStartChatButton
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      ProgressOverlay(context).show();
                                      final userId = FirebaseAuth.instance.currentUser?.uid;
                                      if (userId != null && !hasCreatedSupportChat) {
                                        await APIs.createSupportChat(userId);
                                        hasCreatedSupportChat = true;
                                      }

                                      _overlayEntry.remove();
                                      dialogController.closeWindowsDialog();
                                    },
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      foregroundColor: ChatifyColors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 1,
                                      shadowColor: ChatifyColors.black,
                                    ).copyWith(
                                      mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text('Начать чат', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildCancelButton(dialogController),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      final uri = Uri.parse('https://faq.chatify.ru/?cms_platform=web&lang=en');
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        log("Не удалось открыть ссылку");
                                      }

                                      _overlayEntry.remove();
                                      dialogController.closeWindowsDialog();
                                    },
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      foregroundColor: ChatifyColors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 1,
                                      shadowColor: ChatifyColors.black,
                                    ).copyWith(
                                      mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text('Подробнее', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildCancelButton(dialogController),
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry);
  }

  void close() {
    _overlayEntry.remove();
  }

  Widget _buildCancelButton(DialogController dialogController) {
    return TextButton(
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          _overlayEntry.remove();
          dialogController.closeWindowsDialog();
        });
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
        foregroundColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1),
        elevation: 1,
        shadowColor: ChatifyColors.black,
      ).copyWith(
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
      ),
    );
  }
}

Widget _buildInfoItem(String iconPath, String text, {double spacing = 12}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      children: [
        SvgPicture.asset(iconPath),
        SizedBox(width: spacing),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
        ),
      ],
    ),
  );
}
