import 'dart:io';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../models/message_model.dart';
import '../widgets/bars/chat_app_bar.dart';
import '../widgets/bars/sections/selection_chat_app_bar.dart';
import '../widgets/cards/message_card.dart';
import '../widgets/dialogs/delete_recipient_message_dialog.dart';
import '../widgets/dialogs/delete_sender_message_dialog.dart';
import '../widgets/dialogs/message_update_dialog.dart';
import '../widgets/input/chat_input.dart';
import '../widgets/toolbar/emoji_toolbar.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  final File? fileToSend;

  const ChatScreen({super.key, required this.user, this.fileToSend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  List<MessageModel> list = [];
  List<MessageModel> messages = [];
  late final MessageModel message;
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  Set<int> selectedMessages = <int>{};
  bool isSelecting = false;
  bool isToolbarVisible = true;
  bool isIconVisible = false;
  bool showEmoji = false;
  bool isUploading = false;
  late final AnimationController animationController;
  late final Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    // scrollController.addListener(onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        inputFocusNode.requestFocus();

        await Future.delayed(const Duration(milliseconds: 100));
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    textController.dispose();
    inputFocusNode.dispose();
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _toggleMessageSelection(int index) {
    setState(() {
      if (isSelecting) {
        if (selectedMessages.contains(index)) {
          selectedMessages.remove(index);
        } else {
          selectedMessages.add(index);
        }

        if (selectedMessages.isEmpty) {
          _clearSelection();
        }
      }
    });
  }

  void _startSelection() {
    setState(() {
      isSelecting = true;
    });
  }

  void _clearSelection() {
    setState(() {
      selectedMessages.clear();
      isSelecting = false;
    });
  }

  void _handleUpdateMessage(MessageModel message) {
    ShowMessageUpdateDialog.showMessageUpdateDialog(
        context,
        message,
            () {
          setState(() {
            _clearSelection();
          });
        }
    );
  }

  void _handleDeleteSelectedMessages() {
    if (selectedMessages.isNotEmpty) {
      bool allFromCurrentUser = selectedMessages.every((index) => list[index].fromId == APIs.user.uid);

      if (allFromCurrentUser) {
        showDeleteSenderMessageDialog(context, selectedMessages.toList(), list, widget.user);
      } else if (selectedMessages.every((index) => list[index].fromId != APIs.user.uid)) {
        showDeleteRecipientMessageDialog(context, selectedMessages.toList(), list, widget.user);
      } else {
        Get.snackbar(S.of(context).warning, S.of(context).pleaseSelectOnlyMessages);
      }
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

  void _handleReaction(MessageModel message, String reaction) {
    APIs.updateMessageReaction(message, reaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: isSelecting ? const SizedBox.shrink() : ChatAppBar(user: widget.user),
              ),
            ),
            if (isSelecting && selectedMessages.isNotEmpty)
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: context.isDarkMode  ? ChatifyColors.blackGrey : ChatifyColors.white,
                  child: SelectionChatAppBar(
                    selectedMessages: selectedMessages,
                    list: list,
                    clearSelection: _clearSelection,
                    handleDeleteSelectedMessages: _handleDeleteSelectedMessages,
                    handleUpdateMessage: _handleUpdateMessage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: context.isDarkMode  ? ChatifyColors.black : ChatifyColors.white,
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 5,
            thumbVisibility: false,
            child: Stack(
              children: [
                Consumer<WallpaperProvider>(
                  builder: (context, wallpaperProvider, child) {
                    final backgroundImage = wallpaperProvider.backgroundImage.isNotEmpty
                      ? wallpaperProvider.backgroundImage
                      : (context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight);

                    return Container(
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)),
                    );
                  },
                ),
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          StreamBuilder(
                            stream: APIs.getAllMessages(widget.user),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                case ConnectionState.none: return const SizedBox();
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
                                  if (list.isNotEmpty) {
                                    return ListView.builder(
                                      controller: scrollController,
                                      reverse: true,
                                      itemCount: list.length,
                                      padding: EdgeInsets.only(top: DeviceUtils.getScreenHeight(context) * .01),
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return MessageCard(
                                          message: list[index],
                                          isSelected: selectedMessages.contains(index),
                                          onLongPress: () {
                                            _startSelection();
                                            _toggleMessageSelection(index);
                                          },
                                          onTap: () => _toggleMessageSelection(index),
                                          messages: [],
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(child: Text(S.of(context).hello, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)));
                                  }
                              }
                            },
                          ),
                          if (isSelecting && selectedMessages.isNotEmpty)
                          Positioned(
                            bottom: 90,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: EmojiToolbar(
                                emojis: const ['👍', '❤️', '😂', '😮', '😥', '🙏'],
                                onAddPressed: toggleEmojiKeyboard,
                                onToggleKeyboard: toggleEmojiKeyboard,
                                onReactionPressed: (emoji) {
                                  for (int index in selectedMessages) {
                                    final message = list[index];
                                    _handleReaction(message, emoji);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUploading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                      ),
                    ),
                    ChatInput(focusNode: inputFocusNode, user: widget.user, onToggleEmojiKeyboard: toggleEmojiKeyboard),
                  ],
                ),
                Positioned(
                  bottom: 65,
                  right: 10,
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: isIconVisible
                      ? SizedBox(
                        width: 30,
                        height: 30,
                        child: FloatingActionButton(
                          onPressed: () {
                            scrollToBottom();
                          },
                          backgroundColor: ChatifyColors.blackGrey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          mini: true,
                          child: const Icon(Icons.keyboard_double_arrow_down_outlined, color: ChatifyColors.darkGrey),
                        ),
                      )
                    : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
