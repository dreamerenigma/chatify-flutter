import 'dart:developer';
import 'dart:io';
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
import 'video_circle_message.dart';

class SenderVideoMessage extends StatefulWidget {
  final MessageModel message;
  final bool isExpanded;
  final VoidCallback? onCollapse;
  final ValueChanged<bool> onExpandedChanged;

  const SenderVideoMessage({
    super.key,
    required this.message,
    required this.isExpanded,
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

      log('══════════════════════════════════════');
      log('SENDER VIDEO: INITIALIZATION START');
      log('SENDER VIDEO: message path = $path');
      log('SENDER VIDEO: path empty = ${path.isEmpty}');

      if (path.isEmpty) {
        log('SENDER VIDEO ERROR: path is empty');
        return;
      }

      log('SENDER VIDEO: requesting Yandex download URL...');

      final videoUrl = await _yandexDiskApi.getDownloadUrl(path);

      log('SENDER VIDEO: download URL received');
      log('SENDER VIDEO: videoUrl = $videoUrl');
      log('SENDER VIDEO: url length = ${videoUrl?.length}');

      if (videoUrl == null || videoUrl.isEmpty) {
        log('SENDER VIDEO ERROR: videoUrl is null or empty');
        return;
      }

      final uri = Uri.tryParse(videoUrl);

      log('SENDER VIDEO: parsed URI = $uri');
      log('SENDER VIDEO: scheme = ${uri?.scheme}');
      log('SENDER VIDEO: host = ${uri?.host}');

      if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) {
        log('SENDER VIDEO ERROR: invalid video URI');
        return;
      }

      log('SENDER VIDEO: creating VideoPlayerController...');

      final controller = VideoPlayerController.networkUrl(uri);

      log('SENDER VIDEO: controller created');
      log('SENDER VIDEO: initializing controller...');

      await controller.initialize();

      log('SENDER VIDEO: controller initialized successfully');
      log('SENDER VIDEO: isInitialized = ${controller.value.isInitialized}');
      log('SENDER VIDEO: hasError = ${controller.value.hasError}');
      log('SENDER VIDEO: errorDescription = ${controller.value.errorDescription}');
      log('SENDER VIDEO: size = ${controller.value.size}');
      log('SENDER VIDEO: aspectRatio = ${controller.value.aspectRatio}');
      log('SENDER VIDEO: duration = ${controller.value.duration}');
      log('SENDER VIDEO: position = ${controller.value.position}');
      log('SENDER VIDEO: isPlaying = ${controller.value.isPlaying}');
      log('SENDER VIDEO: volume = ${controller.value.volume}');
      log('SENDER VIDEO: buffering = ${controller.value.isBuffering}');

      controller.addListener(_videoListener);

      if (!mounted) {
        log('SENDER VIDEO: widget unmounted, disposing controller');
        await controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
        videoProgress = 0.0;
      });

      log('SENDER VIDEO: controller assigned to state');
      log('SENDER VIDEO: state controller initialized = ${_videoController?.value.isInitialized}');

      _updateVideoVolume();

      log('SENDER VIDEO: volume after update = ${controller.value.volume}');
      log('SENDER VIDEO: INITIALIZATION COMPLETE');
      log('══════════════════════════════════════');
    } catch (e, stackTrace) {
      log('══════════════════════════════════════');
      log('SENDER VIDEO INIT ERROR: $e');
      log('SENDER VIDEO ERROR TYPE: ${e.runtimeType}');
      log('SENDER VIDEO STACKTRACE:');
      log('$stackTrace');
      log('══════════════════════════════════════');
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
}