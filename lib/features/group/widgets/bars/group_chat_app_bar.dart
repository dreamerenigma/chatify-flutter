import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/widgets/bars/actions/app_bar_actions.dart';
import '../../../personalization/widgets/dialogs/group_settings_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/group_model.dart';
import '../../screens/group_data_screen.dart';

class GroupChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GroupModel group;
  final Future<Map<String, String>> userNamesFuture;

  const GroupChatAppBar({
    super.key,
    required this.group,
    required this.userNamesFuture,
  });

  @override
  State<GroupChatAppBar> createState() => _GroupChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight + 6);
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
                  onSearch: () => _searchController.forward(),
                  showAudioCall: false,
                  showVideoCallMenu: true,
                  onPopupItemSelected: (value) {
                    if (value == 1) {
                      log("Video call option 1");
                    }
                    if (value == 12) {
                      log("Video call option 2");
                    }
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 25),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: AppBarActions(
                isGroup: true,
                onVideoCall: () => log("Video call"),
                onSearch: () => _searchController.forward(),
                showAudioCall: false,
                showVideoCallMenu: true,
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

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.basic,
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(8),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          if (Platform.isWindows) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);

            showGroupSettingsDialog(context, position, initialIndex: 0);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => GroupDataScreen(group: widget.group)));
          }
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
                  imageUrl: widget.group.groupImage,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: ChatifyColors.buttonSecondary,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(backgroundColor: ChatifyColors.buttonSecondary, child: Icon(Icons.group, size: 24, color: ChatifyColors.grey)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.group.groupName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  const SizedBox(width: 2),
                  FutureBuilder<Map<String, String>>(
                    future: widget.userNamesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(S.of(context).loading, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400));
                      } else if (snapshot.hasError) {
                        return Text(S.of(context).errorLoadingNames, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1);
                      } else if (snapshot.hasData) {
                        final userNames = snapshot.data!;
                        final membersNames = widget.group.members.map((id) => userNames[id] ?? S.of(context).unknownUser).join(', ');
                        return Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            membersNames,
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      } else {
                        return Text(S.of(context).noMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
