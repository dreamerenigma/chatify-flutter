import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class FullScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FullScreenAppBar({super.key});

  @override
  FullScreenAppBarState createState() => FullScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FullScreenAppBarState extends State<FullScreenAppBar> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ChatifyColors.blackGrey,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(isFavorited ? Icons.star : Icons.star_border, color: ChatifyColors.white),
          onPressed: () {
            setState(() {
              isFavorited = !isFavorited;
            });
          },
        ),
        IconButton(icon: const Icon(FluentIcons.arrow_forward_16_filled, color: ChatifyColors.white), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.more_vert, color: ChatifyColors.white),
          onPressed: () {
            showMenu(
              context: context,
              color: ChatifyColors.popupColor,
              position: const RelativeRect.fromLTRB(50, 75, 0, 0),
              items: [
                PopupMenuItem(
                  value: 1,
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
                  child: Text(S.of(context).change, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 2,
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
                  child: Text(S.of(context).allMedia, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 3,
                  padding: const EdgeInsets.only(left: 16.0, top: 4),
                  child: Text(S.of(context).showInChat, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 4,
                  padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
                  child: Text(S.of(context).share, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 5,
                  padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
                  child: Text(S.of(context).save, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 6,
                  padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
                  child: Text(S.of(context).viewGalleries, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 7,
                  padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
                  child: Text(S.of(context).rotation, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
                PopupMenuItem(
                  value: 8,
                  padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
                  child: Text(S.of(context).delete, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            );
          },
        ),
      ],
    );
  }
}
