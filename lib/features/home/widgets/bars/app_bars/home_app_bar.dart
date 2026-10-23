import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearch;
  final Widget title;
  final Widget popupMenuButton;
  final Widget? moreButton;
  final bool isSearching;
  final bool showSearch;
  final bool showHomeIcon;
  final bool centerTitle;
  final bool selectionMode;
  final bool isFavorite;
  final int selectedCount;
  final String hintText;
  final double titleSpacing;
  final VoidCallback onToggleSearch;
  final VoidCallback? onSelectionBack;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final VoidCallback? onMore;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onTestPressed;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.onSearch,
    required this.onToggleSearch,
    required this.title,
    required this.popupMenuButton,
    required this.hintText,
    this.moreButton,
    this.showSearch = true,
    this.showHomeIcon = false,
    this.centerTitle = false,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.selectionMode = false,
    this.isFavorite = false,
    this.selectedCount = 0,
    this.onSelectionBack,
    this.onDelete,
    this.onFavorite,
    this.onMore,
    this.onCameraPressed,
    this.onTestPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(fontSize: ChatifySizes.fontSizeMg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
        centerTitle: centerTitle,
        titleSpacing: titleSpacing,
        leading: selectionMode ? IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 25), onPressed: onSelectionBack) : null,
        title: selectionMode
          ? Text('$selectedCount', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))
          : showSearch && isSearching
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
                    hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                  ),
                  autofocus: true,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, letterSpacing: 0.5),
                  onChanged: onSearch,
                ),
              )
            : title,
        actions: selectionMode ? _buildSelectionActions(context) : _buildNormalActions(context),
      ),
    );
  }

  List<Widget> _buildNormalActions(BuildContext context) {
    if (showSearch && isSearching) {
      return [
        IconButton(onPressed: onToggleSearch, icon: const Icon(CupertinoIcons.clear_circled, size: 25)),
      ];
    }

    return [
      // if (APIs.me.role == 'Admin')
        TooltipTheme(
          data: TooltipThemeData(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, borderRadius: BorderRadius.circular(8)),
            textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
          ),
          child: Tooltip(
            message: 'Тесты',
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: IconButton(
                onPressed: onTestPressed,
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(-1, 1, 1),
                  child: SvgPicture.asset(ChatifyVectors.labTest, width: 22, height: 22, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                ),
              ),
            ),
          ),
        ),
      SizedBox(width: 6),
      if (onCameraPressed != null)
        TooltipTheme(
          data: TooltipThemeData(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, borderRadius: BorderRadius.circular(8)),
            textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
          ),
          child: Tooltip(
            message: S.of(context).camera,
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: IconButton(icon: Icon(Icons.camera_alt_outlined, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), onPressed: onCameraPressed),
            ),
          ),
        ),
      const SizedBox(width: 4),
      if (showSearch)
        TooltipTheme(
          data: TooltipThemeData(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, borderRadius: BorderRadius.circular(8)),
            textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
          ),
          child: Tooltip(
            message: S.of(context).camera,
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: IconButton(onPressed: onToggleSearch, icon: Icon(Icons.search, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
            ),
          ),
        ),
      popupMenuButton,
    ];
  }

  List<Widget> _buildSelectionActions(BuildContext context) {
    return [
      IconButton(tooltip: 'Удалить', icon: SvgPicture.asset(ChatifyVectors.delete, width: 25, height: 25, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)), onPressed: onDelete),
      if (selectedCount == 1) ...[
        SizedBox(width: 5),
        IconButton(
          tooltip: isFavorite ? 'Убрать из избранного' : 'Добавить в избранное',
          icon: isFavorite ? SvgPicture.asset(ChatifyVectors.favoriteNone, width: 25, height: 25, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)) : const Icon(Icons.favorite_outline, size: 25),
          onPressed: onFavorite,
        ),
        moreButton ?? const SizedBox.shrink(),
      ],
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
