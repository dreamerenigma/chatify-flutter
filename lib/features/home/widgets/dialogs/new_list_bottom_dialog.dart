import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void newListBottomSheetDialog(BuildContext context) {
  final FocusNode focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();
  bool isButtonActive = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool showEmoji = false;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(focusNode);
          });

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

          textController.addListener(() {
            isButtonActive = textController.text.isNotEmpty;
          });

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.91,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(30),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        child: Icon(Icons.close),
                      ),
                      Text(S.of(context).newList, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 25),
                  Text(S.of(context).listTitle, style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
                  SizedBox(height: 6),
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
                            focusNode: focusNode,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: S.of(context).examples,
                              hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      InkWell(
                        onTap: toggleEmojiKeyboard,
                        child: Icon(showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 26),
                      ),
                    ],
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
                  SizedBox(height: 20),
                  Text(S.of(context).listCreateFilterChatsTab, style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      onPressed: isButtonActive ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonActive ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: 13),
                        minimumSize: Size(double.infinity, 0),
                        side: BorderSide.none,
                      ),
                      child: Text(S.of(context).addPeopleOrGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: isButtonActive ? ChatifyColors.black : ChatifyColors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  );
}
