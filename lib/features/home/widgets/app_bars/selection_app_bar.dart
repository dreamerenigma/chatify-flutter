import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedChatsCount;
  final VoidCallback onClearSelection;
  final VoidCallback onDelete;
  final VoidCallback onMute;
  final VoidCallback onArchive;
  final VoidCallback? onPin;
  final bool isArchiveMode;
  final bool isPinned;
  final bool isMuted;

  const SelectionAppBar({
    super.key,
    required this.selectedChatsCount,
    required this.onClearSelection,
    required this.onDelete,
    required this.onMute,
    required this.onArchive,
    this.onPin,
    this.isArchiveMode = false,
    this.isPinned = false,
    this.isMuted = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => onClearSelection()),
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      title: Row(
        children: [
          const SizedBox(width: 16),
          Text('$selectedChatsCount'),
          const Spacer(),
          const SizedBox(width: 21),
          if (onPin != null)
            IconButton(
              onPressed: onPin,
              icon: isPinned ? SvgPicture.asset(ChatifyVectors.unpin, width: 24, height: 24, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.white, BlendMode.srcIn)) : Icon(BootstrapIcons.pin, size: 24),
            ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(FluentIcons.delete_24_regular, size: 24),
          ),
          IconButton(
            onPressed: onMute,
            icon: Icon(isMuted ? Icons.notifications_none_rounded : Icons.notifications_off_outlined, size: 24),
          ),
          IconButton(
            onPressed: onArchive,
            icon: Icon(isArchiveMode ? Icons.unarchive_outlined : Icons.archive_outlined, size: 24),
          ),
          TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: S.of(context).more,
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 295),
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
    );
  }
}
