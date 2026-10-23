import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../icons/press_scale_icon.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;
  final int unreadChatsCount;
  final int missedCallsCount;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.unreadChatsCount = 0,
    this.missedCallsCount = 0,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int? pressedIndex;
  Timer? _longPressTimer;

  Color _iconColor(BuildContext context, int index) {
    if (widget.selectedIndex == index) {
      return colorsController.getSelectedColor(colorsController.selectedColorScheme.value);
    }

    return context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black;
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
          border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey, width: 1)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: ChatifyColors.transparent,
            hoverColor: ChatifyColors.transparent,
          ),
          child: Row(
            children: [
              _buildNavItem(
                context,
                index: 0,
                label: S.of(context).chats,
                iconWidget: _buildIconWithBadge(
                  count: widget.unreadChatsCount,
                  icon: SvgPicture.asset(
                    widget.selectedIndex == 0 ? ChatifyVectors.chats : ChatifyVectors.chatsRegular,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(_iconColor(context, 0), BlendMode.srcIn),
                  ),
                ),
              ),
              _buildNavItem(
                context,
                index: 1,
                label: 'Актуальное',
                iconWidget: SvgPicture.asset(
                  widget.selectedIndex == 1 ? ChatifyVectors.updatesFilled : ChatifyVectors.updatesOutline,
                  key: ValueKey('status-${widget.selectedIndex}'),
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(_iconColor(context, 1), BlendMode.srcIn),
                ),
              ),
              _buildNavItem(
                context,
                index: 2,
                label: S.of(context).community,
                iconWidget: Icon(widget.selectedIndex == 2 ? Icons.groups : Icons.groups_outlined, size: 28, color: _iconColor(context, 2)),
              ),
              _buildNavItem(
                context,
                index: 3,
                label: S.of(context).calls,
                iconWidget: _buildIconWithBadge(
                  count: widget.missedCallsCount,
                  icon: Icon(widget.selectedIndex == 3 ? Icons.call : Icons.call_outlined, color: _iconColor(context, 3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required int index, required String label, required Widget iconWidget}) {
    final bool isSelected = widget.selectedIndex == index;
    final bool isPressed = pressedIndex == index && !isSelected;
    final selectedColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onItemTapped(index),
        onLongPressStart: (_) {
          if (!isSelected) {
            setState(() => pressedIndex = index);
          }
        },
        onLongPressEnd: (_) {
          if (pressedIndex == index) {
            setState(() => pressedIndex = null);
          }
        },
        onLongPressCancel: () {
          if (pressedIndex == index) {
            setState(() => pressedIndex = null);
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor.withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  child: PressScaleIcon(
                    pressedColor: colorsController.getSelectedColor(colorsController.selectedColorScheme.value),
                    scale: 0.93,
                    isPressed: isPressed,
                    child: iconWidget,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? colorsController.getSelectedColor(colorsController.selectedColorScheme.value) : (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithBadge({required Widget icon, required int count}) {
    if (count <= 0) return icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          top: -5,
          right: -7,
          child: Container(
            constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value,), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: ChatifyColors.black, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}
