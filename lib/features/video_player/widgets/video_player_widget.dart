import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/video_player/screens/fullscreen_video_player_screen.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/message_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import 'fullscreen_video_player_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final MessageModel message;
  final ValueChanged<Duration>? onPositionChanged;
  final VoidCallback? onVideoStarted;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrls,
    required this.message,
    this.onPositionChanged,
    this.onVideoStarted,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  Player? _player;
  VideoController? _controller;
  bool isOffline = false;
  bool isInitialized = false;
  Duration? videoDuration;
  StreamSubscription<Duration>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _player?.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        if (mounted) {
          setState(() {
            isOffline = true;
          });
        }

        return;
      }

      if (widget.videoUrls.isEmpty) {
        return;
      }

      final player = Player();
      final index = widget.videoUrls.indexWhere((url) => url.trim() == widget.message.msg.trim());
      final currentIndex = (index >= 0 && widget.videoUrls.isNotEmpty) ? index.clamp(0, widget.videoUrls.length - 1) : 0;
      final videoPath = widget.videoUrls[currentIndex];
      final videoUrl = await APIs.getMediaUrl(videoPath);

      if (videoUrl!.isEmpty) {
        await player.dispose();
        return;
      }

      await player.open(Media(videoUrl), play: false);

      final controller = VideoController(player);

      _positionSubscription = player.stream.position.listen((position) {
        widget.onPositionChanged?.call(position);
      });

      final duration = await player.stream.duration.first;

      if (!mounted) {

        await player.dispose();
        return;
      }

      setState(() {
        _player = player;
        _controller = controller;
        videoDuration = duration;
        isInitialized = true;
      });
    } catch (e, stackTrace) {
      log('VIDEO ERROR: $e');
      log('VIDEO STACK: $stackTrace');
      if (mounted) {
        setState(() {
          isInitialized = false;
        });
      }
    }
  }

  void _openFullscreen(int currentIndex) {
    if (Platform.isWindows) {
      showDialog(context: context, builder: (context) => FullScreenVideoPlayerWidget(videoUrls: widget.videoUrls, initialIndex: currentIndex));
    } else {
      Navigator.push(context, createPageRoute(FullScreenVideoPlayerScreen(videoUrls: widget.videoUrls, initialIndex: currentIndex)));
    }
  }

  Future<void> _togglePlayPause() async {
    final player = _player;

    if (player == null) return;

    if (player.state.playing) {
      await player.pause();
    } else {
      widget.onVideoStarted?.call();
      await player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = _player;
    final controller = _controller;
    int index = widget.videoUrls.indexWhere((url) => url.trim() == widget.message.msg.trim());
    final currentIndex = (index >= 0 && widget.videoUrls.isNotEmpty) ? index.clamp(0, widget.videoUrls.length - 1) : 0;

    Widget mediaWidget = (isInitialized && player != null && controller != null)
      ? GestureDetector(
          onTap: _togglePlayPause,
          onDoubleTap: () => _openFullscreen(currentIndex),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(width: 250, height: 140, child: Video(controller: controller, controls: null, fit: BoxFit.cover)),
              ),
              StreamBuilder<bool>(
                stream: player.stream.playing,
                builder: (_, snapshot) {
                  final playing = snapshot.data ?? false;

                  if (!playing) {
                    return Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: Platform.isWindows ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius: Platform.isWindows ? BorderRadius.circular(4) : null,
                        color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()),
                      ),
                      child: Platform.isWindows
                        ? SvgPicture.asset(ChatifyVectors.playFilled, width: 18, height: 18, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn))
                        : Icon(Icons.play_arrow_rounded, size: 46, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      ),
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
          height: 145,
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
          Text(S.of(context).offlineCachedVideos, style: TextStyle(color: ChatifyColors.danger, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
