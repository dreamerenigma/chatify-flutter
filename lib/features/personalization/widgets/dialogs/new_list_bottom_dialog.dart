import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import 'light_dialog.dart';

void showNewListBottomSheet(BuildContext context) {
  final TextEditingController textController = TextEditingController();
  final focusNode = FocusNode();
  bool isButtonActive = false;

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
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

          textController.addListener(() {
            setState(() {
              isButtonActive = textController.text.isNotEmpty;
            });
          });

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Новый список',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.normal,),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Название списка',
                      style: TextStyle(
                        color: ChatifyColors.darkGrey,
                        fontWeight: FontWeight.normal,
                        fontSize: ChatifySizes.fontSizeSm,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                hintText: 'Примеры: "Работа", "Друзья"',
                                hintStyle: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.normal),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                contentPadding: const EdgeInsets.only(top: 12),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: IconButton(
                            onPressed: toggleEmojiKeyboard,
                            icon: Icon(showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 26),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text(
                      'Любой созданный вами список становится фильтром в верхней части вкладки "Чаты".',
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isButtonActive
                          ? () {
                        }
                          : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonActive
                            ? colorsController.getColor(colorsController.selectedColorScheme.value)
                            : colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.4 * 255).toInt()),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 8)
                        ),
                        child: Text(
                          'Добавить людей или группы',
                          style: TextStyle(
                            color: isButtonActive ? Colors.white : ChatifyColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                            fontWeight: FontWeight.normal,
                            fontSize: ChatifySizes.fontSizeMd,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
