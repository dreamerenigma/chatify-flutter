import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../group/models/group_model.dart';
import '../../../group/screens/group_chat_screen.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../screens/profile/photo_group_screen.dart';
import 'light_dialog.dart';

class GroupDialog extends StatelessWidget {
  final GroupModel group;

  const GroupDialog({
    super.key,
    required this.group,
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
                  FutureBuilder<String?>(
                    future: APIs.getMediaUrl(group.groupImage),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }

                      final imageUrl = snapshot.data;

                      return GestureDetector(
                        onTap: () {
                          if (imageUrl == null || imageUrl.isEmpty) return;

                          Navigator.push(context, createPageRoute(PhotoGroupScreen(imageGroup: imageUrl, groupId: group.id)));
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: imageUrl ?? '',
                            placeholder: (context, url) => Container(color: colorsController.getColor(colorsController.selectedColorScheme.value),child: const Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                child: const Icon(Icons.group, color: ChatifyColors.white, size: 80),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(color: ChatifyColors.black.withAlpha((0.7 * 255).toInt()), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                      padding: EdgeInsets.symmetric(vertical: mq.size.width * .01, horizontal: mq.size.width * .05),
                      child: Text(
                        group.groupName,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, color: ChatifyColors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    final chatGroup = GroupModel(
                      id: '',
                      ownerId: APIs.user.uid,
                      groupName: group.groupName,
                      groupImage: group.groupImage,
                      groupDescription: '',
                      createdAt: group.createdAt,
                      creatorName: APIs.user.displayName ?? S.of(context).unknownUser,
                      members: group.members,
                      pushToken: '',
                      lastMessageTimestamp: 0,
                    );

                    Navigator.push(context, createPageRoute(GroupChatScreen(group: chatGroup, user: APIs.me)));
                  },
                  icon: SvgPicture.asset(
                    ChatifyVectors.messageOutline,
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                  ),
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
                  onPressed: () {},
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
