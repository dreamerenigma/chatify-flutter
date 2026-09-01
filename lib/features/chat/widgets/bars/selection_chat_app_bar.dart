import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../models/message_model.dart';

class SelectionChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Set<int> selectedMessages;
  final List list;
  final VoidCallback _clearSelection;
  final VoidCallback _handleDeleteSelectedMessages;
  final ValueChanged<MessageModel> _handleUpdateMessage;

  const SelectionChatAppBar({
    super.key,
    required this.selectedMessages,
    required this.list,
    required this._clearSelection,
    required this._handleDeleteSelectedMessages,
    required this._handleUpdateMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _clearSelection()),
      title: Row(
        children: [
          const SizedBox(width: 16),
          Text('${selectedMessages.length}'),
          const Spacer(),
          const SizedBox(width: 21),
          IconButton(
            onPressed: () {},
            icon: Transform(alignment: Alignment.center, transform: Matrix4.diagonal3Values(1, -1, 1), child: const Icon(BootstrapIcons.arrow_return_left)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border_rounded),
          ),
          IconButton(
            onPressed: () => _handleDeleteSelectedMessages(),
            icon: const Icon(FluentIcons.delete_24_regular),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 28, height: 28, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
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
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
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
                color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
                onSelected: (value) {
                  if (value == 1) {

                  } else if (value == 2) {
                    if (selectedMessages.isNotEmpty) {
                      final message = list[selectedMessages.first];
                      _handleUpdateMessage(message);
                    }
                  } else if (value == 3) {

                  } else if (value == 4) {

                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    enabled: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).copy,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    enabled: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).edit,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).pinIt,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).complain,
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
