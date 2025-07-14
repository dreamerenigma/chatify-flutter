import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../group/models/group_model.dart';
import '../../../group/screens/group_chat_screen.dart';
import '../../screens/profile/photo_group_screen.dart';
import 'light_dialog.dart';

class GroupDialog extends StatelessWidget {
  final String groupName;
  final String groupImage;
  final List<String> members;
  final DateTime createdAt;

  const GroupDialog({
    super.key,
    required this.groupName,
    required this.groupImage,
    required this.members,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.size.width * .6,
        height: mq.size.height * .35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, createPageRoute(const PhotoGroupScreen(imageGroup: '', groupId: '')));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: groupImage,
                        errorWidget: (context, url, error) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            child: const Icon(
                              Icons.group,
                              color: Colors.white,
                              size: 80,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha((0.7 * 255).toInt()),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: mq.size.width * .01, horizontal: mq.size.width * .05),
                      child: Text(
                        groupName,
                        style: TextStyle(
                          fontSize: ChatifySizes.fontSizeLg,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0.0),
            const Divider(height: 1.0, thickness: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    final group = GroupModel(
                      groupId: '',
                      groupName: groupName,
                      groupImage: groupImage,
                      groupDescription: '',
                      createdAt: createdAt,
                      creatorName: APIs.user.displayName ?? 'Unknown User',
                      members: members,
                      pushToken: '',
                      lastMessageTimestamp: 0,
                    );

                    Navigator.push(
                      context,
                      createPageRoute(
                        GroupChatScreen(
                          groupName: group.groupName,
                          members: group.members,
                          groupImage: group.groupImage,
                          createdAt: group.createdAt,
                          groupId: group.groupId,
                          group: group,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.message, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                ),
                const SizedBox(width: 17),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.call, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                ),
                const SizedBox(width: 17),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.video_call, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 35),
                ),
                const SizedBox(width: 17),
                IconButton(
                  onPressed: () {
                    // Implement action if needed
                  },
                  icon: Icon(Icons.info_outline, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                ),
                const SizedBox(width: 17),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
