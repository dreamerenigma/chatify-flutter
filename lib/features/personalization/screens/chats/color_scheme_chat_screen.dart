import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';

class ColorSchemeChatScreen extends StatefulWidget {
  const ColorSchemeChatScreen({super.key});

  @override
  State<ColorSchemeChatScreen> createState() => _ColorSchemeChatScreenState();
}

class _ColorSchemeChatScreenState extends State<ColorSchemeChatScreen> {
  static final List<Color> appColors = List.generate(
    60, (index) {
      final color = HSVColor.fromAHSV(1.0, 110.0 + index * (180.0 / 59), 0.70, 0.75).toColor();

      return Color.lerp(color, ChatifyColors.black, 0.20)!;
    },
  );
  int? selectedColorIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            elevation: 0,
            title: Text('Цвет приложения', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            actions: [
              TooltipTheme(
                data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
                child: Theme(
                  data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                  child: PopupMenuButton<int>(
                    tooltip: S.of(context).more,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-8, 0),
                    menuPadding: EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(minWidth: 0, maxWidth: 300),
                    icon: const Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                        }
                        return ChatifyColors.transparent;
                      }),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                    ),
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          icon: Transform.flip(flipX: true, child: Icon(Icons.refresh, size: 27, color: ChatifyColors.darkGrey)),
                          text: 'Сбросить цвет приложения',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: GridView.builder(
            itemCount: appColors.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4),
            itemBuilder: (context, index) {
              final color = appColors[index];
              final isSelected = selectedColorIndex == index;

              return Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                        ? Border.all(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 1.5)
                        : Border.all(color: ChatifyColors.transparent, width: 2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: ChatifyColors.darkGrey.withAlpha(70), width: 1),
                      ),
                      child: isSelected ? const Center(child: Icon(Icons.check_circle_rounded, size: 25, color: ChatifyColors.white)) : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
