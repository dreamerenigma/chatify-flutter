import 'package:chatify/features/bot/widgets/bars/support_app_bar.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import '../../../api/apis.dart';
import '../../../core/services/bot/support_bot_service.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helper/date_util.dart';
import '../models/info_app_model.dart';
import '../models/support_model.dart';
import '../widgets/inputs/bot_chat_input.dart';
import '../widgets/lists/support_chat_message_list.dart';

class SupportChatScreen extends StatefulWidget {
  final SupportAppModel? support;
  final InfoAppModel? infoApp;

  const SupportChatScreen({
    super.key,
    this.support,
    this.infoApp,
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final FocusNode inputFocusNode = FocusNode();
  bool showEmoji = false;

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
  }

  void toggleEmojiKeyboard() {
    setState(() {
      showEmoji = !showEmoji;

      if (showEmoji) {
        inputFocusNode.unfocus();
      } else {
        inputFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final support = widget.support;

    if (support == null) {
      return const Scaffold(body: Center(child: Text('Чат поддержки недоступен')));
    }

    return Scaffold(
      appBar: SupportAppBar(support: support, infoApp: widget.infoApp),
      body: _buildBodySection(context, support),
    );
  }

  Widget _buildBodySection(BuildContext context, SupportAppModel support) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Stack(
        children: [
          Consumer<WallpaperProvider>(
            builder: (context, wallpaperProvider, child) {
              final backgroundImage = wallpaperProvider.backgroundImage.isNotEmpty ? wallpaperProvider.backgroundImage : (context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight);

              return Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)));
            },
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: ChatifyColors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                  ),
                  child: Text(
                    DateUtil.formatDateTime(support.createdAt),
                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(color: ChatifyColors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashFactory: NoSplash.splashFactory,
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                    ),
                    child: Text(
                      DateUtil.formatDateTime(widget.support!.createdAt),
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Expanded(child: SupportChatMessageList(support: support)),
                Padding(
                  padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : MediaQuery.of(context).viewPadding.bottom),
                  child: BotChatInput(
                    focusNode: inputFocusNode,
                    onToggleEmojiKeyboard: toggleEmojiKeyboard,
                    onSendMessage: (text) async {
                      await APIs.sendSupportUserMessage(supportChatId: support.id, message: text);
                      await SupportBotService.processMessage(supportChatId: support.id, userMessage: text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
