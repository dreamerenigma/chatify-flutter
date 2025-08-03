import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/popups/dialogs.dart';
import 'light_dialog.dart';

void showAddIntelligenceBottomSheet(BuildContext context, String initialText, void Function(String) onSave) {
  final FocusNode focusNode = FocusNode();
  final TextEditingController textController = TextEditingController(text: initialText);
  const int maxCharacters = 139;

  Future.microtask(() {
    focusNode.requestFocus();
    textController.selection = TextSelection(baseOffset: 0, extentOffset: initialText.length);
  });

  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      bool showEmoji = false;

      return StatefulBuilder(
        builder: (context, setState) {

          void toggleEmojiKeyboard() {
            if (showEmoji) {
              focusNode.requestFocus();
            } else {
              focusNode.unfocus();
            }

            Future.microtask(() {
              setState(() {
                showEmoji = !showEmoji;
              });
            });
          }

          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(S.of(context).addDetails, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
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
                              maxLength: maxCharacters,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                (context as Element).markNeedsBuild();
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: const EdgeInsets.only(bottom: 6, right: 4),
                                border: const UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                                suffix: textController.text.isEmpty ? null : Text(
                                  '${maxCharacters - textController.text.length}',
                                  style: TextStyle(fontSize: 12, color: maxCharacters - textController.text.length >= 0 ? ChatifyColors.grey : ChatifyColors.red),
                                ),
                              ),
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: toggleEmojiKeyboard,
                          icon: Icon(showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 26),
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
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await Future.delayed(const Duration(milliseconds: 300));
                            await Dialogs.showCustomDialog(context: context, message: S.of(context).update, duration: const Duration(seconds: 1));
                            onSave(textController.text);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).save, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      );
    },
  );
}
