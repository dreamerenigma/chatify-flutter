import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../api/apis.dart';
import '../../../api/chat_api.dart';
import '../../../core/enums/message_bubble_type.dart';
import '../../../core/enums/message_type.dart';
import '../../../core/services/media/media_service.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/message_model.dart';
import '../../chat/models/user_model.dart';
import '../../chat/widgets/input/chat_input.dart';
import '../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/cards/info_card.dart';
import '../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/community_model.dart';
import '../widgets/bars/community_group_app_bar.dart';
import '../widgets/buttons/add_member_button.dart';
import 'community_info_screen.dart';

class GeneralChatScreen extends StatefulWidget {
  final CommunityModel community;
  final UserModel user;
  final bool Function(DateTime) isValidDate;

  const GeneralChatScreen({
    super.key,
    required this.community,
    required this.user,
    required this.isValidDate,
  });

  @override
  State<GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen> {
  final FocusNode inputFocusNode = FocusNode();
  bool showEmoji = false;
  String? _communityImageUrl;
  MessageModel? replyMessage;
  UserModel? replyUser;
  List<MessageModel> list = [];

  String get formattedDate {
    final currentCommunity = widget.community;

    try {
      return DateFormat('dd.MM.yyyy').format(currentCommunity.createdAt);
    } catch (_) {
      return S.of(context).invalidDate;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCommunityImage();
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
    final imagePath = widget.community.image;

    if (imagePath.trim().isEmpty) {
      if (!mounted) return;
      setState(() => _communityImageUrl = null);
      return;
    }

    try {
      final url = await Get.find<MediaService>().getUrl(imagePath);

      if (!mounted) return;
      setState(() => _communityImageUrl = url);
    } catch (_) {
      if (!mounted) return;
      setState(() => _communityImageUrl = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final currentCommunity = widget.community;
    final user = APIs.me;
    final isMe = widget.user.id == user.id;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CommunityGroupAppBar(
          community: currentCommunity,
          user: widget.user,
          onOpenCommunity: () {
            Navigator.push(context, createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: widget.isValidDate, fileToSend: '')));
          },
          onBack: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Stack(
          children: [
            Consumer<WallpaperProvider>(
              builder: (context, wallpaperProvider, child) {
                final backgroundImage = wallpaperProvider.getBackgroundImage(
                  widget.user.id,
                  defaultImage: context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight,
                );

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
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  InfoCard(
                    icon: Icons.lock_outline,
                    text: 'Сообщения и звонки защищены сквозным шифрованием. ''Прочитать, прослушать или переслать их могут только ''участники этого чата. ',
                    onTap: () {
                      showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildWelcomeCommunity(),
                ],
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
                  type: isMe ? MessageBubbleType.sender : MessageBubbleType.recipient,
                  isPressed: false,
                  chatTarget: widget.user,
                  user: widget.user,
                  replyMessage: replyMessage,
                  replyUser: replyUser,
                  onClearReply: () {
                    setState(() {
                      replyMessage = null;
                      replyUser = null;
                    });
                  },
                  onSendMessage: (text, mentions) async {
                    if (list.isEmpty) {
                      await APIs.sendFirstMessage(widget.user, text, MessageType.text, mentions: mentions);
                    } else {
                      await ChatApi.sendMessage(widget.user, text, MessageType.text, mentions: mentions);
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
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              showEditImageBottomDialog(
                context,
                title: 'Картинка группы',
                onImageSelected: (String value) {},
                onEmojiSelected: (Color color, String emoji) {},
                onDeletePressed: () {},
              );
            },
            child: SizedBox(
              width: 68,
              height: 68,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: _communityImageUrl != null && _communityImageUrl!.trim().isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _communityImageUrl!,
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildCommunityPlaceholder(),
                            errorWidget: (context, url, error) => _buildCommunityPlaceholder(),
                          )
                        : _buildCommunityPlaceholder(),
                    ),
                  ),
                  Positioned(
                    right: -3,
                    bottom: -3,
                    child: GestureDetector(
                      onTap: () {
                        showEditImageBottomDialog(
                          context,
                          title: 'Картинка группы',
                          onImageSelected: (String value) {},
                          onEmojiSelected: (Color color, String emoji) {},
                          onDeletePressed: () {},
                        );
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.camera_alt_rounded, size: 15, color: ChatifyColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Добро пожаловать в группу "Общая"',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 17, fontWeight: FontWeight.w400, height: 1.3),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Этот чат могут использовать для общения друг с другом все участники сообщества',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.softGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
            ),
          ),
          const SizedBox(height: 22),
          AddMemberButton(),
        ],
      ),
    );
  }

  Widget _buildCommunityPlaceholder() {
    return Container(
      width: 68,
      height: 68,
      color: ChatifyColors.grey,
      alignment: Alignment.center,
      child: SvgPicture.asset(ChatifyVectors.communityMessage, width: 38, height: 38),
    );
  }
}
