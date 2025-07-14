import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../group/models/group_model.dart';
import '../../../group/screens/group_chat_screen.dart';
import '../../../home/widgets/dialogs/edit_settings_chat_dialog.dart';
import '../dialogs/group_dialog.dart';
import '../dialogs/light_dialog.dart';

class GroupCard extends StatefulWidget {
  final String groupName;
  final List<String> members;
  final String creatorName;
  final String currentUser;
  final DateTime createdAt;
  final String groupImage;
  final bool showMembers;
  final ValueChanged<GroupModel> onGroupSelected;
  final bool isSelected;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.members,
    required this.creatorName,
    required this.currentUser,
    required this.createdAt,
    required this.groupImage,
    this.showMembers = false,
    required this.onGroupSelected,
    required this.isSelected,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final bool isCreatedByCurrentUser = widget.creatorName == widget.currentUser;

    return Card(
      margin: EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8, bottom: 6),
      elevation: isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : null,
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        onSecondaryTapDown: (details) {
          if (Platform.isWindows) {
            Future.delayed(Duration(milliseconds: 100), () {
              showEditSettingsChatDialog(context, details.localPosition);
            });
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : context.isDarkMode
              ? ChatifyColors.blackGrey
              : ChatifyColors.lightBackground,
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              final group = GroupModel(
                groupId: '',
                groupName: widget.groupName,
                groupImage: widget.groupImage,
                groupDescription: '',
                createdAt: widget.createdAt,
                creatorName: widget.creatorName,
                members: widget.members,
                pushToken: '',
                lastMessageTimestamp: 0,
              );

              if (Platform.isWindows) {
                widget.onGroupSelected(group);
              } else {
                Navigator.push(
                  context,
                  createPageRoute(
                    GroupChatScreen(
                      groupName: widget.groupName,
                      members: widget.members,
                      groupImage: widget.groupImage,
                      createdAt: widget.createdAt,
                      groupId: group.groupId,
                      group: group,
                    ),
                  ),
                );
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => GroupDialog(
                              groupName: widget.groupName,
                              groupImage: widget.groupImage,
                              members: const [],
                              createdAt: widget.createdAt,
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: CachedNetworkImage(
                            width: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                            height: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                            imageUrl: widget.groupImage,
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
                              child: SvgPicture.asset(ChatifyVectors.communityUsers, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                            ),
                          ),
                        ),
                      ),
                      if (!Platform.isWindows && isSelected)
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
                          child: const Icon(Icons.check, color: ChatifyColors.white, size: 16),
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
                                widget.groupName,
                                style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontFamily: 'Helvetica', fontWeight: Platform.isWindows ? FontWeight.w400 : FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              DateUtil.formatDateTime(widget.createdAt),
                              style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                            ),
                          ],
                        ),
                        Text(
                          isCreatedByCurrentUser ? 'Вы создали эту группу' : 'Группа создана ${widget.creatorName}',
                          style: TextStyle(
                            fontSize: ChatifySizes.fontSizeSm,
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
