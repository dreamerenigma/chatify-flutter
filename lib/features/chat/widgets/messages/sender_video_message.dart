import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:video_player/video_player.dart';
import '../../../../api/apis.dart';
import '../../../../core/services/media/yandex/yandex_disk_api.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../models/message_model.dart';
import '../../screens/video_message_screen.dart';
import 'message_meta.dart';
import 'video_circle_message.dart';

class SenderVideoMessage extends StatefulWidget {
  final MessageModel message;
  final bool isExpanded;
  final double swipeProgress;
  final VoidCallback? onCollapse;
  final ValueChanged<bool> onExpandedChanged;

  const SenderVideoMessage({
    super.key,
    required this.message,
    required this.isExpanded,
    required this.swipeProgress,
    required this.onExpandedChanged,
    this.onCollapse,
  });

  @override
  State<SenderVideoMessage> createState() => _SenderVideoMessageState();
}

class _SenderVideoMessageState extends State<SenderVideoMessage> {
  final YandexDiskApi _yandexDiskApi = YandexDiskApi();
  VideoPlayerController? _videoController;
  bool isVideoPlaying = false;
  bool isFrontCamera = false;
  double videoProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      final path = widget.message.msg;

      if (path.isEmpty) {
        return;
      }

      final videoUrl = await _yandexDiskApi.getDownloadUrl(path);

      if (videoUrl == null || videoUrl.isEmpty) {
        return;
      }

      final uri = Uri.tryParse(videoUrl);

      if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) {
        return;
      }

      final controller = VideoPlayerController.networkUrl(uri);

      await controller.initialize();

      controller.addListener(_videoListener);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
        videoProgress = 0.0;
      });

      _updateVideoVolume();
    } catch (e, stackTrace) {
      log('$stackTrace');
    }
  }

  void _videoListener() {
    final controller = _videoController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final duration = controller.value.duration;
    final position = controller.value.position;

    if (duration.inMilliseconds <= 0) {
      return;
    }

    final progress = (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    final isFinished = position >= duration;

    if (!mounted) return;

    setState(() {
      videoProgress = progress;

      if (isFinished) {
        isVideoPlaying = false;
      }
    });

    if (isFinished && widget.isExpanded) {
      widget.onExpandedChanged(false);
    }
  }

  void _updateVideoVolume() {
    final controller = _videoController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    controller.setVolume(widget.isExpanded ? 1.0 : 0.0);
  }

  Future<void> _playVideo() async {
    final controller = _videoController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      await controller.pause();

      if (!mounted) return;

      setState(() {
        isVideoPlaying = false;
      });

      return;
    }

    if (controller.value.position >= controller.value.duration) {
      await controller.seekTo(Duration.zero);
    }

    await controller.play();

    if (!mounted) return;

    setState(() {
      isVideoPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessageContent();
  }

  Widget _buildVideoCircleMessage() {
    final controller = _videoController;

    if (controller == null || !controller.value.isInitialized) {
      return Container(
        width: 195,
        height: 195,
        decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight),
      );
    }

    return GestureDetector(
      onTap: _playVideo,
      child: VideoCircleMessage(
        message: widget.message,
        isSender: true,
        user: APIs.me,
        controller: controller,
        progress: videoProgress,
        isPlaying: isVideoPlaying,
        isFrontCamera: isFrontCamera,
        onTap: _playVideo,
        isExpanded: widget.isExpanded,
        backgroundColor: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight,
      ),
    );
  }

  Widget _buildMessageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.only(left: 10), child: _buildVideoCircleMessage()),
            const SizedBox(width: 8),
            if (!Platform.isWindows)
              _buildCameraButton(),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.blueMessageLight, borderRadius: BorderRadius.circular(25)),
            child: MessageMeta(message: widget.message, isWebOrWindows: Platform.isWindows, showCheck: true, isSender: true, fitContent: true),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraButton() {
    final progress = widget.swipeProgress.clamp(0.0, 1.0);

    return Opacity(
      opacity: 1.0 - progress,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey.withAlpha((0.7 * 255).toInt()),
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            ChatifyVectors.cameraFilled,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.push(context, createPageRoute(const VideoMessageScreen()));
          },
        ),
      ),
    );
  }
}
