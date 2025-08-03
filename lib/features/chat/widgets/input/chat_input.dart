import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/chat/models/message_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/user_model.dart';
import 'buttons/chat_input_attachments_button.dart';
import 'buttons/camera_button.dart';

class ChatInput extends StatefulWidget {
  final UserModel user;
  final FocusNode focusNode;
  final VoidCallback onToggleEmojiKeyboard;

  const ChatInput({
    super.key,
    required this.user,
    required this.focusNode,
    required this.onToggleEmojiKeyboard,
  });

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  List<MessageModel> list = [];
  late final UserModel user;
  final TextEditingController textController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  late final ValueChanged<bool> setUploading;
  bool showEmoji = false, isUploading = false;
  bool sendWithEnter = false;
  Timer? typingTimer;
  bool get hasText => textController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    user = widget.user;

    textController.addListener(() {
      setState(() {});
      _handleTyping();
    });

    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        APIs.updateTypingStatus(user.id, false);
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    widget.focusNode.dispose();
    audioPlayer.dispose();
    typingTimer?.cancel();
    super.dispose();
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
    await APIs.sendChatImage(widget.user, image);
    setState(() => isUploading = false);
  }

  Future<void> sendGif(File file) async {
    setState(() => isUploading = true);
    await APIs.sendChatImage(widget.user, file);
    setState(() => isUploading = false);
  }

  Future<void> sendVideo(File file) async {
    setState(() => isUploading = true);
    await APIs.sendChatVideo(widget.user, file);
    setState(() => isUploading = false);
  }

  Future<void> playSendSound() async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  void sendMessage() {
    if (hasText) {
      if (list.isEmpty) {
        APIs.sendFirstMessage(widget.user, textController.text, Type.text);
      } else {
        APIs.sendMessage(widget.user, textController.text, Type.text);
      }

      textController.clear();
      playSendSound();

      setState(() {});
      APIs.updateTypingStatus(user.id, false);
    } else {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterTextMessage);
    }
  }

  void _handleTyping() {
  setState(() {});

  APIs.updateTypingStatus(user.id, hasText);

  typingTimer?.cancel();
  typingTimer = Timer(const Duration(seconds: 3), () {
    if (mounted && !hasText) {
      APIs.updateTypingStatus(user.id, false);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: DeviceUtils.getScreenWidth(context) * .015, right: DeviceUtils.getScreenWidth(context) * .015, top: DeviceUtils.getScreenHeight(context) * .005, bottom: DeviceUtils.getScreenHeight(context) * .005),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboard,
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            size: 26,
                          ),
                        ),
                        Expanded(
                          child: TextSelectionTheme(
                            data: TextSelectionThemeData(
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            child: TextField(
                              controller: textController,
                              focusNode: widget.focusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              decoration: InputDecoration(
                                hintText: S.of(context).typeSomething,
                                hintStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.8 * 255).toInt())),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
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

                                APIs.updateTypingStatus(user.id, false);
                              },
                            ),
                          ),
                        ),
                        ChatInputAttachments(
                          chatTarget: user,
                          isUploading: isUploading,
                          setUploading: (value) {
                            setState(() {
                              isUploading = value;
                            });
                          },
                        ),
                        CameraButton(onImagePicked: handleImagePicked),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: DeviceUtils.getScreenWidth(context) * .005),
                GestureDetector(
                  onTapUp: (_) async {
                    if (hasText) {
                      sendMessage();
                    } else {
                      Dialogs.showSnackbarMargin(
                        context, S.of(context).holdRecord,
                        fontSize: ChatifySizes.fontSizeLm,
                        margin: const EdgeInsets.only(bottom: 65, left: 10, right: 10),
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    radius: 20,
                    child: Icon(hasText ? Icons.send : Icons.mic, color: ChatifyColors.white, size: 28),
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
      ),
    );
  }
}
