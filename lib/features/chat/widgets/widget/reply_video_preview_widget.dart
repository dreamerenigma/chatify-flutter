import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:video_player/video_player.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';

class ReplyVideoPreviewWidget extends StatefulWidget {
  final String videoPath;

  const ReplyVideoPreviewWidget({
    super.key,
    required this.videoPath,
  });

  @override
  State<ReplyVideoPreviewWidget> createState() => _ReplyVideoPreviewWidgetState();
}

class _ReplyVideoPreviewWidgetState extends State<ReplyVideoPreviewWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      final url = await APIs.mediaService.getUrl(widget.videoPath);

      if (url == null || url.isEmpty) {
        return;
      }

      final uri = Uri.tryParse(url);

      if (uri == null || uri.host.isEmpty) {
        return;
      }

      final controller = VideoPlayerController.networkUrl(uri);

      await controller.initialize();
      await controller.seekTo(Duration.zero);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
      });
    } catch (e, stackTrace) {
      log('REPLY VIDEO PREVIEW ERROR: $e', stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final isInitialized = controller != null && controller.value.isInitialized;

    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: controller != null && controller.value.isInitialized
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(width: controller.value.size.width, height: controller.value.size.height, child: VideoPlayer(controller)),
          )
        : Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: Container(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonGrey)),
              const Center(child: Icon(Icons.videocam_outlined, size: 24, color: ChatifyColors.white)),
            ],
          ),
    );
  }
}