import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/widgets/dialogs/chat_settings_dialog.dart';
import '../../../personalization/screens/chats/wallpaper_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/info_app_model.dart';
import '../../models/support_model.dart';

class SupportAppBar extends StatefulWidget implements PreferredSizeWidget {
  final SupportAppModel? support;
  final InfoAppModel? infoApp;

  const SupportAppBar({
    super.key,
    this.support,
    this.infoApp,
  });

  @override
  State<SupportAppBar> createState() => SupportAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight + 4);
}

class SupportAppBarState extends State<SupportAppBar> with SingleTickerProviderStateMixin {
  bool showRealStatus = false;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showRealStatus = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }

  Widget _buildAppBar(BuildContext context) {
    return Stack(
      children: [
        _buildSupportAppBar(context),
      ],
    );
  }

  Widget _buildSupportAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey))),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: -5,
        elevation: 0,
        leadingWidth: 55,
        title: _buildSupportInfo(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<int>(
            tooltip: S.of(context).more,
            position: PopupMenuPosition.under,
            offset: const Offset(-8, 0),
            menuPadding: EdgeInsets.symmetric(vertical: 4),
            constraints: const BoxConstraints(minWidth: 0, maxWidth: 160),
            icon: const Icon(Icons.more_vert),
            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
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
            onSelected: (value) {
              if (value == 5) {
                _showMorePopupMenu(context);
                return;
              }

              _handlePopupAction(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Поиск',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Заблокировать',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Без звука',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Тема чата',
                  onTap: () {
                    Navigator.pop(context);
                    if (imagePath != null && imagePath!.isNotEmpty) {
                      Navigator.push(context, createPageRoute(WallpaperScreen(imagePath: imagePath!)));
                    }
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
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
                        Navigator.pop(context, 5);
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
          ),
        ],
      ),
    );
  }

  Future<void> _handlePopupAction(int value) async {
    switch (value) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
    }
  }

  Widget _buildSupportInfo(BuildContext context) {
    final String name;
    final String description;

    if (widget.infoApp != null) {
      name = widget.infoApp!.name;
      description = widget.infoApp!.description;
    } else {
      name = S.of(context).chatifySupport;
      description = widget.support!.description;
    }

    return Material(
      color: ChatifyColors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        mouseCursor: SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(8),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          if (widget.support != null) {
            showChatSettingsDialog(context, widget.support!, position, initialIndex: 0);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                child: SvgPicture.asset(ChatifyVectors.logoApp, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
              ),
              SizedBox(width: Platform.isWindows ? 14 : 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400, height: 1.3),
                        ),
                        SizedBox(width: 4),
                        SvgPicture.asset(ChatifyVectors.starburstCheck, width: 14, height: 14, colorFilter: ColorFilter.mode(ChatifyColors.blue, BlendMode.srcIn)),
                      ],
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          value: 6,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Медиа, ссылки и докум.',
            onTap: () {
              Navigator.pop(context, 6);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Очистить чат',
            onTap: () {
              Navigator.pop(context, 7);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 8,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Экспорт чата',
            onTap: () {
              Navigator.pop(context, 8);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 9,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Добавить иконку на экран',
            onTap: () {
              Navigator.pop(context, 9);
            },
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;

      _handlePopupAction(value);
    });
  }
}
