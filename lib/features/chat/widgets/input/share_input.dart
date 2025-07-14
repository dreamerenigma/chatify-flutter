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
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/user_model.dart';
import '../../screens/chat_screen.dart';

class ShareInput extends StatefulWidget {
  final UserModel user;
  final File? fileToSend;

  const ShareInput({super.key, required this.user, this.fileToSend});

  @override
  ShareInputState createState() => ShareInputState();
}

class ShareInputState extends State<ShareInput> {
  late final UserModel user;
  List<MessageModel> list = [];
  final TextEditingController textController = TextEditingController();
  final focusNode = FocusNode();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showEmoji = false;
  bool isTyping = false;
  bool showEmojiIcon = false;
  File? fileToSend;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    fileToSend = widget.fileToSend;
    log('fileToSend in ShareInput: ${fileToSend?.path}');
    focusNode.addListener(() {
      setState(() {
        showEmojiIcon = focusNode.hasFocus;
      });
    });
  }

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

  Future<void> playSendSound() async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
      log('Playing sound: ${ChatifySounds.sendMessage}');
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  Future<void> sendMessage() async {
    String messageText = textController.text;

    if (fileToSend != null) {
      try {
        await APIs.sendChatImage(user, fileToSend!);
      } catch (e) {
        log('Error sending image: $e');
        return;
      }
    } else {
      if (list.isEmpty) {
        await APIs.sendFirstMessage(user, messageText, Type.text);
      } else {
        await APIs.sendMessage(user, messageText, Type.text);
      }
    }

    textController.clear();
    playSendSound();
    setState(() {
      isTyping = false;
      fileToSend = null;
    });

    Navigator.of(context).pushReplacement(
      createPageRoute(ChatScreen(user: user)),
    );
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
                        if (showEmojiIcon)
                          IconButton(onPressed: toggleEmojiKeyboard, icon: const Icon(Icons.emoji_emotions, color: Colors.blueAccent, size: 26)),
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
                                contentPadding: EdgeInsets.only(left: showEmojiIcon ? 0 : 8, right: 8),
                                prefixIcon: showEmojiIcon ? null : const Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Icon(Icons.emoji_emotions, color: Colors.blueAccent, size: 26),
                                ),
                                prefixIconConstraints: BoxConstraints(minWidth: showEmojiIcon ? 0 : 40),
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
                                sendMessage();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: DeviceUtils.getScreenWidth(context) * .005),
                GestureDetector(
                  onTapUp: (_) async {
                    await sendMessage();
                  },
                  child: const CircleAvatar(backgroundColor: Colors.blue, radius: 20, child: Icon(Icons.send, color: ChatifyColors.white, size: 28)),
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
