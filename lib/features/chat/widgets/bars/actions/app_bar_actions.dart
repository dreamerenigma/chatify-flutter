import 'dart:io';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../common/widgets/buttons/custom_search_button.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/devices/device_utility.dart';
import '../../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../../utils/dialogs/no_internet_connection_dialog.dart';

class AppBarActions extends StatefulWidget {
  final VoidCallback? onVideoCall;
  final VoidCallback? onAudioCall;
  final VoidCallback? onSearch;
  final void Function(int)? onPopupItemSelected;

  const AppBarActions({
    super.key,
    this.onVideoCall,
    this.onAudioCall,
    this.onSearch,
    this.onPopupItemSelected,
  });

  @override
  State<AppBarActions> createState() => _AppBarActionsState();
}

class _AppBarActionsState extends State<AppBarActions> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  late Animation<double> _searchScaleAnimation;

  bool get isMobile => Platform.isIOS || Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _searchController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Platform.isWindows) ...[
          Container(
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, width: 1),
              color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.transparent,
            ),
            child: Row(
              children: [
                _buildIcon(
                  context,
                  message: S.of(context).videoCall,
                  icon: HeroIcon(HeroIcons.videoCamera, size: 22),
                  onTap: () async {
                    if (await DeviceUtils.hasInternetConnection()) {
                      widget.onVideoCall?.call();
                    } else {
                      showNoInternetConnectionDialog(context);
                    }
                  },
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                ),
                if (!isMobile) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: VerticalDivider(color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, thickness: 1, width: 1),
                  ),
                ],
                _buildIcon(
                  context,
                  message: S.of(context).audioCall,
                  icon: SvgPicture.asset(ChatifyVectors.calls, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn), width: 22, height: 22),
                  onTap: () async {
                    if (await DeviceUtils.hasInternetConnection()) {
                      widget.onAudioCall?.call();
                    } else {
                      showNoInternetConnectionDialog(context);
                    }
                  },
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
              ],
            ),
          ),
        ],
        if (isMobile) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: InkWell(
                  onTap: widget.onVideoCall,
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(30),
                  splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                  highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: HeroIcon(HeroIcons.videoCamera, size: 26, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  ),
                ),
              ),
              SizedBox(width: 4),
              SizedBox(
                width: 44,
                height: 44,
                child: InkWell(
                  onTap: widget.onAudioCall,
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(30),
                  splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                  highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(ChatifyVectors.calls, width: 24, height: 24, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                  ),
                ),
              ),
            ],
          ),
        ],
        if (Platform.isWindows) const SizedBox(width: 5),
        if (!Platform.isWindows)
          SizedBox(
            width: 44,
            height: 44,
            child: TooltipTheme(
              data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                child: IconButton(
                  tooltip: S.of(context).more,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert, size: 22, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  onPressed: () => _showPopupMenu(context),
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
                ),
              ),
            ),
          ),
        if (Platform.isWindows)
        CustomSearchButton(
          searchController: _searchController,
          searchScaleAnimation: _searchScaleAnimation,
          onPressed: widget.onSearch,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  PopupMenuItem<int> _popupItem(BuildContext context, int value, String title) {
    return PopupMenuItem<int>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AppPopupMenuItem(
        text: title,
        onTap: () {
          Navigator.pop(context, value);
        },
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context, {
    required String message,
    required Widget icon,
    required VoidCallback? onTap,
    required BorderRadius borderRadius,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  }) {
    return CustomTooltip(
      message: message,
      verticalOffset: -70,
      horizontalOffset: -35,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
        borderRadius: borderRadius,
        child: Container(padding: padding, child: icon),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 235, kToolbarHeight + 25, 8, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      constraints: const BoxConstraints(minWidth: 235, maxWidth: 235),
      menuPadding: EdgeInsets.symmetric(vertical: 4),
      color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
      items: [
        _popupItem(context, 1, S.of(context).groupData),
        _popupItem(context, 2, S.of(context).mediaGroups),
        PopupMenuDivider(height: 8, indent: 0, endIndent: 0, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled),
        _popupItem(context, 3, 'Просмотр контакта'),
        _popupItem(context, 4, S.of(context).search),
        _popupItem(context, 5, 'Медиа, ссылки и докум.'),
        _popupItem(context, 6, S.of(context).noSound),
        _popupItem(context, 7, S.of(context).disappearingMessages),
        _popupItem(context, 8, S.of(context).wallpaper),
        PopupMenuDivider(height: 8, indent: 0, endIndent: 0, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled),
        PopupMenuItem<int>(
          value: 9,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(ChatifySizes.inputFieldRadius),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                onTap: () {
                  Navigator.pop(context, 9);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 6, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text(S.of(context).more, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                      Icon(Icons.arrow_right, size: 28, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;

      if (value == 9) {
        _showMorePopupMenu(context);
        return;
      }

      widget.onPopupItemSelected?.call(value);
    });
  }

  void _showMorePopupMenu(BuildContext context) {
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 255, kToolbarHeight + 25, 8, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      constraints: const BoxConstraints(minWidth: 255, maxWidth: 255),
      menuPadding: EdgeInsets.symmetric(vertical: 4),
      color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
      items: [
        PopupMenuItem<int>(
          value: 10,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Пожаловаться',
            onTap: () {
              Navigator.pop(context, 10);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 11,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Заблокировать',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 12,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Очистить чат',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 13,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Экспорт чата',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 14,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Добавить иконку на экран',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 15,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Добавить в список',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;

      widget.onPopupItemSelected?.call(value);
    });
  }
}
