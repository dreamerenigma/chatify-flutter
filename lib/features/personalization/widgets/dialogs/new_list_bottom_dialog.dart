import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/lists/add_to_list_screen.dart';
import 'light_dialog.dart';

void showNewListBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) {
      return const NewListBottomSheet();
    },
  );
}

class NewListBottomSheet extends StatefulWidget {
  const NewListBottomSheet({super.key});

  @override
  State<NewListBottomSheet> createState() => _NewListBottomSheetState();
}

class _NewListBottomSheetState extends State<NewListBottomSheet> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();
  bool isButtonActive = false;
  bool showEmoji = false;

  @override
  void initState() {
    super.initState();
    textController.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNode.requestFocus();
      }
    });
  }

  void _onTextChanged() {
    setState(() {
      isButtonActive = textController.text.trim().isNotEmpty;
    });
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
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = colorsController.getColor(colorsController.selectedColorScheme.value);

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
                            cursorColor: primaryColor,
                            selectionColor: primaryColor.withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: primaryColor,
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
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
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
                            child: Icon(showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 26),
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
          if (showEmoji)
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                child: EmojiPicker(
                  textEditingController: textController,
                  config: Config(
                    height: MediaQuery.of(context).size.height * 0.35,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      columns: 8,
                      emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                      backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
                    ),
                    categoryViewConfig: CategoryViewConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white),
                    bottomActionBarConfig: BottomActionBarConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white, buttonColor: ChatifyColors.transparent),
                    skinToneConfig: SkinToneConfig(dialogBackgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white),
                    customBackspaceIcon: Icon(Icons.backspace_outlined, size: 24, color: ChatifyColors.white),
                  ),
                ),
              ),
            ),
          if (!showEmoji)
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isButtonActive ? () {
                    Navigator.push(context, createPageRoute(AddToListScreen(user: APIs.me)));
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonActive ? primaryColor : primaryColor.withAlpha((0.4 * 255).toInt()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    S.of(context).addPeopleOrGroups,
                    style: TextStyle(color: isButtonActive ? ChatifyColors.black : ChatifyColors.darkGrey.withAlpha((0.4 * 255).toInt()), fontWeight: FontWeight.normal, fontSize: ChatifySizes.fontSizeMd),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
