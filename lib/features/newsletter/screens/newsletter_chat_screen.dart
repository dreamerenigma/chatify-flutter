import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/message_model.dart';
import '../../chat/widgets/input/chat_input.dart';
import '../widgets/bars/app_bars/newsletter_chat_app_bar.dart';
import '../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../utils/widgets/cards/info_card.dart';
import '../models/newsletter_model.dart';

class NewsletterChatScreen extends StatefulWidget {
  final NewsletterModel newsletter;
  final List<String> newsletters;
  final String createdAt;

  const NewsletterChatScreen({
    super.key,
    required this.newsletter,
    required this.newsletters,
    required this.createdAt,
  });

  @override
  State<NewsletterChatScreen> createState() => _NewsletterChatScreenState();
}

class _NewsletterChatScreenState extends State<NewsletterChatScreen> {
  final FocusNode inputFocusNode = FocusNode();
  bool showEmoji = false;
  MessageModel? replyMessage;

  String get formattedDate {
    if (widget.createdAt.isEmpty) {
      return S.of(context).dateNotSpecified;
    }
    try {
      final timestamp = int.tryParse(widget.createdAt);

      if (timestamp == null) {
        return S.of(context).invalidDate;
      }

      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formatted = DateFormat('dd.MM.yyyy').format(date);

      return formatted;
    } catch (e) {
      return S.of(context).invalidDate;
    }
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
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: NewsletterChatAppbar(newsletters: widget.newsletters),
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          ),
        ),
      ),
      body: Stack(
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                ),
                child: Text(
                  formattedDate.isNotEmpty ? formattedDate : S.of(context).invalidDate,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                ),
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    InfoCard(
                      icon: Icons.lock_outline,
                      text: S.of(context).messagesCallsProtectedEncryption,
                      onTap: () {
                        showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
                      },
                    ),
                    const SizedBox(height: 14),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                      ),
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          splashFactory: NoSplash.splashFactory,
                          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          onTap: () {},
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                '${S.of(context).youCreatedMailingList} ''${widget.newsletters.length} ''${S.of(context).recipients}',
                                style: const TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : MediaQuery.of(context).viewPadding.bottom),
              child: ChatInput(
                focusNode: inputFocusNode,
                onToggleEmojiKeyboard: toggleEmojiKeyboard,
                isReplyVisible: replyMessage != null,
                user: APIs.me,
                chatTarget: widget.newsletter,
                onSendMessage: (text) async {
                  await widget.newsletter.sendText(text);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
