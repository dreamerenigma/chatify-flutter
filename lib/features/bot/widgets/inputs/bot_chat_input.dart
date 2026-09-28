import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_sounds.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class BotChatInput extends StatefulWidget {
  final FocusNode focusNode;
  final VoidCallback onToggleEmojiKeyboard;
  final Future<void> Function(String text) onSendMessage;

  const BotChatInput({
    super.key,
    required this.focusNode,
    required this.onToggleEmojiKeyboard,
    required this.onSendMessage,
  });

  @override
  State<BotChatInput> createState() => _BotChatInputState();
}

class _BotChatInputState extends State<BotChatInput> {
  final TextEditingController textController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showEmoji = false;
  bool isSending = false;

  bool get hasText => textController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    audioPlayer.dispose();

    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> sendMessage() async {
    if (!hasText) {
      return;
    }

    final text = textController.text.trim();

    textController.clear();

    try {
      setState(() {
        isSending = true;
      });

      await widget.onSendMessage(text);
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
    } catch (e, stackTrace) {
      log('BOT INPUT SEND ERROR: $e', stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, right: 14, top: DeviceUtils.getScreenHeight(context) * .005, bottom: DeviceUtils.getScreenHeight(context) * .005),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 4),
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                                selectionHandleColor:
                                colorsController.getColor(colorsController.selectedColorScheme.value,),
                              ),
                              child: TextField(
                                controller: textController,
                                focusNode: widget.focusNode,
                                autofocus: false,
                                keyboardType:
                                TextInputType.multiline,
                                maxLines: null,
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                decoration: InputDecoration(
                                  hintText: S.of(context).message,
                                  hintStyle: TextStyle(color: ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding:
                                  const EdgeInsets.only(top: 2),
                                ),
                                textCapitalization:
                                TextCapitalization.sentences,
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, height: 1.2),
                                onTap: () {
                                  if (showEmoji) {
                                    setState(() {
                                      showEmoji = false;
                                    });
                                  }
                                },
                                onSubmitted: (_) {
                                  sendMessage();
                                },
                              ),
                            ),
                          ),
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
                            ? const SizedBox(key: ValueKey('send-visible'))
                            : const SizedBox(key: ValueKey('empty-input'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: hasText ? sendMessage : null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: CircleAvatar(
                    backgroundColor:
                    colorsController.getColor(colorsController.selectedColorScheme.value),
                    radius: 24,
                    child: isSending
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ChatifyColors.black), strokeWidth: 3))
                      : Icon(
                          hasText ? Icons.send : Icons.mic,
                          color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
                          size: hasText ? 21 : 25,
                        ),
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
              height:
              MediaQuery.of(context).size.height * 0.35,
              checkPlatformCompatibility: true,
              emojiViewConfig: EmojiViewConfig(
                columns: 8,
                emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
              ),
              categoryViewConfig:
              CategoryViewConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white),
              bottomActionBarConfig:
              BottomActionBarConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white, buttonColor: ChatifyColors.transparent,),
              skinToneConfig: SkinToneConfig(dialogBackgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white),
              customBackspaceIcon: const Icon(Icons.backspace_outlined, size: 24, color: ChatifyColors.white),
            ),
          ),
      ],
    );
  }
}
