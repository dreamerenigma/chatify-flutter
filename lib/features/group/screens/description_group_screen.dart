import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../generated/l10n/l10n.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class DescriptionGroupScreen extends StatefulWidget {
  const DescriptionGroupScreen({super.key});

  @override
  State<DescriptionGroupScreen> createState() => _DescriptionGroupScreenState();
}

class _DescriptionGroupScreenState extends State<DescriptionGroupScreen> {
  bool showEmojiPicker = false;
  final FocusNode textFocusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).groupDescription, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildEditDescription(context),
              _buildTextDescription(),
              const Spacer(),
              _buildButton(),
            ],
          ),
          if (showEmojiPicker)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 250,
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
        ],
      ),
    );
  }

  Widget _buildEditDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      child: TextSelectionTheme(
        data: TextSelectionThemeData(
          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
          selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                focusNode: textFocusNode,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: S.of(context).addGroupDescription,
                  hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey),
                  border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                  isDense: true,
                  counterText: '',
                ),
                style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: ChatifySizes.fontSizeMd),
                onTap: () {
                  if (showEmojiPicker) {
                    setState(() {
                      showEmojiPicker = false;
                    });
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 26),
              onPressed: () {
                setState(() {
                  showEmojiPicker = !showEmojiPicker;
                  if (showEmojiPicker) {
                    textFocusNode.unfocus();
                  } else {
                    textFocusNode.requestFocus();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(S.of(context).groupDescriptionVisible, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
    );
  }

  Widget _buildButton() {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              highlightColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              hoverColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: const BoxDecoration(border: Border(
                  top: BorderSide(color: ChatifyColors.popupColor, width: 1),
                  left: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                )),
                child: Center(child: Text(S.of(context).cancel, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value)))),
              ),
            ),
          ),
        ),
        Expanded(
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              highlightColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              hoverColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              onTap: () {},
              child: Container(
                height: 50,
                decoration: const BoxDecoration(border: Border(
                  top: BorderSide(color: ChatifyColors.popupColor, width: 1),
                  left: BorderSide(color: ChatifyColors.popupColor, width: 1),
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                )),
                child: Center(child: Text(S.of(context).ok, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value)))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
