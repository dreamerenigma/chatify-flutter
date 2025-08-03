import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../common/widgets/switches/custom_switch.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/helper/auto_launch_helper.dart';
import '../../../../personalization/controllers/language_controller.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../select_language_dialog.dart';
import '../windows_settings_dialog.dart';

class GeneralOptionWidget extends StatefulWidget {
  final ValueNotifier<int> selectedIndexNotifier;

  const GeneralOptionWidget({super.key, required this.selectedIndexNotifier});

  @override
  GeneralOptionWidgetState createState() => GeneralOptionWidgetState();
}

class GeneralOptionWidgetState extends State<GeneralOptionWidget> {
  bool isInside = false;
  bool isAutoLaunchEnabled = false;
  bool isEmojiReplacementEnabled = false;
  bool isPressed = false;
  bool isTextEmojiListVisible = false;
  bool isSettingsWindows = false;
  bool isViewListTextEmoji = false;
  bool isViewProfile = false;
  bool isHovered = false;
  bool isLongPressed = false;
  final GetStorage storage = GetStorage();
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    isAutoLaunchEnabled = storage.read('is_auto_launch_enabled') ?? false;
    isEmojiReplacementEnabled = storage.read('is_emoji_replacement_enabled') ?? false;
    setState(() {});
  }

  void _saveSetting(String key, bool value) {
    storage.write(key, value);
  }

  void _toggleAnimation() {
    setState(() {
      isPressed = !isPressed;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isPressed = false;
      });
    });
  }

  void _onLongPress() {
    setState(() {
      isPressed = true;
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      isPressed = false;
    });
  }

  Future<void> checkAutoLaunchStatus() async {
    setState(() {
      isAutoLaunchEnabled = isAutoLaunchEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isTextEmojiListVisible ? _buildTextEmoji() : _buildGeneral();
  }

  Widget _buildGeneral() {
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
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            Text(S.of(context).general, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            Text(S.of(context).signIn, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    S.of(context).launchOnLogin,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                CustomTooltip(
                  message: S.of(context).enableThisOption,
                  verticalOffset: -115,
                  child: Row(
                    children: [
                      Opacity(
                        opacity: isAutoLaunchEnabled ? 1.0 : 0.5,
                        child: Text(isAutoLaunchEnabled ? S.of(context).on : S.of(context).off, style: TextStyle(color: context.isDarkMode ? ChatifyColors.iconGrey : ChatifyColors.grey, fontWeight: FontWeight.w300)),
                      ),
                      SizedBox(width: 12),
                      CustomSwitch(
                        value: isAutoLaunchEnabled,
                        onChanged: (bool value) async {
                          bool success = false;

                          if (value) {
                            await enableAutoLaunch(appName: S.of(context).appName);
                            success = isAutoLaunchEnabled;
                          } else {
                            await disableAutoLaunch(appName: S.of(context).appName);
                            success = !isAutoLaunchEnabled;
                          }

                          if (success) {
                            setState(() {
                              isAutoLaunchEnabled = value;
                            });
                            _saveSetting('is_auto_launch_enabled', isAutoLaunchEnabled);
                          }
                        },
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(S.of(context).languages, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  _toggleAnimation();
                  showSelectedLanguageDialog(context);
                },
                onLongPress: () {
                  setState(() {
                    isLongPressed = true;
                  });
                  _onLongPress.call();
                },
                onLongPressEnd: (_) {
                  setState(() {
                    isLongPressed = false;
                  });
                  _onLongPressEnd.call(_);
                },
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHovered = false;
                    });
                  },
                  child: Container(
                    height: 33,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isLongPressed
                        ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100))
                        : isHovered
                          ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                          : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                    ),
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(ChatifyVectors.language, width: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Obx(() {
                                  return Text(LanguageController.instance.getLanguageLabel(context), style: TextStyle(fontWeight: FontWeight.w400));
                                }),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(0, isPressed ? 2.0 : 0, 0),
                            child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 15, height: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(S.of(context).enter, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300)),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkerGrey, fontSize: 13, fontWeight: FontWeight.w300),
                children: [
                  TextSpan(text: S.of(context).changeInputSettings),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isSettingsWindows = true),
                      onExit: (_) => setState(() => isSettingsWindows = false),
                      child: GestureDetector(
                        onTap: () {
                          showWindowsSettingsDialog(context, "ms-settings:typing");
                        },
                        child: Text(
                          S.of(context).windowsSettings,
                          style: TextStyle(
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            decoration: isSettingsWindows ? TextDecoration.none : TextDecoration.underline,
                            decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: ".", style: TextStyle(color: ChatifyColors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).replacingTextEmoticons, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).textCombinationsReplaced,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(width: 12),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isEmojiReplacementEnabled ? "😁" : ":-D",
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: isEmojiReplacementEnabled ? ChatifySizes.fontSizeMd : ChatifySizes.fontSizeSm),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomSwitch(
                      value: isEmojiReplacementEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isEmojiReplacementEnabled = value;
                        });
                        _saveSetting('is_emoji_replacement_enabled', isEmojiReplacementEnabled);
                      },
                      activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            MouseRegion(
              onEnter: (_) => setState(() => isViewListTextEmoji = true),
              onExit: (_) => setState(() => isViewListTextEmoji = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isTextEmojiListVisible = true;
                  });
                },
                child: RichText(
                  text: TextSpan(
                    text: S.of(context).viewListTextSymbols,
                    style: TextStyle(
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      fontSize: ChatifySizes.fontSizeLm, decoration: isViewListTextEmoji ? TextDecoration.none : TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: S.of(context).to,
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkerGrey, fontSize: 13, fontWeight: FontWeight.w300),
                children: [
                  TextSpan(text: S.of(context).signOut, style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkerGrey, fontSize: 13, fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: S.of(context).onComputerGoYour,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkerGrey, fontSize: 13, fontWeight: FontWeight.w300),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isViewProfile  = true),
                      onExit: (_) => setState(() => isViewProfile  = false),
                      child: GestureDetector(
                        onTap: () {
                          widget.selectedIndexNotifier.value = 9;
                        },
                        child: Text(
                          S.of(context).profileLink,
                          style: TextStyle(
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            fontWeight: FontWeight.w400,
                            decoration: isViewProfile ? TextDecoration.none : TextDecoration.underline,
                            decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: ".", style: TextStyle(color: ChatifyColors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextEmoji() {
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
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isTextEmojiListVisible = false;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      child: Icon(Icons.arrow_back, size: 16),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Text(S.of(context).replacingTextEmoticons, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                SizedBox(height: 14),
                Text(
                  S.of(context).replacedEmoticonsYouType,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, height: 1.2),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: List.generate(10, (index) {
                        List<String> symbolList = [
                          '(y)', '(n)', ':-)', ':-(', ':-P', ';-P', '8-)', ':-D', ':-o', '^^',
                        ];

                        List<String> emojiList = [
                          "👍", "👎", "😊", "🙁", "😛", "😜", "😎", "😁", "😮️", "😙",
                        ];

                        String symbol = symbolList[index % symbolList.length];
                        String emoji = emojiList[index % emojiList.length];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                width: 35,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: ChatifyColors.transparent,
                                  border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(child: Text(symbol)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: HeroIcon(HeroIcons.arrowLongRight, size: 22),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                width: 35,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: ChatifyColors.transparent,
                                  border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(child: Text(emoji)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Column(
                      children: List.generate(10, (index) {
                        List<String> symbolList = [
                          '(Y)', '(N)', ';-)', ':-p', ';-p', ':-|', ':-\\', ':-*', '<3', ':-o',
                        ];

                        List<String> emojiList = [
                          "👍", "👎", "😉", "😛", "😜", "😐", "😕", "😘", "❤️", "😧",
                        ];

                        String symbol = symbolList[index % symbolList.length];
                        String emoji = emojiList[index % emojiList.length];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                width: 35,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: ChatifyColors.transparent,
                                  border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(child: Text(symbol)),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: HeroIcon(HeroIcons.arrowLongRight, size: 22)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                width: 35,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: ChatifyColors.transparent,
                                  border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(child: Text(emoji)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
