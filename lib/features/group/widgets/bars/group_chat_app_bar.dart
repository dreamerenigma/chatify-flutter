import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/widgets/bars/actions/app_bar_actions.dart';
import '../../../personalization/widgets/dialogs/group_settings_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class GroupChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String groupImage;
  final String groupName;
  final List<String> members;
  final Future<Map<String, String>> userNamesFuture;

  const GroupChatAppBar({
    super.key,
    required this.groupImage,
    required this.groupName,
    required this.members,
    required this.userNamesFuture,
  });

  @override
  State<GroupChatAppBar> createState() => _GroupChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight);
}

class _GroupChatAppBarState extends State<GroupChatAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _searchController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isWindows
      ? Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey))),
        child: AppBar(
          backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Row(
              children: [
                _buildGroupInfo(context),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: AppBarActions(
                onVideoCall: () => log("Video call"),
                onAudioCall: () => log("Audio call"),
                onSearch: () => _searchController.forward(),
                onPopupItemSelected: (value) {
                  if (value == 1) {}
                },
              ),
            ),
          ],
        ),
      )
      : AppBar(
        titleSpacing: -10,
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        title: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              _buildGroupInfo(context),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: AppBarActions(
              onVideoCall: () => log("Video call"),
              onAudioCall: () => log("Audio call"),
              onSearch: () => _searchController.forward(),
              onPopupItemSelected: (value) {
                if (value == 1) {}
              },
            ),
          ),
        ],
      );
  }

  Widget _buildGroupInfo(BuildContext context) {
    double imageSize = Platform.isWindows ? 40.0 : 30.0;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      onTap: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        showGroupSettingsDialog(context, position, initialIndex: 0);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: CachedNetworkImage(
                width: imageSize,
                height: imageSize,
                imageUrl: widget.groupImage,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                placeholder: (context, url) => CircleAvatar(
                  backgroundColor: ChatifyColors.buttonSecondary,
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(backgroundColor: ChatifyColors.buttonSecondary, child: Icon(Icons.group, color: ChatifyColors.grey)),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.groupName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                const SizedBox(width: 2),
                FutureBuilder<Map<String, String>>(
                  future: widget.userNamesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Загрузка...', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300));
                    } else if (snapshot.hasError) {
                      return Text('Ошибка загрузки имен', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    } else if (snapshot.hasData) {
                      final userNames = snapshot.data!;
                      final membersNames = widget.members.map((id) => userNames[id] ?? 'Неизвестный пользователь').join(', ');
                      return Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          membersNames,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    } else {
                      return Text('Нет участников', style: TextStyle(fontSize: ChatifySizes.fontSizeLm),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
