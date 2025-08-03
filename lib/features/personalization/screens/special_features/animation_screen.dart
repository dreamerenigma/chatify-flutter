import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class StorageKeys {
  static const emoji = 'animation_emoji';
  static const sticker = 'animation_sticker';
  static const gif = 'animation_gif';
}

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  final storageBox = GetStorage();
  late bool isEmojiEnabled;
  late bool isStickerEnabled;
  late bool isGifEnabled;

  @override
  void initState() {
    super.initState();
    isEmojiEnabled = storageBox.read(StorageKeys.emoji) ?? true;
    isStickerEnabled = storageBox.read(StorageKeys.sticker) ?? false;
    isGifEnabled = storageBox.read(StorageKeys.gif) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(S.of(context).subtitleSpecialFeatures, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      _buildAnimationOption(context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(S.of(context).animationEnabledEmojisStickersAuto, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.2)),
          const SizedBox(height: 20),
          _buildSwitchTile(
            icon: Icons.emoji_emotions_outlined,
            text: S.of(context).emoticons,
            switchValue: isEmojiEnabled,
            onChanged: (val) {
              setState(() => isEmojiEnabled = val);
              storageBox.write(StorageKeys.emoji, val);
            },
          ),
          const SizedBox(height: 18),
          _buildSwitchTile(
            icon: PhosphorIcons.sticker,
            text: S.of(context).stickers,
            switchValue: isStickerEnabled,
            onChanged: (val) {
              setState(() => isStickerEnabled = val);
              storageBox.write(StorageKeys.sticker, val);
            },
          ),
          const SizedBox(height: 18),
          _buildSwitchTile(
            icon: FluentIcons.gif_16_regular,
            text: S.of(context).gif,
            switchValue: isGifEnabled,
            onChanged: (val) {
              setState(() => isGifEnabled = val);
              storageBox.write(StorageKeys.gif, val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String text,
    required bool switchValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd))),
        CustomSwitch(
          value: switchValue,
          onChanged: onChanged,
          switchWidth: 50,
          switchHeight: 31,
          thumbSize: 21,
          thumbPadding: 5,
        ),
      ],
    );
  }
}
