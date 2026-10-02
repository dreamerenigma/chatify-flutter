import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../personalization/controllers/colors_controller.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;
  final int unreadChatsCount;
  final int missedCallsCount;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.unreadChatsCount = 0,
    this.missedCallsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    log('[BOTTOM NAV] unreadChatsCount = $unreadChatsCount');

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: context.isDarkMode ? ChatifyColors.white.withAlpha((0.2 * 255).toInt()) : ChatifyColors.black.withAlpha((0.2 * 255).toInt()), blurRadius: 4, spreadRadius: 2, offset: Offset(0, 4),)],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            _buildBottomNavigationBarItem(
              context,
              colorsController: colorsController,
              iconWidget: _buildIconWithBadge(
                count: unreadChatsCount,
                icon: SvgPicture.asset(
                  selectedIndex == 0 ? ChatifyVectors.chats : ChatifyVectors.chatsRegular,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    selectedIndex == 0 ? ChatifyColors.greenMessageBubbleRecipient : (context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: S.of(context).chats,
              index: 0,
            ),
            _buildBottomNavigationBarItem(
              context,
              colorsController: colorsController,
              iconWidget: SvgPicture.asset(
                ChatifyVectors.status,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  selectedIndex == 1 ? ChatifyColors.greenMessageBubbleRecipient : (context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black),
                  BlendMode.srcIn,
                ),
              ),
              label: S.of(context).status,
              index: 1,
            ),
            _buildBottomNavigationBarItem(
              context,
              colorsController: colorsController,
              iconWidget: Icon(
                selectedIndex == 2 ? Icons.groups : Icons.groups_outlined, size: 28,
                color: selectedIndex == 2 ? ChatifyColors.greenMessageBubbleRecipient : (context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black),
              ),
              label: S.of(context).community,
              index: 2,
            ),
            _buildBottomNavigationBarItem(
              context,
              colorsController: colorsController,
              iconWidget: _buildIconWithBadge(
                count: missedCallsCount,
                icon: Icon(selectedIndex == 3 ? Icons.call : Icons.call_outlined,
                color: selectedIndex == 3 ? ChatifyColors.greenMessageBubbleRecipient : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              ),
              label: S.of(context).calls,
              index: 3,
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: ChatifyColors.greenMessageBubbleRecipient,
          unselectedItemColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
          selectedLabelStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
          onTap: onItemTapped,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context, {
    required ColorsController colorsController,
    required Widget iconWidget,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedIndex == index;

    final backgroundColor = isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent;
    final tooltipColor = context.isDarkMode
      ? (isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()) : ChatifyColors.blackGrey)
      : (isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()) : ChatifyColors.grey);

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Tooltip(
          message: label,
          decoration: BoxDecoration(color: tooltipColor, borderRadius: BorderRadius.circular(4)),
          textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          child: Container(
            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            child: iconWidget,
          ),
        ),
      ),
      label: label,
      tooltip: '',
    );
  }

  Widget _buildIconWithBadge({required Widget icon, required int count}) {
    if (count <= 0) {
      return icon;
    }

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
            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: ChatifyColors.black, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}
