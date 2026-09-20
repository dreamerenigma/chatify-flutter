import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../api/apis.dart';
import '../../../api/chat_api.dart';
import '../../../core/enums/message_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/message_model.dart';
import '../../chat/models/user_model.dart';
import '../../chat/widgets/input/chat_input.dart';
import '../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../widgets/bars/community_app_bar.dart';
import '../widgets/buttons/add_member_button.dart';

class CommunityScreen extends StatefulWidget {
  final UserModel user;

  const CommunityScreen({
    super.key,
    required this.user,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FocusNode inputFocusNode = FocusNode();
  final community = APIs.community;
  late final TapGestureRecognizer _moreRecognizer;
  bool _isEventsInfoVisible = true;
  bool showEmoji = false;
  String? _communityImageUrl;
  MessageModel? replyMessage;
  List<MessageModel> list = [];

  String get formattedDate {
    final currentCommunity = community;

    if (currentCommunity == null) {
      return S.of(context).dateNotSpecified;
    }

    try {
      return DateFormat('dd.MM.yyyy').format(currentCommunity.createdAt);
    } catch (_) {
      return S.of(context).invalidDate;
    }
  }

  @override
  void initState() {
    super.initState();
    _moreRecognizer = TapGestureRecognizer()..onTap = () {};
    _loadCommunityImage();
  }

  @override
  void dispose() {
    _moreRecognizer.dispose();
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


  Future<void> _loadCommunityImage() async {
    final currentCommunity = community;

    if (currentCommunity == null || currentCommunity.image.trim().isEmpty) {
      return;
    }

    try {
      final imageUrl = await APIs.mediaService.getUrl(currentCommunity.image);

      if (!mounted) return;

      setState(() {
        _communityImageUrl = imageUrl;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки изображения сообщества: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final currentCommunity = community;

    if (currentCommunity == null) {
      return const Scaffold(body: Center(child: Text('Сообщество не найдено')));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + (_isEventsInfoVisible ? 66 : 0)),
        child: CommunityAppBar(
          community: currentCommunity,
          user: widget.user,
          isEventsInfoVisible: _isEventsInfoVisible,
          onCloseEventsInfo: () {
            setState(() {
              _isEventsInfoVisible = false;
            });
          },
        ),
      ),
      body: ScrollConfiguration(
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
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
                    const SizedBox(height: 40),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                        onTap: () {
                          showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 30, right: 30, top: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(color: ChatifyColors.yellow, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5),
                                children: [
                                  const WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.lock_outline, color: ChatifyColors.yellow, size: 13)), alignment: PlaceholderAlignment.middle),
                                  TextSpan(text: 'Сообщения и звонки защищены сквозным шифрованием. ''Прочитать, прослушать или переслать их могут только ''участники этого чата. ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.3)),
                                  TextSpan(text: 'Подробнее', style: TextStyle(color: ChatifyColors.yellow, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3), recognizer: _moreRecognizer),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildWelcomeCommunity(),
                  ],
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
                  user: widget.user,
                  onToggleEmojiKeyboard: toggleEmojiKeyboard,
                  isReplyVisible: replyMessage != null,
                  onSendMessage: (text) async {
                    if (list.isEmpty) {
                      APIs.sendFirstMessage(widget.user, text, MessageType.text);
                    } else {
                      ChatApi.sendMessage(widget.user, text, MessageType.text);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCommunity() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 30, right: 30),
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 25),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 68,
              height: 68,
              child: _communityImageUrl != null && _communityImageUrl!.trim().isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: _communityImageUrl!,
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        width: 68,
                        height: 68,
                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                        alignment: Alignment.center,
                        child: Icon(Icons.groups, size: 40, color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.white),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        width: 68,
                        height: 68,
                        color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.iconGrey,
                        alignment: Alignment.center,
                        child: Icon(Icons.groups, size: 40, color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.white),
                      );
                    },
                  )
                : Container(
                    width: 68,
                    height: 68,
                    color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.iconGrey,
                    alignment: Alignment.center,
                    child: Icon(Icons.groups, size: 40, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                  ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Добро пожаловать в наше сообщество!',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, height: 1.4),
          ),
          const SizedBox(height: 14),
          Text(
            'Используйте данный чат для отправки важных объявлений от админов одновременно всем участникам сообщества.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.softGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.25),
          ),
          const SizedBox(height: 25),
          AddMemberButton(),
        ],
      ),
    );
  }
}
