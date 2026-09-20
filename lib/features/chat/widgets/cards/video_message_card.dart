import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:video_player/video_player.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../messages/video_circle_message.dart';

class VideoMessageCard extends StatelessWidget {
  final MessageModel message;
  final UserModel user;
  final VideoPlayerController controller;
  final double progress;
  final bool isSender;
  final bool isPlaying;
  final bool isFrontCamera;
  final bool isExpanded;
  final VoidCallback onTap;

  const VideoMessageCard({
    super.key,
    required this.message,
    required this.user,
    required this.controller,
    required this.progress,
    required this.isSender,
    required this.isPlaying,
    required this.isExpanded,
    required this.isFrontCamera,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(width: 170, height: 170);
    }

    return VideoCircleMessage(
      message: message,
      user: user,
      controller: controller,
      progress: progress,
      isSender: isSender,
      isPlaying: isPlaying,
      isFrontCamera: isFrontCamera,
      onTap: onTap,
      isExpanded: isExpanded,
      backgroundColor: context.isDarkMode
        ? ChatifyColors.greenMessageBorderDark
        : ChatifyColors.greenMessageLight,
    );
  }
}
