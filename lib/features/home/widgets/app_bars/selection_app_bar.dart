import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedChatsCount;
  final Function onClearSelection;
  final Function onHandleDeleteSelectedChats;

  const SelectionAppBar({
    super.key,
    required this.selectedChatsCount,
    required this.onClearSelection,
    required this.onHandleDeleteSelectedChats,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => onClearSelection(),
      ),
      title: Row(
        children: [
          Text('$selectedChatsCount'),
          const Spacer(),
          const SizedBox(width: 21),
          IconButton(
            onPressed: () {},
            icon: const Icon(BootstrapIcons.pin),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FluentIcons.delete_24_regular),
          ),
          IconButton(
            onPressed: () => onHandleDeleteSelectedChats(),
            icon: const Icon(Icons.notifications_off_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.archive_outlined),
          ),
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.all(16.0),
                child: Text(S.of(context).addChatIconScreen, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
              ),
              PopupMenuItem(
                value: 2,
                padding: const EdgeInsets.all(16.0),
                child: Text(S.of(context).addContact, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    );
  }
}
