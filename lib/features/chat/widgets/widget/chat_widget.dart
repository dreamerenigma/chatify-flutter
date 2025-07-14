import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../home/controllers/overlay_color_controller.dart';
import '../../../personalization/widgets/dialogs/attach_files_dialog.dart';
import '../../../personalization/widgets/dialogs/emoji_stickers_dialog.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../bars/chat_app_bar.dart';
import '../input/bottom_input.dart';
import '../toolbar/emoji_toolbar.dart';
import '../views/message_list_view.dart';

class ChatWidget extends StatefulWidget {
  final UserModel user;
  final double sidePanelWidth;

  const ChatWidget({
    super.key,
    required this.user,
    required this.sidePanelWidth,
  });

  @override
  State<ChatWidget> createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget>  with SingleTickerProviderStateMixin {
  List<MessageModel> list = [];
  List<MessageModel> cachedMessages = [];
  late FocusNode focusNode;
  late Future<Map<String, String>> userNamesFuture;
  late final MessageModel message;
  late UserModel chat;
  late final Animation<double> opacityAnimation;
  late final AnimationController animationController;
  final FocusNode inputFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  final overlayController = Get.put(OverlayColorController());
  final GlobalKey _textFieldKey = GlobalKey();
  final GlobalKey _newEmojiIconKey = GlobalKey();
  TextEditingController textController = TextEditingController();
  Stream<QuerySnapshot<Map<String, dynamic>>>? messageStream;
  bool hasText = false;
  bool isHovered = false;
  bool isSelecting = false;
  bool showEmoji = false;
  bool isUploading = false;
  bool isTyping = false;
  bool isIconVisible = false;
  bool isInside = false;
  Set<int> selectedMessages = <int>{};
  Timer? _debounce;
  String? lastDisplayedDay;
  int hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    chat = widget.user;
    _setMessagesStream();
    textController = TextEditingController();
    textController.addListener(_onTextChanged);
    focusNode = FocusNode();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    opacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        log('Animation completed!');
      }
    });
    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textController.removeListener(_onTextChanged);
    textController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    animationController.dispose();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.user.id != widget.user.id) {
      chat = widget.user;
      _setMessagesStream();
      textController.clear();
      selectedMessages.clear();
      lastDisplayedDay = null;
      hoveredIndex = -1;
      _debounce?.cancel();
      isTyping = false;

      FocusScope.of(context).requestFocus(focusNode);
      setState(() {});
    }
  }

  void _scrollListener() {
    final position = scrollController.position;

    final atBottom = position.pixels <= 10;

    if (atBottom) {
      if (!mounted) return;
      setState(() {
        isIconVisible = false;
      });
      animationController.reverse();
    } else {
      if (!mounted) return;
      setState(() {
        isIconVisible = true;
      });
      animationController.forward();
    }
  }

  void _setMessagesStream() {
    cachedMessages.clear();
    messageStream = APIs.getAllMessages(widget.user);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      final newHasText = textController.text.trim().isNotEmpty;
      if (newHasText != hasText) {
        setState(() {
          hasText = newHasText;
        });
      }
    });
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

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      if (list.isEmpty) {
        APIs.sendFirstMessage(widget.user, textController.text, Type.text);
      } else {
        APIs.sendMessage(widget.user, textController.text, Type.text);
      }
      textController.clear();
      APIs.playSendSound();
      setState(() {
        isTyping = false;
      });
      APIs.updateTypingStatus(widget.user.id, false);
    } else {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterText);
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void onEmojiSelected(String emoji) {
    setState(() {
      textController.text += emoji;
      textController.selection = TextSelection.collapsed(offset: textController.text.length);
    });
  }

  void onGifSelected(String sticker) {
    setState(() {
      textController.text += '[sticker:$sticker]';
      textController.selection = TextSelection.collapsed(offset: textController.text.length);
    });
  }

  Future<void> onImageSelected(File imageFile) async {
    log('Файл готов к отправке: ${imageFile.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(user: widget.user),
      body: _buildBody(),
      bottomNavigationBar: BottomInput(
        key: _newEmojiIconKey,
        textFieldKey: _textFieldKey,
        textController: textController,
        focusNode: focusNode,
        isHovered: isHovered,
        sendMessage: sendMessage,
        showEmojiStickersDialog: () async {
          final RenderBox renderBox = _newEmojiIconKey.currentContext?.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          await showEmojiStickersDialog(context, position, onEmojiSelected, onGifSelected);
        },
        showAttachFileDialog: () async {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          await showAttachFileDialog(context, position, onImageSelected);
        },
        onEmojiSelected: onEmojiSelected,
        onGifSelected: onGifSelected,
      ),
    );
  }

  Widget _buildBody() {
    final backgroundImage = context.isDarkMode ? ChatifyImages.groupBackgroundDark : ChatifyImages.groupBackgroundLight;

    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, alignment: Alignment.center)),
            ),
          ),
        ),
        Positioned.fill(
          child: Obx(() {
            final color = overlayController.overlayColor.value;
            final gradient = overlayController.overlayGradient.value;

            if (color == null && gradient == null) {
              return Container(color: ChatifyColors.transparent);
            }

            return  AnimatedContainer(
            duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(color: gradient == null ? color : null, gradient: gradient),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        _buildMessages(),
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
                        Positioned(
                          bottom: 25,
                          right: 20,
                          child: FadeTransition(
                            opacity: opacityAnimation,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: FloatingActionButton(
                                onPressed: scrollToBottom,
                                backgroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                mini: true,
                                child: Icon(Icons.keyboard_double_arrow_down_outlined, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        )),
      ],
    );
  }

  Widget _buildMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!isHovered && snapshot.hasData) {
          final data = snapshot.data?.docs;
          list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
          cachedMessages = list;
        }

        final messagesToShow = isHovered ? cachedMessages : list;
        final currentUserId = widget.user.id;
        final filteredMessages = messagesToShow.where((message) {
          return message.fromId == currentUserId || message.toId == currentUserId;
        }).toList();

        if (filteredMessages.isNotEmpty) {
          return MessageListView(
            messages: filteredMessages,
            isHovered: isHovered,
            isInside: isInside,
            scrollController: scrollController,
            selectedMessages: selectedMessages,
            startSelection: _startSelection,
            toggleMessageSelection: _toggleMessageSelection,
          );
        } else {
          return Center(child: Text(S.of(context).hello, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)));
        }
      },
    );
  }
}
