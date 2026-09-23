import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/helper/date_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../api/group_api.dart';
import '../../../core/enums/message_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../chat/models/message_model.dart';
import '../../chat/widgets/cards/message_card.dart';
import '../../chat/widgets/input/chat_input.dart';
import '../../community/screens/add_user_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/cards/encrypted_chat_info_card.dart';
import '../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../models/group_model.dart';
import '../widgets/bars/group_chat_app_bar.dart';
import 'about_group_screen.dart';
import 'description_group_screen.dart';

class GroupChatScreen extends StatefulWidget {
  final GroupModel group;

  const GroupChatScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final FocusNode inputFocusNode = FocusNode();
  late Future<Map<String, String>> userNamesFuture;
  bool showEmoji = false;
  MessageModel? replyMessage;
  List<MessageModel> list = [];
  List<MessageModel> messages = [];

  String get formattedDate {
    final currentGroup = widget.group;

    try {
      return DateFormat('dd.MM.yyyy').format(currentGroup.createdAt);
    } catch (_) {
      return S.of(context).invalidDate;
    }
  }

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.group.members, shortenNames: true);
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
      appBar: GroupChatAppBar(group: widget.group, userNamesFuture: userNamesFuture),
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
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                ),
                child: Text(
                  DateUtil.formatDateTime(widget.group.createdAt),
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    EncryptedChatInfoCard(),
                    _buildCardGroup(),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: GroupApi.getGroupMessages(widget.group),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list = data?.map((e) => MessageModel.fromJson(e.data(), id: e.id)).toList() ?? [];

                        if (list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: list.length,
                            padding: EdgeInsets.only(top: DeviceUtils.getScreenHeight(context) * .01),
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: list[index], isSelected: false, onLongPress: () {}, onTap: () {}, messages: messages, user: APIs.me);
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                    }
                  },
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
                    chatTarget: widget.group,
                    onSendMessage: (text) async {
                      GroupApi.sendGroupMessage(widget.group, text, MessageType.text);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardGroup() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Аватар группы
              ClipOval(
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.height * .08,
                  height: MediaQuery.of(context).size.height * .08,
                  imageUrl: widget.group.groupImage,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: ChatifyColors.buttonSecondary,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundColor: ChatifyColors.buttonSecondary,
                    child: Icon(Icons.group, size: 42, color: ChatifyColors.grey),
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: GestureDetector(
                  onTap: () {
                    showEditImageBottomDialog(
                      context,
                      title: 'Картинка группы',
                      onImageSelected: (String value) {},
                      onEmojiSelected: (Color color, String emoji) {},
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, width: 2),
                    ),
                    child: Center(child: Icon(Icons.camera_alt_outlined, size: 15, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(S.of(context).youCreatedGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
          Text('${S.of(context).aboutGroups} • ${widget.group.members.length} ${S.of(context).participants.substring(1)}', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(text: 'Участники могут добавлять людей или приглашать их с помощью ссылки. ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                    TextSpan(
                      text: S.of(context).edit,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600, height: 1.4),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(context, createPageRoute(const DescriptionGroupScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(context, createPageRoute(const AddUserScreen()));
              },
              icon: Icon(Icons.person_add_alt_outlined, size: 20, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              label: Text(
                S.of(context).addParticipants,
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  fontWeight: FontWeight.w400,
                  fontSize: ChatifySizes.fontSizeMd,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(context, createPageRoute(AboutGroupScreen(group: widget.group, user: const {})));
              },
              icon: Icon(Icons.link, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              label: Text(
                S.of(context).inviteViaLink,
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  fontWeight: FontWeight.w500,
                  fontSize: ChatifySizes.fontSizeMd,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
