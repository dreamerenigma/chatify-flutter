import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../personalization/screens/help/search_help_center_screen.dart';

class AuthAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuItemIndex1;
  final VoidCallback? onMenuItemIndex2;
  final String? menuItem1Text;
  final String? menuItem2Text;
  final IconData? leftIcon;

  const AuthAppBar({
    super.key,
    required this.title,
    this.onMenuItemIndex1,
    this.onMenuItemIndex2,
    this.menuItem1Text,
    this.menuItem2Text,
    this.leftIcon,
  });

  @override
  State<AuthAppBar> createState() => _AuthAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AuthAppBarState extends State<AuthAppBar> {
  bool isHovered = false;
  final GlobalKey _newHelpKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        height: (isWebOrWindows && !isMobile) ? 55 : 75,
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
          boxShadow: [
            BoxShadow(
              color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: isMobile ? 35 : 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: CustomTooltip(
                  message: S.of(context).back,
                  horizontalOffset: -35,
                  verticalOffset: 10,
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
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        mouseCursor: SystemMouseCursors.basic,
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(8),
                        splashColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
                          clipBehavior: Clip.hardEdge,
                          child: Icon(Icons.arrow_back, color: isHovered ? context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white : ChatifyColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: isWindows ? Alignment.center : Alignment.centerLeft,
                      child: Text(widget.title, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, overflow: TextOverflow.ellipsis), maxLines: 1),
                    ),
                  ],
                ),
              ),
              if (widget.leftIcon != null)
              IconButton(
                icon: Icon(widget.leftIcon),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const SearchHelpCenterScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ));
                },
              ),
              CustomTooltip(
                message: S.of(context).help,
                horizontalOffset: -35,
                verticalOffset: 0,
                child: Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    key: _newHelpKey,
                    onTap: () async {
                      final RenderBox renderBox = _newHelpKey.currentContext?.findRenderObject() as RenderBox;
                      final position = renderBox.localToGlobal(Offset.zero);
                      final List<PopupMenuEntry<int>> menuItems = [];

                      if (widget.menuItem1Text != null) {
                        menuItems.add(
                          PopupMenuItem(
                            value: 1,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                              mouseCursor: SystemMouseCursors.basic,
                              splashFactory: NoSplash.splashFactory,
                              splashColor: ChatifyColors.transparent,
                              highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                              hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
                              onTap: () {
                                Navigator.pop(context, 1);
                                widget.onMenuItemIndex1?.call();
                              },
                              child: Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(minHeight: 48),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  widget.menuItem1Text!,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      if (widget.menuItem2Text != null) {
                        menuItems.add(
                          PopupMenuItem(
                            value: 2,
                            padding: EdgeInsets.zero,
                            child: Material(
                              color: ChatifyColors.transparent,
                              child: InkWell(
                                mouseCursor: SystemMouseCursors.basic,
                                splashFactory: NoSplash.splashFactory,
                                splashColor: ChatifyColors.transparent,
                                highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
                                onTap: () {
                                  Navigator.pop(context, 2);
                                  widget.onMenuItemIndex2?.call();
                                },
                                child: Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(minHeight: 48),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(widget.menuItem2Text!, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      await showMenu(
                        context: context,
                        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                        position: RelativeRect.fromLTRB(
                          position.dx,
                          isWebOrWindows ? position.dy : position.dy + renderBox.size.height,
                          position.dx + renderBox.size.width,
                          0,
                        ),
                        items: menuItems,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      );
                    },
                    mouseCursor: SystemMouseCursors.basic,
                    splashFactory: NoSplash.splashFactory,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.more_vert),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
