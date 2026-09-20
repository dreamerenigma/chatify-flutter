import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/chat/models/message_model.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../api/chat_api.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/user_model.dart';
import '../dialogs/voice_record_bottom_sheet_dialog.dart';
import 'buttons/camera_button.dart';
import 'buttons/chat_input_attachments_button.dart';

class ChatInput extends StatefulWidget {
  final UserModel user;
  final FocusNode focusNode;
  final VoidCallback onToggleEmojiKeyboard;
  final bool isReplyVisible;
  final Future<void> Function(String text) onSendMessage;

  const ChatInput({
    super.key,
    required this.user,
    required this.focusNode,
    required this.onToggleEmojiKeyboard,
    required this.isReplyVisible,
    required this.onSendMessage,
  });

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  final TextEditingController textController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  late final ValueChanged<bool> setUploading;
  late final UserModel user;
  bool showEmoji = false;
  bool isUploading = false;
  bool sendWithEnter = false;
  bool isTyping = false;
  bool showVideoToast = false;
  double _dragOffset = 0;
  Timer? typingTimer;
  List<MessageModel> list = [];

  bool get hasText => textController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    textController.addListener(_handleTyping);
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    textController.removeListener(_handleTyping);
    widget.focusNode.removeListener(_onFocusChanged);
    typingTimer?.cancel();
    textController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!widget.focusNode.hasFocus) {
      typingTimer?.cancel();

      if (isTyping) {
        isTyping = false;
        APIs.updateTypingStatus(false);
      }
    }
  }

  void toggleEmojiKeyboard() {
    if (showEmoji) {
      widget.focusNode.requestFocus();
    } else {
      widget.focusNode.unfocus();
    }
    setState(() {
      showEmoji = !showEmoji;
    });
  }

  void handleImagePicked(File image) async {
    setState(() => isUploading = true);
    await ChatApi.sendChatImage(widget.user, image);
    setState(() => isUploading = false);
  }

  Future<void> sendGif(File file) async {
    setState(() => isUploading = true);
    await ChatApi.sendChatImage(widget.user, file);
    setState(() => isUploading = false);
  }

  Future<void> sendVideo(File file) async {
    setState(() => isUploading = true);
    await ChatApi.sendChatVideo(widget.user, file);
    setState(() => isUploading = false);
  }

  Future<void> playSendSound() async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  Future<void> sendMessage() async {
    if (!hasText) {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterTextMessage);
      return;
    }

    final text = textController.text.trim();

    await widget.onSendMessage(text);

    textController.clear();

    playSendSound();

    if (mounted) {
      setState(() {});
    }
  }

  void _handleTyping() {
    final hasTextNow = hasText;

    if (!hasTextNow) {
      typingTimer?.cancel();

      if (isTyping) {
        isTyping = false;
        APIs.updateTypingStatus(false);
      }

      if (mounted) {
        setState(() {});
      }

      return;
    }

    if (!isTyping) {
      isTyping = true;
      APIs.updateTypingStatus(true);
    }

    typingTimer?.cancel();

    typingTimer = Timer(
      const Duration(seconds: 3), () {
        if (!isTyping) return;

        isTyping = false;
        APIs.updateTypingStatus(false);

        if (mounted) {
          setState(() {});
        }
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: DeviceUtils.getScreenWidth(context) * .015, right: DeviceUtils.getScreenWidth(context) * .015, top: widget.isReplyVisible ? 0 : DeviceUtils.getScreenHeight(context) * .005, bottom: DeviceUtils.getScreenHeight(context) * .005),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 4),
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.isReplyVisible ? 0 : 25),
                      topRight: Radius.circular(widget.isReplyVisible ? 0 : 25),
                      bottomLeft: const Radius.circular(25),
                      bottomRight: const Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboard,
                          icon: SvgPicture.asset(ChatifyVectors.emojiSticker, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.textSecondary, BlendMode.srcIn)),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 50, maxHeight: 120),
                            child: TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                              child: TextField(
                                controller: textController,
                                focusNode: widget.focusNode,
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                decoration: InputDecoration(
                                  hintText: S.of(context).message,
                                  hintStyle: TextStyle(color: ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 2)
                                ),
                                textCapitalization: TextCapitalization.sentences,
                                style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, height: 1.2),
                                onTap: () {
                                  if (showEmoji) {
                                    setState(() {
                                      showEmoji = false;
                                    });
                                  }
                                },
                                onSubmitted: (value) {
                                  if (sendWithEnter) {
                                    sendMessage();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        ChatInputAttachments(
                          chatTarget: user,
                          user: user,
                          isUploading: isUploading,
                          setUploading: (value) {
                            setState(() {
                              isUploading = value;
                            });
                          },
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          reverseDuration: const Duration(milliseconds: 180),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(begin: const Offset(0.6, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

                            return FadeTransition(opacity: animation, child: SlideTransition(position: offsetAnimation, child: child));
                          },
                          child: hasText
                            ? const SizedBox(key: ValueKey('camera-hidden'), width: 0)
                            : CameraButton(key: const ValueKey('camera-visible'), onImagePicked: handleImagePicked, user: user),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: DeviceUtils.getScreenWidth(context) * .009),
              GestureDetector(
                onPanStart: (_) {
                  _dragOffset = 0;
                },
                onPanUpdate: (details) {
                  if (!hasText) {
                    if (details.delta.dy < 0) {
                      _dragOffset += -details.delta.dy;
                    }
                  }
                },
                onPanEnd: (_) {
                  if (hasText) {
                    sendMessage();
                    return;
                  }

                  if (_dragOffset >= 80) {
                    _dragOffset = 0;

                    showVoiceRecordBottomSheetDialog(context, widget.user);

                    return;
                  }
                  _dragOffset = 0;
                  Dialogs.showSnackbarMargin(context, S.of(context).holdRecord, fontSize: ChatifySizes.fontSizeLm, margin: const EdgeInsets.only(bottom: 65, left: 10, right: 10));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: CircleAvatar(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    radius: 24,
                    child: hasText ? const Icon(Icons.send, color: ChatifyColors.black, size: 21) : const Icon(Icons.mic, color: ChatifyColors.black, size: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showEmoji)
          EmojiPicker(
            textEditingController: textController,
            config: Config(
              height: DeviceUtils.getScreenHeight(context) * 0.35,
              checkPlatformCompatibility: true,
              emojiViewConfig: EmojiViewConfig(columns: 8, emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0)),
              categoryViewConfig: const CategoryViewConfig(),
              bottomActionBarConfig: const BottomActionBarConfig(),
              skinToneConfig: const SkinToneConfig(),
            ),
          ),
      ],
    );
  }
}
