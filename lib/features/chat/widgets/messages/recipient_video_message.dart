import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/chat/widgets/messages/video_circle_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:video_player/video_player.dart';
import '../../../../api/apis.dart';
import '../../../../core/services/media/yandex/yandex_disk_api.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../models/message_model.dart';
import 'message_meta.dart';

class RecipientVideoMessage extends StatefulWidget {
  final MessageModel message;
  final bool isExpanded;
  final VoidCallback? onCollapse;
  final ValueChanged<bool> onExpandedChanged;

  const RecipientVideoMessage({
    super.key,
    required this.message,
    required this.isExpanded,
    required this.onExpandedChanged,
    this.onCollapse,
  });

  @override
  State<RecipientVideoMessage> createState() => _RecipientVideoMessageState();
}

class _RecipientVideoMessageState extends State<RecipientVideoMessage> {
  final YandexDiskApi _yandexDiskApi = YandexDiskApi();
  VideoPlayerController? _videoController;
  double videoProgress = 0.0;
  bool isVideoPlaying = false;
  bool isFrontCamera = false;

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

  @override
  void didUpdateWidget(covariant RecipientVideoMessage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isExpanded != widget.isExpanded) {
      _updateVideoVolume();
    }
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

    widget.onExpandedChanged(true);
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

      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

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
      log('VIDEO INIT ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
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
        decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageLight),
      );
    }

    return VideoCircleMessage(
      message: widget.message,
      isSender: false,
      user: APIs.me,
      controller: controller,
      progress: videoProgress,
      isPlaying: isVideoPlaying,
      isFrontCamera: isFrontCamera,
      onTap: _playVideo,
      isExpanded: widget.isExpanded,
      backgroundColor: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageLight,
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
            if (!Platform.isWindows)
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey.withAlpha((0.7 * 255).toInt()),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 20, height: 20, colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                ),
              ),
            const SizedBox(width: 16),
            Padding(padding: const EdgeInsets.only(right: 10), child: _buildVideoCircleMessage()),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageLight, borderRadius: BorderRadius.circular(25)),
            child: MessageMeta(message: widget.message, isWebOrWindows: Platform.isWindows, showCheck: true, isSender: false, fitContent: true),
          ),
        ),
      ],
    );
  }
}
