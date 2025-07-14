import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/formatters/formatter.dart';
import '../../chat/widgets/bars/full_screen_video_app_bar.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class FullScreenVideoPlayerScreen extends StatefulWidget {
  final List<String> videoUrls;
  final int initialIndex;

  const FullScreenVideoPlayerScreen({super.key, required this.videoUrls, this.initialIndex = 0});

  @override
  FullScreenVideoPlayerScreenState createState() => FullScreenVideoPlayerScreenState();
}

class FullScreenVideoPlayerScreenState extends State<FullScreenVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrls[widget.initialIndex]),)..initialize().then((_) {
      setState(() {
        _controller.play();
        _isPlaying = true;
      });
    });

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
          if (_controller.value.position == _controller.value.duration) {
            _isPlaying = false;
            _showControls = true;
          }
        });
      }
    });
    _startHideTimer();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    setState(() {
      _showControls = true;
    });
    _startHideTimer();
  }

  void _togglePlayback() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _resetHideTimer();
      } else {
        _controller.play();
        _resetHideTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _resetHideTimer();
        _togglePlayback();
      },
      child: Scaffold(
        backgroundColor: ChatifyColors.black,
        body: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized
                ? GestureDetector(
                onTap: () {
                  _togglePlayback();
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
            ),
            if (!_isPlaying && _showControls)
            Center(
              child: GestureDetector(
                onTap: () {
                  _togglePlayback();
                },
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.black.withAlpha((0.5 * 255).toInt())),
                  padding: const EdgeInsets.all(4.0),
                  child: const Icon(Icons.play_arrow, size: 50, color: ChatifyColors.white),
                ),
              ),
            ),
            Visibility(
              visible: _showControls,
              child: Column(
                children: [
                  GestureDetector(onTap: () {}, child: const FullScreenVideoAppBar()),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(Formatter.formatDuration(_controller.value.position), style: const TextStyle(color: ChatifyColors.white)),
                            ),
                            Expanded(
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: VideoProgressColors(playedColor: colorsController.getColor(colorsController.selectedColorScheme.value), backgroundColor: ChatifyColors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                Formatter.formatFullDuration(_controller.value.duration),
                                style: const TextStyle(color: ChatifyColors.white),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
