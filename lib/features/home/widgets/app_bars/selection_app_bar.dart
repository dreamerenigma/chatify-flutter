import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedChatsCount;
  final VoidCallback onClearSelection;
  final VoidCallback onPin;
  final VoidCallback onDelete;
  final VoidCallback onMute;
  final VoidCallback onArchive;
  final VoidCallback onAddToFavorites;

  const SelectionAppBar({
    super.key,
    required this.selectedChatsCount,
    required this.onClearSelection,
    required this.onPin,
    required this.onDelete,
    required this.onMute,
    required this.onArchive,
    required this.onAddToFavorites,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => onClearSelection()),
      title: Row(
        children: [
          const SizedBox(width: 16),
          Text('$selectedChatsCount'),
          const Spacer(),
          const SizedBox(width: 21),
          IconButton(
            onPressed: onPin,
            icon: const Icon(BootstrapIcons.pin),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(FluentIcons.delete_24_regular),
          ),
          IconButton(
            onPressed: onMute,
            icon: const Icon(Icons.notifications_off_outlined),
          ),
          IconButton(
            onPressed: onArchive,
            icon: const Icon(Icons.archive_outlined),
          ),
          TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: 'Ещё',
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 280),
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
                onSelected: (value) {
                  if (value == 1) {

                  } else if (value == 2) {

                  } else if (value == 3) {

                  } else if (value == 4) {

                  } else if (value == 5) {

                  } else if (value == 6) {

                  } else if (value == 7) {

                  } else if (value == 8) {

                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).addChatIconScreen,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Просмотр контакта',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Пометить как непрочитанное',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Закрыть чат',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Добавить в избранное',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 6,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Добавить в список',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 7,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Очистить чат',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 8,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Заблокировать',
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
      elevation: 0,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    );
  }
}
