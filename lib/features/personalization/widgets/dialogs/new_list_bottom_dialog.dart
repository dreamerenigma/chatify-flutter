import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import 'light_dialog.dart';

void showNewListBottomSheet(BuildContext context) {
  final TextEditingController textController = TextEditingController();
  final focusNode = FocusNode();
  bool isButtonActive = false;
  bool showEmojiPicker = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (showEmojiPicker) {
              FocusScope.of(context).unfocus();
            } else {
              FocusScope.of(context).requestFocus(focusNode);
            }
          });

          void toggleEmojiKeyboard() {
            if (showEmojiPicker) {
              FocusScope.of(context).requestFocus(focusNode);
            } else {
              FocusScope.of(context).unfocus();
            }

            Future.microtask(() {
              setState(() {
                showEmojiPicker = !showEmojiPicker;
              });
            });
          }

          textController.addListener(() {
            setState(() {
              isButtonActive = textController.text.isNotEmpty;
            });
          });

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: const Icon(Icons.close, size: 24), onPressed: () => Navigator.pop(context)),
                          Expanded(
                            child: Text(S.of(context).newList, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.normal)),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(S.of(context).listTitle, style: TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.normal, fontSize: ChatifySizes.fontSizeLm)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).examplesWorkFriends,
                                    hintStyle: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.normal),
                                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  textCapitalization: TextCapitalization.sentences,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 12),
                              child: InkWell(
                                onTap: toggleEmojiKeyboard,
                                borderRadius: BorderRadius.circular(30),
                                splashFactory: NoSplash.splashFactory,
                                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Text(
                          S.of(context).listCreateFilterChats,
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showEmojiPicker)
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.infinity,
                    child: EmojiPicker(
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
                  ),
                ),
                if (!showEmojiPicker)
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  left: 16,
                  right: 16,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isButtonActive ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonActive
                          ? colorsController.getColor(colorsController.selectedColorScheme.value)
                          : colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.4 * 255).toInt()),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        S.of(context).addPeopleOrGroups,
                        style: TextStyle(
                          color: isButtonActive ? ChatifyColors.black : ChatifyColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                          fontWeight: FontWeight.normal,
                          fontSize: ChatifySizes.fontSizeMd,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
