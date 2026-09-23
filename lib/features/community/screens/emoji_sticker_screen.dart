import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class EmojiStickerScreen extends StatefulWidget {
  final Color initialColor;
  final String initialEmoji;

  const EmojiStickerScreen({
    super.key,
    required this.initialColor,
    required this.initialEmoji,
  });

  @override
  EmojiStickerScreenState createState() => EmojiStickerScreenState();
}

class EmojiStickerScreenState extends State<EmojiStickerScreen> {
  late Color _selectedColor;
  late String _selectedEmoji;

  @override
  void initState() {
    super.initState();
    if (ChatifyColors.colors.contains(widget.initialColor)) {
      _selectedColor = widget.initialColor;
    } else {
      _selectedColor = ChatifyColors.colors.first;
    }
    _selectedEmoji = widget.initialEmoji;
  }

  void _confirmSelection() {
    Navigator.pop(context, {'color': _selectedColor, 'emoji': _selectedEmoji});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).emojiPicker, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        actions: [
          if (_selectedEmoji.isNotEmpty)
            IconButton(icon: const Icon(Icons.check), onPressed: _confirmSelection),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: AppBar().preferredSize.height),
              width: 170,
              height: 170,
              decoration: BoxDecoration(color: _selectedColor, borderRadius: BorderRadius.circular(35)),
              child: Center(child: Text(_selectedEmoji, style: TextStyle(fontSize: 100, color: ChatifyColors.black))),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 50,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ChatifyColors.colors.map((color) {
                  bool isSelected = _selectedColor == color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: isSelected ? Border.all(color: _selectedColor, width: 1.3) : null),
                      padding: const EdgeInsets.all(2),
                      child: Container(decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: EmojiPicker(
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
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _selectedEmoji = emoji.emoji;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
