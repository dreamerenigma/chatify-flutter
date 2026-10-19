import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/dividers/custom_vertical_divider.dart';

class EmojiModeBottomBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onModeSelected;
  final VoidCallback? onBackspace;
  final VoidCallback? onSearch;

  const EmojiModeBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onModeSelected,
    this.onBackspace,
    this.onSearch,
  });

  @override
  State<EmojiModeBottomBar> createState() => _EmojiModeBottomBarState();
}

class _EmojiModeBottomBarState extends State<EmojiModeBottomBar> {
  IconData? get rightIcon {
    switch (widget.selectedIndex) {
      case 0:
        return Icons.backspace_outlined;
      case 1:
        return null;
      case 2:
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? ChatifyColors.nightGrey : ChatifyColors.white;
    final borderColor = isDark ? ChatifyColors.lightSoftNight : ChatifyColors.lightGrey;

    return Container(
      height: 30,
      margin: EdgeInsets.zero,
      color: backgroundColor,
      child: Row(
        children: [
          IconButton(onPressed: widget.onSearch,  icon: Icon(Icons.search_rounded, size: 25), splashRadius: 20,  tooltip: widget.selectedIndex == 0 ? 'Поиск эмодзи' : 'Поиск стикеров'),
          const Spacer(),
          Container(
            decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(35)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeButton(
                  context: context,
                  index: 0,
                  icon: const Icon(Icons.emoji_emotions_outlined, size: 27),
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onModeSelected(0),
                ),
                CustomVerticalDivider(height: 36, thickness: 1, color: borderColor),
                _buildModeButton(
                  context: context,
                  index: 1,
                  icon: SvgPicture.asset(ChatifyVectors.gif, width: 23, height: 23, colorFilter: ColorFilter.mode(_iconColor(context, 1, widget.selectedIndex), BlendMode.srcIn)),
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onModeSelected(1),
                ),
                CustomVerticalDivider(height: 36, thickness: 1, color: borderColor),
                _buildModeButton(
                  context: context,
                  index: 2,
                  icon: SvgPicture.asset(
                    ChatifyVectors.sticker,
                    width: 27,
                    height: 27,
                    colorFilter: ColorFilter.mode(_iconColor(context, 2, widget.selectedIndex), BlendMode.srcIn),
                  ),
                  selectedIndex: widget.selectedIndex,
                  onTap: () => widget.onModeSelected(2),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (rightIcon != null)
            IconButton(onPressed: widget.onBackspace, icon: Icon(Icons.backspace_outlined, size: 21), splashRadius: 20)
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Color _iconColor(BuildContext context, int index, int selectedIndex) {
    if (index == selectedIndex) {
      return Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black;
    }

    return ChatifyColors.darkGrey;
  }

  Widget _buildModeButton({required BuildContext context, required int index, required Widget icon, required int selectedIndex, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = index == selectedIndex;
    final selectedColor = isDark ? ChatifyColors.youngNight : ChatifyColors.lightGrey;
    final hoverColor = isDark ? ChatifyColors.lightSoftNight : ChatifyColors.lightGrey;

    final borderRadius = switch (index) {
      0 => const BorderRadius.horizontal(left: Radius.circular(30)),
      1 => BorderRadius.zero,
      2 => const BorderRadius.horizontal(right: Radius.circular(30)),
      _ => BorderRadius.zero,
    };

    return Tooltip(
      message: const ['Эмодзи', 'GIF', 'Стикеры'][index],
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          hoverColor: hoverColor.withValues(alpha: 0.65),
          splashColor: hoverColor.withValues(alpha: 0.8),
          highlightColor: hoverColor.withValues(alpha: 0.5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            width: 62,
            height: 36,
            decoration: BoxDecoration(color: selected ? selectedColor : Colors.transparent, borderRadius: borderRadius),
            child: Center(child: IconTheme(data: IconThemeData(size: 20, color: _iconColor(context, index, selectedIndex)), child: icon)),
          ),
        ),
      ),
    );
  }
}
