import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/app_bars/newsletter_app_bar.dart';
import '../widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';

class NewsletterChatScreen extends StatefulWidget {
  final List<String> newsletters;
  final String createdAt;

  const NewsletterChatScreen({
    super.key,
    required this.newsletters,
    required this.createdAt,
  });

  @override
  State<NewsletterChatScreen> createState() => _NewsletterChatScreenState();
}

class _NewsletterChatScreenState extends State<NewsletterChatScreen> {

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

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(automaticallyImplyLeading: false, flexibleSpace: NewsletterAppbar(newsletters: widget.newsletters)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  formattedDate.isNotEmpty ? formattedDate : S.of(context).invalidDate,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 22),
                  InkWell(
                    onTap: () {
                      showChatsCallsPrivacyBottomSheet(
                        context,
                        headerText: S.of(context).chatsCallsConfidential,
                        titleText: S.of(context).yourPrivateMessagesAndCalls,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 40, right: 40, top: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const WidgetSpan(child: Icon(Icons.lock_outline, color: ChatifyColors.yellow, size: 16), alignment: PlaceholderAlignment.middle),
                              TextSpan(
                                text: S.of(context).messagesCallsProtectedEncryption,
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeSm,
                                  fontWeight: FontWeight.w400,
                                  color: ChatifyColors.yellow,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        '${S.of(context).youCreatedMailingList} ${widget.newsletters.length} ${S.of(context).recipients}',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.bold, color: ChatifyColors.darkGrey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
