import 'dart:developer';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../data/emoji_data.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../home/controllers/emoji_stickers_controller.dart';
import '../../../home/widgets/input/search_text_input.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../dialogs/emoji_variant_dialog.dart';
import '../dialogs/light_dialog.dart';

class EmojiContentWidget extends StatefulWidget {
  final TextEditingController emojiController;
  final FocusNode focusNode;
  final EmojiStickersController controller;
  final ScrollController scrollController;
  final Function(String) onEmojiSelected;
  final GlobalKey categoryKey0;
  final GlobalKey categoryKey1;
  final GlobalKey categoryKey2;
  final GlobalKey categoryKey3;
  final GlobalKey categoryKey4;
  final GlobalKey categoryKey5;
  final GlobalKey categoryKey6;
  final GlobalKey categoryKey7;
  final GlobalKey categoryKey8;
  final double topPadding;

  const EmojiContentWidget({
    super.key,
    required this.emojiController,
    required this.focusNode,
    required this.controller,
    required this.scrollController,
    required this.onEmojiSelected,
    required this.categoryKey0,
    required this.categoryKey1,
    required this.categoryKey2,
    required this.categoryKey3,
    required this.categoryKey4,
    required this.categoryKey5,
    required this.categoryKey6,
    required this.categoryKey7,
    required this.categoryKey8,
    this.topPadding = 20,
  });

  @override
  State<EmojiContentWidget> createState() => _EmojiContentWidgetState();
}

class _EmojiContentWidgetState extends State<EmojiContentWidget> {

  void scrollToCategory(GlobalKey categoryKey, ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = categoryKey.currentContext;
      if (context == null) {
        return;
      }

      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero).dy;
      scrollController.animateTo(position, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchTextInput(
            hintText: S.of(context).searchForEmoticons,
            controller: widget.emojiController,
            focusNode: widget.focusNode,
            padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 12),
            showTooltip: false,
            backgroundColor: ChatifyColors.nightGrey,
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
              child: Scrollbar(
                thickness: 3,
                thumbVisibility: false,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          if (widget.controller.recentEmojis.isEmpty) {
                            return SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(S.of(context).recent, style: TextStyle(color: ChatifyColors.buttonGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                              ),
                              SizedBox(height: 6),
                              _buildEmojiRow(context, widget.controller, widget.categoryKey0, widget.onEmojiSelected),
                            ],
                          );
                        }),
                        _buildCategorySection(context, S.of(context).emoticonsPeople, peopleEmojis, widget.controller, widget.categoryKey1, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).animalsNature, animalEmojis, widget.controller, widget.categoryKey2, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).foodDrinks, foodEmojis, widget.controller, widget.categoryKey3, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).physicalActivity, sportEmojis, widget.controller, widget.categoryKey4, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).travelPlaces, travelPlacesEmojis, widget.controller, widget.categoryKey5, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).objects, objectsEmojis, widget.controller, widget.categoryKey6, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).symbols, symbolsEmojis, widget.controller, widget.categoryKey7, widget.onEmojiSelected),
                        _buildCategorySection(context, S.of(context).flags, flagsEmojis, widget.controller, widget.categoryKey8, widget.onEmojiSelected),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildEmojiPanel(context, widget.controller, widget.scrollController),
        ],
      ),
    );
  }

  Widget _buildEmojiRow(BuildContext context, EmojiStickersController controller, GlobalKey categoryKey, Function(String) onEmojiSelected) {
    return Obx(() {
      return Container(
        key: categoryKey,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.recentEmojis.length, (index) {
              final emoji = controller.recentEmojis[index];
              final isHovered = false.obs;
              final isPressed = false.obs;

              return Obx(() {
                final bool isSelected = controller.selectedEmojiInRow.value == emoji;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: MouseRegion(
                    onEnter: (_) => isHovered.value = true,
                    onExit: (_) => isHovered.value = false,
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        onTapDown: (_) => isPressed.value = true,
                        onTapUp: (_) => isPressed.value = false,
                        onTapCancel: () => isPressed.value = false,
                        onTap: () {
                          controller.selectEmojiInRow(emoji);
                          onEmojiSelected(emoji);
                        },
                        mouseCursor: SystemMouseCursors.basic,
                        borderRadius: BorderRadius.circular(6),
                        splashColor: ChatifyColors.transparent,
                        highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: Transform.scale(
                          scale: isPressed.value ? 0.96 : 1.0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)
                                  : null,
                              color: isSelected
                                  ? (isPressed.value || isHovered.value
                                  ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt())
                                  : colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()))
                                  : (isPressed.value || isHovered.value
                                  ? ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())
                                  : ChatifyColors.transparent),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              emoji,
                              style: TextStyle(
                                fontSize: 26,
                                color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildCategorySection(BuildContext context, String title, List<String> emojis, EmojiStickersController controller, GlobalKey categoryKey, Function(String) onEmojiSelected) {
    double topPadding = title == S.of(context).emoticonsPeople ? 0 : widget.topPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, top: topPadding),
          child: Text(title, style: TextStyle(color: ChatifyColors.buttonGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
        ),
        SizedBox(height: 5),
        Container(
          key: categoryKey,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            children: List.generate(emojis.length, (index) {
              String emoji = emojis[index];
              final bool isSelected = controller.selectedEmojiInCategory.value == emoji;

              if (isSelected) {
                log("${S.of(context).selectedColor}: ${colorsController.getColor(colorsController.selectedColorScheme.value)}");
              }

              return Builder(
                builder: (emojiContext) {
                  final isHovered = false.obs;
                  final isPressed = false.obs;

                  return Obx(() {
                    final bool isSelected = controller.selectedEmojiInCategory.value == emoji;

                    return MouseRegion(
                      onEnter: (_) => isHovered.value = true,
                      onExit: (_) => isHovered.value = false,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          onTapDown: (_) => isPressed.value = true,
                          onTapUp: (_) => isPressed.value = false,
                          onTapCancel: () => isPressed.value = false,
                          onTap: () {
                            controller.selectEmojiInCategory(emoji);

                            if (peopleEmojisVariants.containsKey(emoji)) {
                              showEmojiVariantDialog(
                                emojiContext: emojiContext,
                                overlayContext: context,
                                baseEmoji: emoji,
                                onVariantSelected: (variant) {
                                  controller.addRecentEmoji(variant);
                                  onEmojiSelected(variant);
                                },
                              );
                            } else {
                              controller.addRecentEmoji(emoji);
                              onEmojiSelected(emoji);
                            }
                          },
                          mouseCursor: SystemMouseCursors.basic,
                          borderRadius: BorderRadius.circular(6),
                          splashColor: ChatifyColors.transparent,
                          highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                          child: Transform.scale(
                            scale: isPressed.value ? 0.96 : 1.0,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                border: isSelected ? Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2) : null,
                                color: isSelected
                                    ? (isPressed.value || isHovered.value
                                    ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt())
                                    : colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()))
                                    : (isPressed.value || isHovered.value
                                    ? ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())
                                    : ChatifyColors.transparent),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                emoji,
                                style: TextStyle(
                                  fontSize: 26,
                                  color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiPanel(BuildContext context, EmojiStickersController controller, ScrollController scrollController) {
    final RxList<bool> hoverStates = List.generate(9, (_) => false).obs;
    GlobalKey categoryKey0 = GlobalKey();
    GlobalKey categoryKey1 = GlobalKey();
    GlobalKey categoryKey2 = GlobalKey();
    GlobalKey categoryKey3 = GlobalKey();
    GlobalKey categoryKey4 = GlobalKey();
    GlobalKey categoryKey5 = GlobalKey();
    GlobalKey categoryKey6 = GlobalKey();
    GlobalKey categoryKey7 = GlobalKey();
    GlobalKey categoryKey8 = GlobalKey();

    return Container(
      decoration: BoxDecoration(
        color: (context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey).withAlpha((0.6 * 255).toInt()),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(9, (index) {
          final bool isHovered = hoverStates[index];
          final bool isSelected = controller.panelSelectedIndex.value == index;
          final Color iconColor = isSelected || isHovered ? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black) : ChatifyColors.darkGrey;

          List<Widget Function(Color)> icons = [
                (color) => Icon(Ionicons.time_outline, size: 18, color: color),
                (color) => Icon(Icons.emoji_emotions_outlined, size: 18, color: color),
                (color) => SvgPicture.asset(ChatifyVectors.animal, width: 18, color: color),
                (color) => Icon(FluentIcons.food_pizza_20_regular, size: 18, color: color),
                (color) => Transform.rotate(angle: -0.5, child: Iconoir(Iconoir.basketball, width: 18, color: color)),
                (color) => Icon(PhosphorIcons.car, size: 18, color: color),
                (color) => Icon(FluentIcons.lightbulb_filament_20_regular, size: 18, color: color),
                (color) => Icon(FluentIcons.symbols_20_regular, size: 18, color: color),
                (color) => Icon(FluentIcons.flag_20_regular, size: 18, color: color),
          ];

          return MouseRegion(
            onEnter: (_) => hoverStates[index] = true,
            onExit: (_) => hoverStates[index] = false,
            child: GestureDetector(
              onTap: () {
                controller.panelSelectedIndex.value = index;
                switch (index) {
                  case 0: scrollToCategory(categoryKey0, scrollController); break;
                  case 1: scrollToCategory(categoryKey1, scrollController); break;
                  case 2: scrollToCategory(categoryKey2, scrollController); break;
                  case 3: scrollToCategory(categoryKey3, scrollController); break;
                  case 4: scrollToCategory(categoryKey4, scrollController); break;
                  case 5: scrollToCategory(categoryKey5, scrollController); break;
                  case 6: scrollToCategory(categoryKey6, scrollController); break;
                  case 7: scrollToCategory(categoryKey7, scrollController); break;
                  case 8: scrollToCategory(categoryKey8, scrollController); break;
                }
              },
              child: icons[index](iconColor),
            ),
          );
        }),
      ),
      ),
    );
  }
}
