import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final Function(String) onSearch;
  final VoidCallback onToggleSearch;
  final Widget title;
  final Widget popupMenuButton;
  final bool showSearch;
  final VoidCallback? onCameraPressed;
  final bool showHomeIcon;
  final bool centerTitle;
  final double titleSpacing;
  final String hintText;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.onSearch,
    required this.onToggleSearch,
    required this.title,
    required this.popupMenuButton,
    this.showSearch = true,
    this.onCameraPressed,
    this.showHomeIcon = false,
    this.centerTitle = false,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
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
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(fontSize: ChatifySizes.fontSizeMg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          title: showSearch && isSearching
            ? TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  ),
                  autofocus: true,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
                  onChanged: onSearch,
                ),
              )
            : title,
          actions: [
            if (onCameraPressed != null)
              IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: onCameraPressed),
            SizedBox(width: 4),
            if (showSearch)
              IconButton(onPressed: onToggleSearch, icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
            popupMenuButton,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
