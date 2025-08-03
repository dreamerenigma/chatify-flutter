import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/chat/models/message_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/widgets/input/buttons/camera_button.dart';
import '../../../chat/widgets/input/buttons/chat_input_attachments_button.dart';
import '../../../group/models/group_model.dart';
import '../dialogs/light_dialog.dart';

class GroupInput extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupImage;
  final DateTime createdAt;
  final List<String> members;

  const GroupInput({
    super.key,
    required this.groupId,
    required this.members,
    required this.groupName,
    required this.groupImage,
    required this.createdAt,
  });

  @override
  GroupInputState createState() => GroupInputState();
}

class GroupInputState extends State<GroupInput> {
  final TextEditingController textController = TextEditingController();
  final focusNode = FocusNode();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showEmoji = false, isUploading = false;
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
    final group = GroupModel(
      groupId: widget.groupId,
      groupName: widget.groupName,
      groupImage: widget.groupImage,
      groupDescription: '',
      createdAt: widget.createdAt,
      creatorName: APIs.user.displayName ?? S.of(context).unknownUser,
      members: widget.members,
      pushToken: '',
      lastMessageTimestamp: 0,
    );
    await APIs.sendGroupImage(group, image);
    setState(() => isUploading = false);
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      final group = GroupModel(
        groupId: widget.groupId,
        groupName: widget.groupName,
        groupImage: widget.groupImage,
        groupDescription: '',
        createdAt: widget.createdAt,
        creatorName: APIs.user.displayName ?? S.of(context).unknownUser,
        members: widget.members,
        pushToken: '',
        lastMessageTimestamp: 0,
      );
      const messageType = Type.text;

      APIs.sendGroupMessage(
        group,
        textController.text,
        messageType
      );

      textController.clear();
      playSendSound();
      setState(() {
        isTyping = false;
      });
    } else {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterText);
    }
  }

  Future<void> playSendSound() async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color:  context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboard,
                          icon: Icon(Icons.emoji_emotions, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
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
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              decoration: InputDecoration(
                                hintText: S.of(context).message,
                                hintStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt())),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: const TextStyle(fontSize: 16),
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
                        ChatInputAttachments(
                          chatTarget: GroupModel(
                            groupId: '',
                            groupName: '',
                            groupImage: '',
                            groupDescription: '',
                            createdAt: widget.createdAt,
                            creatorName: '',
                            members: widget.members,
                            pushToken: '',
                            lastMessageTimestamp: 0,
                          ),
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
                const SizedBox(width: 5),
                GestureDetector(
                  onTapUp: (_) async {
                    if (isTyping) {
                      sendMessage();
                    } else {
                      Dialogs.showSnackbar(context, S.of(context).holdRecordVoiceMessage, fontSize: ChatifySizes.fontSizeMd);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    radius: 25,
                    child: Icon(isTyping ? Icons.send : Icons.mic, color: ChatifyColors.black, size: 28),
                  ),
                ),
              ],
            ),
          ),
          if (showEmoji)
          EmojiPicker(
            textEditingController: textController,
            config: Config(
              height: MediaQuery.of(context).size.height * 0.35,
              checkPlatformCompatibility: true,
              emojiViewConfig: EmojiViewConfig(
                columns: 8,
                emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
