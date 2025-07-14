import 'dart:developer';
import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/group/models/group_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../community/widgets/info/encryption_info_block.dart';
import '../../../../home/widgets/dialogs/overlays/contacting_support_overlay.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../light_dialog.dart';

class EncryptionOptionWidget extends StatefulWidget {
  final UserModel? user;
  final GroupModel? group;
  final SupportAppModel? support;

  const EncryptionOptionWidget({super.key, this.user, this.group, this.support});

  @override
  State<EncryptionOptionWidget> createState() => _EncryptionOptionWidgetState();
}

class _EncryptionOptionWidgetState extends State<EncryptionOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  bool isInside = false;
  bool isHovered = false;
  bool isHoveredSecurity = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.group != null || widget.support != null)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            widget.support != null ? 'Безопасность' : 'Шифрование',
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: CustomScrollbar(
            scrollController: _scrollController,
            isInsidePersonalizedOption: isInside,
            onHoverChange: (bool isHovered) {
              setState(() {
                isInside = isHovered;
              });
            },
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (widget.group != null || widget.support != null) _buildEncryptionChat(),
                      if (widget.user != null) _buildEncryptionGroup(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEncryptionChat() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: ChatifySizes.fontSizeLm),
              children: [
                TextSpan(text: 'Вы общаетесь с официальным аккаунтом Службы поддержки Chatify. ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                TextSpan(
                  text: 'Подробнее',
                  style: TextStyle(
                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                    fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, decoration: isHoveredSecurity ? TextDecoration.none : TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    ContactingSupportOverlay(context, showStartChatButton: false).show();
                  },
                  onEnter: (_) => setState(() => isHoveredSecurity = true),
                  onExit: (_) => setState(() => isHoveredSecurity = false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EncryptionInfoBlock(withContainer: false),
        const SizedBox(height: 6),
        MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: RichText(
            text: TextSpan(
              text: 'Подробнее',
              style: TextStyle(
                fontSize: ChatifySizes.fontSizeSm,
                fontWeight: FontWeight.w300,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                decoration: isHovered ? TextDecoration.none : TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = () async {
                final Uri uri = Uri.parse('https://faq.chatify.ru/?locale=ru_RU&eea=0');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  log("Не удалось открыть ссылку");
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
