import 'package:chatify/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../api/group_api.dart';
import '../../../core/enums/message_bubble_type.dart';
import '../../../core/enums/message_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../chat/models/message_model.dart';
import '../../chat/models/user_model.dart';
import '../../chat/widgets/input/chat_input.dart';
import '../models/group_model.dart';
import '../widgets/bars/app_bars/group_chat_app_bar.dart';
import '../widgets/lists/group_chat_message_list.dart';

class GroupChatScreen extends StatefulWidget {
  final GroupModel group;
  final UserModel user;
  final Map<String, UserModel> users;

  const GroupChatScreen({
    super.key,
    required this.group,
    required this.user,
    required this.users,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final FocusNode inputFocusNode = FocusNode();
  late Future<Map<String, String>> userNamesFuture;
  bool showEmoji = false;
  List<MessageModel> list = [];
  List<MessageModel> messages = [];
  UserModel? replyUser;
  MessageModel? replyMessage;

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
    userNamesFuture = APIs.fetchUserNames(widget.group.members, shortenNames: false);
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
    final user = APIs.me;
    final isMe = widget.user.id == user.id;

    return Scaffold(
      appBar: GroupChatAppBar(group: widget.group, userNamesFuture: userNamesFuture, users: widget.users, user: widget.user),
      body: Stack(
        children: [
          Consumer<WallpaperProvider>(
            builder: (context, wallpaperProvider, child) {
              final backgroundImage = wallpaperProvider.getBackgroundImage(
                'group_${widget.group.id}_wallpaper',
                defaultImage: context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight,
              );

              return Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)));
            },
          ),
          Column(
            children: [
              Expanded(child: GroupChatMessageList(group: widget.group, messages: messages)),
              Padding(
                padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : MediaQuery.of(context).viewPadding.bottom),
                child: ChatInput(
                  focusNode: inputFocusNode,
                  onToggleEmojiKeyboard: toggleEmojiKeyboard,
                  isReplyVisible: replyMessage != null,
                  type: isMe ? MessageBubbleType.sender : MessageBubbleType.recipient,
                  isPressed: false,
                  chatTarget: widget.group,
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
                    await GroupApi.sendGroupMessage(widget.group, text, MessageType.text, mentions: mentions);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
