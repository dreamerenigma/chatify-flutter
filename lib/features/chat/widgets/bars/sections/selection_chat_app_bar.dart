import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class SelectionChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Set<int> selectedMessages;
  final List list;
  final Function _clearSelection;
  final Function _handleDeleteSelectedMessages;
  final Function _handleUpdateMessage;

  const SelectionChatAppBar({
    super.key,
    required this.selectedMessages,
    required this.list,
    required Function clearSelection,
    required Function handleDeleteSelectedMessages,
    required Function handleUpdateMessage,
  })  : _clearSelection = clearSelection, _handleDeleteSelectedMessages = handleDeleteSelectedMessages, _handleUpdateMessage = handleUpdateMessage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _clearSelection()),
      title: Row(
        children: [
          Text('${selectedMessages.length}'),
          const Spacer(),
          const SizedBox(width: 21),
          IconButton(
            onPressed: () {},
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(1.0, -1.0),
              child: const Icon(BootstrapIcons.arrow_return_left),
            ),
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
            icon: Icon(PhosphorIcons.arrow_bend_double_up_right_bold),
          ),
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            icon: const Icon(Icons.more_vert_rounded),
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
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(S.of(context).copy, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 2,
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(S.of(context).edit, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 3,
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(S.of(context).pinIt, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 4,
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(S.of(context).complain, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
