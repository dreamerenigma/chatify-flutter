import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../calls/screens/audio/outgoing_audio_call_screen.dart';
import '../../../calls/screens/video/outgoing_video_call_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/screens/chat_screen.dart';
import '../../../personalization/screens/profile/photo_profile_screen.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class ProfileDialog extends StatefulWidget {
  final UserModel user;

  const ProfileDialog({super.key, required this.user});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = APIs.me;
    final isMe = widget.user.id == user.id;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        height: MediaQuery.of(context).size.height * .35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, createPageRoute(PhotoProfileScreen(image: widget.user.image, user: widget.user)));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: _profileImageUrl ?? '',
                        errorWidget: (context, url, error) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              ChatifyVectors.person,
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn),
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
                      decoration: BoxDecoration(color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()), borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .03, vertical: MediaQuery.of(context).size.width * .01),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, createPageRoute(PhotoProfileScreen(image: widget.user.image, user: widget.user)));
                        },
                        child: Text(
                          isMe ? '${widget.user.phoneNumber} (Вы)' : '${widget.user.name} ${widget.user.surname}',
                          style: TextStyle(color: ChatifyColors.white, fontSize: 17, fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: isMe ? 34 : 17),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(ChatScreen(user: widget.user)));
                    },
                    icon: SvgPicture.asset(ChatifyVectors.messageOutline, width: 28, height: 28, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)),
                  ),
                  const Spacer(),
                  if (!isMe) ...[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: widget.user, onMinimize: () {})));
                      },
                      icon: Icon(Icons.call, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 28),
                    ),
                  ],
                  const SizedBox(width: 17),
                  if (!isMe) ...[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: widget.user)));
                      },
                      icon: Icon(Icons.video_call, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 28),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(ViewProfileScreen(user: widget.user)));
                    },
                    icon: Icon(Icons.info_outline, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 28),
                  ),
                  SizedBox(width: isMe ? 34 : 17),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
