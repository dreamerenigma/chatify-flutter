import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/controllers/colors_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode ? ChatifyColors.white.withAlpha((0.2 * 255).toInt()) : ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
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
              iconWidget: SvgPicture.asset(
                selectedIndex == 0 ? ChatifyVectors.chats : ChatifyVectors.chatsRegular,
                width: 24,
                height: 24,
                color: selectedIndex == 0 ? colorsController.getColor(colorsController.selectedColorScheme.value) : (context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black),
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
                color: selectedIndex == 1 ? colorsController.getColor(colorsController.selectedColorScheme.value) : (context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black),
              ),
              label: S.of(context).status,
              index: 1,
            ),
            _buildBottomNavigationBarItem(
              context,
              colorsController: colorsController,
              iconWidget: Icon(
                selectedIndex == 2 ? Icons.groups : Icons.groups_outlined,
                size: 28,
              ),
              label: S.of(context).community,
              index: 2,
            ),
            _buildBottomNavigationBarItem(
              context,
              colorsController: colorsController,
              iconWidget: Icon(selectedIndex == 3 ? Icons.call : Icons.call_outlined),
              label: S.of(context).calls,
              index: 3,
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          unselectedItemColor: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black,
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
      icon: Tooltip(
        message: label,
        decoration: BoxDecoration(color: tooltipColor, borderRadius: BorderRadius.circular(4)),
        textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
        child: Container(
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          child: iconWidget,
        ),
      ),
      label: label,
      tooltip: '',
    );
  }
}
