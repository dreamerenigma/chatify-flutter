import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../calls/screens/audio/outgoing_audio_call_screen.dart';
import '../../../calls/screens/video/outgoing_video_call_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/screens/chat_screen.dart';
import '../../../personalization/screens/profile/photo_profile_screen.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class ProfileDialog extends StatelessWidget {
  final UserModel user;

  const ProfileDialog({super.key, required this.user});

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
                      Navigator.push(context, createPageRoute(PhotoProfileScreen(image: user.image, user: user)));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: user.image,
                        errorWidget: (context, url, error) {

                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value),),
                            child: const Icon(CupertinoIcons.person, color: ChatifyColors.white, size: 50),
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
                      decoration: BoxDecoration(color: ChatifyColors.black.withAlpha((0.7 * 255).toInt()), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                      padding: EdgeInsets.symmetric(vertical: mq.size.width * .01, horizontal: mq.size.width * .05),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, createPageRoute(PhotoProfileScreen(image: user.image, user: user)));
                        },
                        child: Text(
                          user.name,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500, color: ChatifyColors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    Navigator.pop(context);
                    Navigator.push(context, createPageRoute(ChatScreen(user: user)));
                  },
                  icon: Icon(Icons.message, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                ),
                const SizedBox(width: 17),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: user)));
                  },
                  icon: Icon(Icons.call, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                ),
                const SizedBox(width: 17),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: user)));
                  },
                  icon: Icon(Icons.video_call, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                ),
                const SizedBox(width: 17),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, createPageRoute(ViewProfileScreen(user: user)));
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
