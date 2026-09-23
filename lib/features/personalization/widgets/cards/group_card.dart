import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../group/models/group_model.dart';
import '../../../group/screens/group_chat_screen.dart';
import '../../../home/widgets/dialogs/edit_settings_chat_dialog.dart';
import '../dialogs/group_dialog.dart';
import '../dialogs/light_dialog.dart';

class GroupCard extends StatefulWidget {
  final GroupModel group;
  final bool showMembers;
  final bool isSelected;
  final String currentUser;
  final ValueChanged<GroupModel> onGroupSelected;

  const GroupCard({
    super.key,
    required this.group,
    required this.currentUser,
    required this.onGroupSelected,
    required this.isSelected,
    this.showMembers = false,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isCreatedByCurrentUser = widget.group.creatorName == widget.currentUser;
    final bool isHighlighted = widget.isSelected;

    return Card(
      margin: EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8, bottom: 6),
      elevation: isHighlighted ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isHighlighted ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : null,
      child: GestureDetector(
        onLongPress: () {
          widget.onGroupSelected(widget.group);
        },
        onSecondaryTapDown: (details) {
          if (Platform.isWindows) {
            Future.delayed(Duration(milliseconds: 100), () {
              showEditSettingsChatDialog(context, details.localPosition);
            });
          }
        },
        onLongPressUp: () {
          if (isWindows) {
            setState(() {
              isLongPressed = false;
            });
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isHighlighted ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : context.isDarkMode
              ? ChatifyColors.blackGrey
              : ChatifyColors.lightBackground,
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(15),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              final group = GroupModel(
                id: '',
                ownerId: APIs.user.uid,
                groupName: widget.group.groupName,
                groupImage: widget.group.groupImage,
                groupDescription: '',
                createdAt: widget.group.createdAt,
                creatorName: widget.group.creatorName,
                members: widget.group.members,
                pushToken: '',
                lastMessageTimestamp: 0,
              );

              if (Platform.isWindows) {
                widget.onGroupSelected(group);
              } else {
                Navigator.push(context, createPageRoute(GroupChatScreen(group: group)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    clipBehavior: Clip.none,
                    children: [
                      FutureBuilder<String?>(
                        future: APIs.getMediaUrl(widget.group.groupImage),
                        builder: (context, snapshot) {
                          final imageUrl = snapshot.data;

                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => GroupDialog(
                                  groupName: widget.group.groupName,
                                  groupImage: imageUrl ?? '',
                                  members: widget.group.members,
                                  createdAt: widget.group.createdAt,
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(23),
                              child: CachedNetworkImage(
                                width: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                                height: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                                imageUrl: imageUrl ?? '',
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  child: SvgPicture.asset(ChatifyVectors.groups, width: 26, height: 26, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (widget.isSelected)
                        Positioned(
                          bottom: -3,
                          right: -2,
                          child: Container(
                            width: 23,
                            height: 23,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                              border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                            ),
                            child: const Icon(Icons.check, color: ChatifyColors.black, size: 16),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.group.groupName,
                                style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontFamily: 'Helvetica', fontWeight: Platform.isWindows ? FontWeight.w400 : FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              DateUtil.formatDateTime(widget.group.createdAt),
                              style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                            ),
                          ],
                        ),
                        Text(
                          isCreatedByCurrentUser ? S.of(context).youCreatedGroup : '${S.of(context).groupHasBeenCreated} ${widget.group.creatorName}',
                          style: TextStyle(
                            fontSize: ChatifySizes.fontSizeSm,
                            fontWeight: FontWeight.w400,
                            color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
