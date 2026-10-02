import 'package:chatify/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../api/group_api.dart';
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

    return Scaffold(
      appBar: GroupChatAppBar(group: widget.group, userNamesFuture: userNamesFuture, users: widget.users),
      body: Stack(
        children: [
          Consumer<WallpaperProvider>(
            builder: (context, wallpaperProvider, child) {
              final backgroundImage = wallpaperProvider.backgroundImage.isNotEmpty ? wallpaperProvider.backgroundImage : (context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight);

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
                  chatTarget: widget.group,
                  user: widget.user,
                  onSendMessage: (text) async {
                    GroupApi.sendGroupMessage(widget.group, text, MessageType.text);
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
