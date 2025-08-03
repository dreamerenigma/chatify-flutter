import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';

class HotKeysOptionWidget extends StatefulWidget {
  const HotKeysOptionWidget({super.key});

  @override
  State<HotKeysOptionWidget> createState() => _HotKeysOptionWidgetState();
}

class _HotKeysOptionWidgetState extends State<HotKeysOptionWidget> {
  final ScrollController scrollController = ScrollController();
  bool isInside = false;
  List<Widget> rows = [];
  List<String> actions = [S.current.newChat, S.current.closeChat, S.current.closeChat, S.current.closeApp, S.current.newGroup, S.current.search, S.current.searchInChat,
    S.current.profile, S.current.muteChat, S.current.markAsReadUnread, S.current.emojiPanel, S.current.gifPanel, S.current.stickerPanel,
    S.current.previousChat, S.current.nextChat, S.current.previousChat, S.current.nextChat, S.current.openChat, S.current.editLastMessage,
    S.current.decreaseFontSize, S.current.increaseFontSize, S.current.resetFontSize,
  ];

  List<List<String>> hotkeys = [
    ["Ctrl", "N"],
    ["Ctrl", "W"],
    ["Ctrl", "F4"],
    ["Alt", "F4"],
    ["Ctrl", "Shift", "N"],
    ["Ctrl", "F"],
    ["Ctrl", "Shift", "F"],
    ["Ctrl", "P"],
    ["Ctrl", "Shift", "M"],
    ["Ctrl", "Shift", "U"],
    ["Ctrl", "Shift", "E"],
    ["Ctrl", "Shift", "G"],
    ["Ctrl", "Shift", "S"],
    ["Ctrl", "Shift", "["],
    ["Ctrl", "Shift", "]"],
    ["Ctrl", "Shift", "Tab"],
    ["Ctrl", "Tab"],
    ["Ctrl", "1..9"],
    ["Ctrl", "↑"],
    ["Ctrl", "-"],
    ["Ctrl", "+"],
    ["Ctrl", "0"],
  ];

  @override
  Widget build(BuildContext context) {
    rows.clear();

    for (var i = 0; i < hotkeys.length; i++) {
    List<Widget> rowItems = [];

    for (var j = 0; j < hotkeys[i].length; j++) {
      rowItems.add(
        Container(
          height: 35,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1), borderRadius: BorderRadius.circular(4)),
          child: Text(hotkeys[i][j], style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
        ),
      );

      if (j != hotkeys[i].length - 1) {
        rowItems.add(SizedBox(width: 10));
      }
    }

    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(actions[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
          ),
          SizedBox(width: 10),
          ...rowItems,
        ],
      ),
    );

    rows.add(SizedBox(height: 15));
  }

  return CustomScrollbar(
    scrollController: scrollController,
    isInsidePersonalizedOption: isInside,
    onHoverChange: (bool isHovered) {
      setState(() {
        isInside = isHovered;
      });
    },
    child: ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).hotKeys, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
              const SizedBox(height: 25),
              Text(S.of(context).keyboardShortcuts, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
              const SizedBox(height: 15),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
              const SizedBox(height: 25),
              Text(S.of(context).quickEmoticons, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
              const SizedBox(height: 25),
              Text(S.of(context).typingMessageUseColonSymbol, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(S.of(context).cat, style: TextStyle(fontSize: 13)),
                  SizedBox(width: 10),
                  Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(":", style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  ),
                  SizedBox(width: 8),
                  HeroIcon(HeroIcons.arrowLongRight, size: 24, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  SizedBox(width: 8),
                  Container(
                    width: 69,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(':${S.of(context).cat.toLowerCase()}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  ),
                  SizedBox(width: 10),
                  SvgPicture.asset(ChatifyVectors.twoLineHorizontal, width: 21, height: 21, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  SizedBox(width: 10),
                  Container(
                    width: 38,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("😺", style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(S.of(context).hat, style: TextStyle(fontSize: 13)),
                  SizedBox(width: 10),
                  Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1), borderRadius: BorderRadius.circular(4)),
                    child: Text(":", style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  ),
                  SizedBox(width: 8),
                  HeroIcon(HeroIcons.arrowLongRight, size: 24, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  SizedBox(width: 8),
                  Container(
                    width: 69,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1), borderRadius: BorderRadius.circular(4)),
                    child: Text(':${S.of(context).hat.toLowerCase()}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  ),
                  SizedBox(width: 10),
                  SvgPicture.asset(ChatifyVectors.twoLineHorizontal, width: 21, height: 21, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  SizedBox(width: 10),
                  Container(
                    width: 38,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()), width: 1), borderRadius: BorderRadius.circular(4)),
                    child: Text("🎩", style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
