import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/chat/models/message_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class DetailImageInput extends StatefulWidget {
  final UserModel user;
  final FocusNode focusNode;
  final VoidCallback onToggleEmojiKeyboard;

  const DetailImageInput({
    super.key,
    required this.user,
    required this.focusNode,
    required this.onToggleEmojiKeyboard,
  });

  @override
  DetailImageInputState createState() => DetailImageInputState();
}

class DetailImageInputState extends State<DetailImageInput> {
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
  void initState() {
    super.initState();
    user = widget.user;
    focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        showEmoji = false;
      });
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
      setState(() {
        isTyping = false;
      });
    } else {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterText);
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showEmoji) {
          setState(() {
            showEmoji = false;
            focusNode.unfocus();
          });
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: DeviceUtils.getScreenHeight(context) * .01, left: DeviceUtils.getScreenWidth(context) * .015, right: DeviceUtils.getScreenWidth(context) * .015),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: context.isDarkMode ? ChatifyColors.blackGrey : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboard,
                            icon: Icon(
                              showEmoji ? Icons.keyboard : focusNode.hasFocus ? Icons.emoji_emotions_outlined : LucideIcons.imagePlus,
                              color: ChatifyColors.white,
                              size: 26,
                            ),
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
                                  hintText: S.of(context).addSignature,
                                  hintStyle: TextStyle(color: ChatifyColors.white),
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
      ),
    );
  }
}
