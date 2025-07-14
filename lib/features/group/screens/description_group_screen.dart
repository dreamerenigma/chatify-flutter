import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
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
        title: Text('Описание группы', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _editDescription(context),
              _textDescription(),
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
        ],
      ),
    );
  }

  Widget _editDescription(BuildContext context) {
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
                  hintText: 'Добавьте описание группы',
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

  Widget _textDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Описание группы видно всем ее участникам, а также приглашенным в группу пользователям.',
        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
      ),
    );
  }

  Widget _buildButton() {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              splashColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              highlightColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              child: Container(
                height: 50,
                decoration: const BoxDecoration(border: Border(
                  top: BorderSide(color: ChatifyColors.popupColor, width: 1),
                  left: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                )),
                child: Center(child: Text('Отмена', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value)))),
              ),
            ),
          ),
        ),
        Expanded(
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {

              },
              splashColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              highlightColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              child: Container(
                height: 50,
                decoration: const BoxDecoration(border: Border(
                  top: BorderSide(color: ChatifyColors.popupColor, width: 1),
                  left: BorderSide(color: ChatifyColors.popupColor, width: 1),
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                )),
                child: Center(child: Text('ОК', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value)))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
