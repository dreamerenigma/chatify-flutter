import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

class VideoCircleMessage extends StatefulWidget {
  final MessageModel message;
  final UserModel user;
  final VideoPlayerController controller;
  final double progress;
  final bool isSender;
  final bool isExpanded;
  final bool isPlaying;
  final bool isFrontCamera;
  final Color backgroundColor;
  final VoidCallback onTap;

  const VideoCircleMessage({
    super.key,
    required this.message,
    required this.user,
    required this.controller,
    required this.progress,
    required this.isExpanded,
    required this.isPlaying,
    required this.isFrontCamera,
    required this.backgroundColor,
    required this.onTap,
    required this.isSender,
  });

  @override
  State<VideoCircleMessage> createState() => _VideoCircleMessageState();
}

class _VideoCircleMessageState extends State<VideoCircleMessage> {
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.isExpanded ? 260.0 : 200.0;
    final videoSize = widget.isExpanded ? 260.0 : 200.0;
    final isFinished = widget.progress >= 1.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: videoSize,
              height: videoSize,
              child: ClipOval(
                child: SizedBox(
                  width: videoSize,
                  height: videoSize,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: widget.controller.value.size.width,
                      height: widget.controller.value.size.height,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: widget.isFrontCamera ? (Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0)) : Matrix4.identity(),
                        child: VideoPlayer(widget.controller),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!widget.isExpanded && !isFinished) ...[
                    SvgPicture.asset(ChatifyVectors.speakerOff, width: 11, height: 11, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                    SizedBox(width: 6),
                  ],
                  Text(
                    _formatDuration(widget.controller.value.position),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ChatifyColors.white, fontSize: 13, fontWeight: FontWeight.w600, shadows: [Shadow(color: ChatifyColors.black, blurRadius: 4)]),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: widget.progress,
                strokeWidth: 4,
                backgroundColor: widget.backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(isFinished ? ChatifyColors.transparent : colorsController.getColor(colorsController.selectedColorScheme.value)),
              ),
            ),
            if (!widget.isPlaying)
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.black.withAlpha((0.4 * 255).toInt())),
                  alignment: Alignment.center,
                  child: const Icon(Icons.play_arrow_rounded, color: ChatifyColors.white, size: 44),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
