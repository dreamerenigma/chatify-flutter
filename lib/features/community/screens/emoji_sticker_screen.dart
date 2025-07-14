import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

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

  final List<Color> _colors = [
    Colors.red[200]!,
    Colors.orange[100]!,
    Colors.yellow[200]!,
    Colors.green[100]!,
    Colors.blue[100]!,
    Colors.indigo[100]!,
    Colors.purple[100]!,
    Colors.deepPurple[200]!,
    Colors.pink[100]!,
    Colors.cyan[100]!,
    Colors.brown[100]!,
    Colors.blueGrey[100]!,
  ];

  @override
  void initState() {
    super.initState();
    if (_colors.contains(widget.initialColor)) {
      _selectedColor = widget.initialColor;
    } else {
      _selectedColor = _colors.first;
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
        title: Text('Emoji Picker', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
              width: 160.0,
              height: 160.0,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Center(
                child: Text(
                  _selectedEmoji,
                  style: TextStyle(fontSize: 100, color: ChatifyColors.black),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Container(
            margin: const EdgeInsets.all(16.0),
            height: 50.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _colors.map((color) {
                bool isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                        color: Colors.black,
                        width: 2.0,
                      )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: EmojiPicker(
                config: Config(
                  height: MediaQuery.of(context).size.height * 0.35,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 8,
                    emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                  ),
                  categoryViewConfig: const CategoryViewConfig(),
                  bottomActionBarConfig: const BottomActionBarConfig(),
                  skinToneConfig: const SkinToneConfig(),
                ),
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _selectedEmoji = emoji.emoji;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
