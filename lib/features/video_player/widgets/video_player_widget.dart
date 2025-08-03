import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/video_player/screens/fullscreen_video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/message_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import 'fullscreen_video_player_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final MessageModel message;

  const VideoPlayerWidget({super.key, required this.videoUrls, required this.message});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  Player? _player;
  VideoController? _controller;
  bool isOffline = false;
  bool isInitialized = false;
  Duration? videoDuration;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() => isOffline = true);
    } else {
      log(S.of(context).deviceIsOnline);
    }

    try {
      final player = Player();

      int index = widget.videoUrls.indexWhere((url) => url.trim() == widget.message.msg.trim());
      final currentIndex = (index >= 0 && widget.videoUrls.isNotEmpty) ? index.clamp(0, widget.videoUrls.length - 1) : 0;
      final videoUrl = widget.videoUrls[currentIndex];
      await player.open(Media(videoUrl));
      final controller = VideoController(player);
      final duration = await player.stream.duration.first;

      setState(() {
        _player = player;
        _controller = controller;
        videoDuration = duration;
        isInitialized = true;
      });
    } catch (e) {
      log('${S.of(context).errorInitializingMediaKitVideo}: $e');
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = _player;
    final controller = _controller;
    int index = widget.videoUrls.indexWhere((url) => url.trim() == widget.message.msg.trim());
    final currentIndex = (index >= 0 && widget.videoUrls.isNotEmpty) ? index.clamp(0, widget.videoUrls.length - 1) : 0;

    Widget mediaWidget = (isInitialized && player != null && controller != null)
      ? GestureDetector(
        onTap: () {
          if (Platform.isWindows) {
            showDialog(context: context, builder: (context) => FullScreenVideoPlayerWidget(videoUrls: widget.videoUrls, initialIndex: currentIndex));
          } else {
            Navigator.push(context, createPageRoute(FullScreenVideoPlayerScreen(videoUrls: widget.videoUrls, initialIndex: currentIndex)));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(width: 250, height: 112, child: Video(controller: controller, controls: null)),
            ),
            StreamBuilder<bool>(
              stream: player.stream.playing,
              builder: (_, snapshot) {
                final playing = snapshot.data ?? false;
                if (!playing) {
                  return Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: Platform.isWindows ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: Platform.isWindows ? BorderRadius.circular(4) : null,
                      color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()),
                    ),
                    child: Icon(Platform.isWindows ? PhosphorIcons.play : Icons.play_arrow_rounded, size: Platform.isWindows ? 18 : 26, color: ChatifyColors.white),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      )
      : Container(
        width: 250,
        height: 112,
        decoration: BoxDecoration(color: ChatifyColors.black, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
          ),
        ),
      );

    return Column(
      children: [
        mediaWidget,
        if (isOffline)
        Text(S.of(context).offlineCachedVideos, style: const TextStyle(color: ChatifyColors.red)),
      ],
    );
  }
}
