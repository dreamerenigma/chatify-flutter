import 'dart:developer';
import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../api/apis.dart';
import '../../../core/enums/selection_action_mode_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/helper/date_util.dart';
import '../../../utils/popups/app_loaders.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/message_model.dart';
import '../widgets/bars/chat_app_bar.dart';
import '../widgets/bars/selection_chat_app_bar.dart';
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
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  late final AnimationController animationController;
  late final Animation<double> opacityAnimation;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream;
  bool isSelecting = false;
  bool isToolbarVisible = true;
  bool isIconVisible = false;
  bool showEmoji = false;
  bool isUploading = false;
  bool isEmojiToolbarVisible = true;
  List<MessageModel> list = [];
  List<MessageModel> messages = [];
  Set<int> selectedMessages = <int>{};
  MessageModel? replyMessage;
  UserModel? replyUser;

  bool _isDifferentDay(MessageModel current, MessageModel? previous) {
    if (previous == null) return true;

    final currentDate = DateTime.fromMillisecondsSinceEpoch(int.parse(current.sent));
    final previousDate = DateTime.fromMillisecondsSinceEpoch(int.parse(previous.sent));

    return currentDate.year != previousDate.year || currentDate.month != previousDate.month || currentDate.day != previousDate.day;
  }

  SelectionActionModeType get selectionActionMode {
    if (selectedMessages.isEmpty) {
      return SelectionActionModeType.normal;
    }

    final hasDeleted = selectedMessages.any((index) => list[index].deletedBy.contains(APIs.user.uid));
    final hasNormal = selectedMessages.any((index) => !list[index].deletedBy.contains(APIs.user.uid));

    if (hasDeleted && hasNormal) {
      return SelectionActionModeType.mixed;
    }

    if (hasDeleted) {
      return SelectionActionModeType.deleted;
    }

    return SelectionActionModeType.normal;
  }

  double _getInputCardWidth(BuildContext context) {
    final screenWidth = DeviceUtils.getScreenWidth(context);

    const buttonRadius = 24.0;
    final buttonWidth = buttonRadius * 2;

    final horizontalPadding = screenWidth * .015;
    final spacing = screenWidth * .009;

    return screenWidth - horizontalPadding * 2 - 4 * 2 - spacing - buttonWidth;
  }

  @override
  void initState() {
    super.initState();
    messagesStream = APIs.getAllMessages(widget.user);
    scrollController.addListener(onScroll);
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      inputFocusNode.requestFocus();

      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      await SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    textController.dispose();
    inputFocusNode.dispose();
    scrollController.dispose();
    animationController.dispose();
    _closeChat();
    super.dispose();
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void onScroll() {
    if (!mounted || !scrollController.hasClients) return;

    final shouldShowButton = scrollController.offset > 100;

    if (shouldShowButton == isIconVisible) return;

    setState(() {
      isIconVisible = shouldShowButton;
    });

    if (shouldShowButton) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  void _toggleMessageSelection(int index) {
    setState(() {
      isEmojiToolbarVisible = true;

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
    ShowMessageUpdateDialog.showMessageUpdateDialog(context, message, () => setState(() => _clearSelection()));
  }

  void _handleDeleteSelectedMessages() {
    if (selectedMessages.isNotEmpty) {
      bool allFromCurrentUser = selectedMessages.every((index) => list[index].fromId == APIs.user.uid);

      if (allFromCurrentUser) {
        showDeleteSenderMessageDialog(context, selectedMessages.toList(), list, widget.user, onDeleted: _clearSelection);
      } else if (selectedMessages.every((index) => list[index].fromId != APIs.user.uid)) {
        showDeleteRecipientMessageDialog(context, selectedMessages.toList(), list, widget.user);
      } else {
        Get.snackbar(S.of(context).warning, S.of(context).pleaseSelectOnlyMessages);
      }
    }
  }

  Future<void> _handleDeleteSelectedDeletedMessages() async {
    if (selectedMessages.isEmpty) return;

    final selected = selectedMessages.map((index) => list[index]).where((message) => message.deletedBy.contains(APIs.user.uid)).toList();

    if (selected.isEmpty) {
      _clearSelection();
      return;
    }

    try {
      for (final message in selected) {
        final deleted = await APIs.deleteMessageDocument(message);

        if (!deleted) {
          log('❌ Не удалось удалить документ: ${message.sent}');
        }
      }

      if (mounted) {
        _clearSelection();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка полного удаления сообщений: $e');
      debugPrintStack(stackTrace: stackTrace);
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

  Future<void> _handleReaction(MessageModel message, String reaction) async {
    await APIs.updateMessageReaction(message, reaction);
  }

  void _closeChat() {
    APIs.updateTypingStatus(false);
    inputFocusNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _hideEmojiToolbarOnScroll() {
    if (!mounted || !isEmojiToolbarVisible) return;

    setState(() {
      isEmojiToolbarVisible = false;
    });
  }

  Future<void> _handleReactionForSelectedMessages(String reaction) async {
    final selected = selectedMessages.toList();

    setState(() {
      isSelecting = false;
      isEmojiToolbarVisible = false;
      selectedMessages.clear();
    });

    for (final index in selected) {
      final message = list[index];
      await _handleReaction(message, reaction);
    }
  }

  void _startReply() {
    if (selectedMessages.isEmpty) return;

    final index = selectedMessages.first;

    if (index < 0 || index >= list.length) return;

    final message = list[index];
    final UserModel user = message.fromId == APIs.user.uid ? APIs.me : widget.user;

    setState(() {
      replyMessage = message;
      replyUser = user;

      selectedMessages.clear();
      isSelecting = false;
    });
  }

  void _copySelectedMessage() {
    if (selectedMessages.isEmpty) return;

    final index = selectedMessages.first;

    if (index < 0 || index >= list.length) return;

    final message = list[index];

    Clipboard.setData(ClipboardData(text: message.msg));

    setState(() {
      selectedMessages.clear();
      isSelecting = false;
    });

    CustomIconSnackBar.showAnimatedSnackBar(context, 'Сообщение скопировано!', icon: const Icon(BootstrapIcons.check_circle), iconColor: ChatifyColors.success);
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> selectedReactions = selectedMessages.map((index) => list[index].reactions).whereType<String>().where((reaction) => reaction.isNotEmpty).toSet();
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))]),
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
                      selectionActionMode: selectionActionMode,
                      handleDeleteDeletedMessages: _handleDeleteSelectedDeletedMessages,
                      onReply: _startReply,
                      onCopyMessage: _copySelectedMessage,
                      user: widget.user,
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
        child: Stack(
          children: [
            Consumer<WallpaperProvider>(
              builder: (context, wallpaperProvider, child) {
                final backgroundImage = wallpaperProvider.backgroundImage.isNotEmpty
                  ? wallpaperProvider.backgroundImage
                  : (context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight);

                return Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)));
              },
            ),
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      StreamBuilder(
                        stream: messagesStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                            return const SizedBox();
                          }

                          final data = snapshot.data?.docs;
                          final newList = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

                          list = newList;

                          if (list.isNotEmpty) {
                            APIs.markMessagesAsRead(list);
                          }

                          if (list.isEmpty) {
                            return Center(child: Text(S.of(context).hello, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)));
                          }

                          return ScrollbarTheme(
                            data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                            child: Scrollbar(
                              controller: scrollController,
                              thickness: 5,
                              thumbVisibility: false,
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is ScrollStartNotification) {
                                    _hideEmojiToolbarOnScroll();
                                  }

                                  return false;
                                },
                                child: ListView.builder(
                                  controller: scrollController,
                                  reverse: true,
                                  itemCount: list.length,
                                  padding: EdgeInsets.only(top: DeviceUtils.getScreenHeight(context) * .01),
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final message = list[index];
                                    final previousMessage = index + 1 < list.length ? list[index + 1] : null;
                                    final showDateSeparator = _isDifferentDay(message, previousMessage);

                                    return Column(
                                      children: [
                                        if (showDateSeparator)
                                          _buildDateSeparator(context, message),
                                        MessageCard(
                                          key: ValueKey(message.sent),
                                          message: message,
                                          isSelected: selectedMessages.contains(index),
                                          onLongPress: () {
                                            _startSelection();
                                            _toggleMessageSelection(index);
                                          },
                                          onTap: () => _toggleMessageSelection(index),
                                          messages: list,
                                          onReply: (message) {
                                            setState(() {
                                              replyMessage = message;
                                              replyUser = widget.user;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (isSelecting && selectedMessages.isNotEmpty && isEmojiToolbarVisible)
                        Positioned(
                          bottom: 100,
                          left: -5,
                          right: -5,
                          child: Center(
                            child: EmojiToolbar(
                              emojis: const ['👍', '❤️', '😂', '😮', '😥', '🙏', '👏', '🥰', '😴', '😭', '🔥', '🤣'],
                              selectedReactions: selectedReactions,
                              onAddPressed: toggleEmojiKeyboard,
                              onToggleKeyboard: toggleEmojiKeyboard,
                              onReactionPressed: (emoji) {
                                _handleReactionForSelectedMessages(emoji);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isUploading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                    ),
                  ),
                if (replyMessage != null)
                  _buildReplyPreview(replyMessage!, widget.user),
                Padding(
                  padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : MediaQuery.of(context).viewPadding.bottom),
                  child: ChatInput(focusNode: inputFocusNode, user: widget.user, onToggleEmojiKeyboard: toggleEmojiKeyboard, isReplyVisible: replyMessage != null),
                ),
              ],
            ),
            Positioned(
              bottom: 75 + MediaQuery.of(context).viewPadding.bottom,
              right: 15,
              child: IgnorePointer(
                ignoring: !isIconVisible,
                child: FadeTransition(
                  opacity: opacityAnimation,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: FloatingActionButton(
                      onPressed: scrollToBottom,
                      backgroundColor: ChatifyColors.blackGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      mini: true,
                      child: const Icon(Icons.keyboard_double_arrow_down_outlined, color: ChatifyColors.darkGrey),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyPreview(MessageModel message, UserModel user) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: _getInputCardWidth(context),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: context.isDarkMode ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.blue, width: 5)),
                ),
                child: Stack(
                  children: [
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${user.name}${user.surname.isNotEmpty ? ' ${user.surname}' : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: ChatifyColors.blueAccent.withValues(alpha: 0.8), fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                message.msg,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.textSecondary : ChatifyColors.darkGrey, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            replyMessage = null;
                            replyUser = null;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          child: Icon(Icons.close, size: 17, color: ChatifyColors.darkGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(BuildContext context, MessageModel message) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(message.sent));

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.deepNight.withAlpha(220) : ChatifyColors.white.withAlpha(220), borderRadius: BorderRadius.circular(12)),
        child: Text(
          DateUtil.getCallDateTime(context: context, time: date, showTime: false),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
        ),
      ),
    );
  }
}
