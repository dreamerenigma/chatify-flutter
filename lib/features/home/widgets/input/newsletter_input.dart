import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/chat/models/message_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/input/buttons/camera_button.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class NewsletterInput extends StatefulWidget {
  final UserModel user;

  const NewsletterInput({super.key, required this.user});

  @override
  NewsletterInputState createState() => NewsletterInputState();
}

class NewsletterInputState extends State<NewsletterInput> {
  late final UserModel user;
  List<MessageModel> list = [];
  final TextEditingController textController = TextEditingController();
  final focusNode = FocusNode();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showEmoji = false, isUploading = false;
  late final ValueChanged<bool> setUploading;
  bool isTyping = false;
  bool sendWithEnter = false;

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void toggleEmojiKeyboard() {
    if (showEmoji) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
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
      log('Playing sound: ${ChatifySounds.sendMessage}');
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      if (list.isEmpty) {
        APIs.sendFirstMessage(widget.user, textController.text, Type.text);
      } else {
        APIs.sendMessage(widget.user, textController.text, Type.text);
      }
      textController.clear();
      playSendSound();
      setState(() {
        isTyping = false;
      });
    } else {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: DeviceUtils.getScreenHeight(context) * .01, horizontal: DeviceUtils.getScreenWidth(context) * .015),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboard,
                          icon: const Icon(Icons.emoji_emotions, color: ChatifyColors.blueAccent, size: 26),
                        ),
                        Expanded(
                          child: TextSelectionTheme(
                            data: TextSelectionThemeData(
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            child: TextField(
                              controller: textController,
                              focusNode: focusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              decoration: InputDecoration(
                                hintText: S.of(context).typeSomething,
                                hintStyle: const TextStyle(color: ChatifyColors.ascentBlue),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                              onTap: () {
                                if (showEmoji) {
                                  setState(() {
                                    showEmoji = false;
                                  });
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  isTyping = value.trim().isNotEmpty;
                                });
                              },
                              onSubmitted: (value) {
                                if (sendWithEnter) {
                                  sendMessage();
                                }
                              },
                            ),
                          ),
                        ),

                        /// -- Attachment button
                        // ChatInputAttachments(
                        //   user: widget.user,
                        //   isUploading: isUploading,
                        //   setUploading: (value) {
                        //     setState(() {
                        //       isUploading = value;
                        //     });
                        //   }, // Update isUploading state
                        // ),

                        /// -- Camera button
                        CameraButton(onImagePicked: handleImagePicked),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: DeviceUtils.getScreenWidth(context) * .005),
                GestureDetector(
                  onTapUp: (_) async {
                    if (isTyping) {
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
                    child: Icon(isTyping ? Icons.send : Icons.mic, color: ChatifyColors.white, size: 28),
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
