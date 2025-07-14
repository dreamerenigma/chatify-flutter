import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/formatters/formatter.dart';
import '../../chat/widgets/bars/full_screen_video_app_bar.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class FullScreenVideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final int initialIndex;

  const FullScreenVideoPlayerWidget({super.key, required this.videoUrls, this.initialIndex = 0});

  @override
  State<FullScreenVideoPlayerWidget> createState() => _FullScreenVideoPlayerWidgetState();
}

class _FullScreenVideoPlayerWidgetState extends State<FullScreenVideoPlayerWidget> {
  late int _activeIndex;
  late final Player _player;
  late final VideoController _controller;
  StreamSubscription? _positionSub;
  final PageController _pageController = PageController();
  bool isInitialized = false;
  bool _isEnded = false;
  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  double _currentScale = 1.0;
  Timer? _positionUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _activeIndex = (widget.videoUrls.isNotEmpty) ? widget.initialIndex.clamp(0, widget.videoUrls.length - 1) : 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_activeIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _positionUpdateTimer?.cancel();
    _positionSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    _player = Player();
    _controller = VideoController(_player);

    await _player.open(Media(widget.videoUrls[_activeIndex]));

    _positionUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted && _player.state.playing) {
        setState(() {});
      }
    });

    _positionSub = _player.stream.position.listen((position) {
      final duration = _player.state.duration;
      if (duration != Duration.zero && position >= duration && !_player.state.playing) {
        setState(() {
          _isEnded = true;
        });
      }
    });

    setState(() {
      isInitialized = true;
    });
  }

  Future<Uint8List?> _getVideoThumbnail(String url) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 75,
      );
      return thumbnail;
    } catch (e) {
      return null;
    }
  }

  void _changeIndex(int delta) {
    final newIndex = (_activeIndex + delta).clamp(0, widget.videoUrls.length - 1);
    setState(() {
      _activeIndex = newIndex;
    });

    _pageController.animateToPage(
      _activeIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
      appBar: const FullScreenVideoAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.videoUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _activeIndex = index;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            minScale: 1.0,
                            maxScale: 4.0,
                            onInteractionUpdate: (details) {
                              setState(() {
                                _currentScale = details.scale;
                              });
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                if (_currentScale > 1.0) {
                                  SystemMouseCursors.zoomIn;
                                }
                              },
                              onExit: (_) {
                                SystemMouseCursors.basic;
                              },
                              child: Video(controller: _controller, controls: null, fill: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() => _isLeftPressed = true);
                        _changeIndex(-1);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() => _isLeftPressed = false);
                        });
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      borderRadius: BorderRadius.circular(6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        child: Transform.translate(
                          offset: _isLeftPressed ? const Offset(-2, 0) : Offset.zero,
                          child: const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(Icons.arrow_back_ios, color: ChatifyColors.white, size: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() => _isRightPressed = true);
                        _changeIndex(1);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() => _isRightPressed = false);
                        });
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      borderRadius: BorderRadius.circular(6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        child: Transform.translate(
                          offset: _isRightPressed ? const Offset(2, 0) : Offset.zero,
                          child: const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(Icons.arrow_forward_ios, color: ChatifyColors.white, size: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildVideoPanel(),
          _buildBottomGrid(),
        ],
      ),
    );
  }

  Widget _buildVideoPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_controller.player.state.playing) {
                      _controller.player.pause();
                    } else {
                      if (_isEnded) {
                        _controller.player.seek(Duration.zero);
                        _isEnded = false;
                      }
                      _controller.player.play();
                    }
                  });
                },
                mouseCursor: SystemMouseCursors.basic,
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Icon((_isEnded || !_controller.player.state.playing) ? PhosphorIcons.play_fill : PhosphorIcons.pause, color: ChatifyColors.white, size: 21),
                ),
              ),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(Formatter.formatDuration(_controller.player.state.position), style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
            ),
            Expanded(
              child: Slider(
                value: _controller.player.state.position.inMilliseconds.toDouble(),
                max: _controller.player.state.duration.inMilliseconds.toDouble().clamp(1.0, double.infinity),
                onChanged: (value) {
                  _controller.player.seek(Duration(milliseconds: value.toInt()));
                  setState(() {});
                },
                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                inactiveColor: ChatifyColors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(Formatter.formatFullDuration(_controller.player.state.duration), style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
            ),
            SizedBox(width: 20),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_controller.player.state.playing) {
                      _controller.player.pause();
                    } else {
                      if (_isEnded) {
                        _controller.player.seek(Duration.zero);
                        _isEnded = false;
                      }
                      _controller.player.play();
                    }
                  });
                },
                mouseCursor: SystemMouseCursors.basic,
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: HeroIcon(HeroIcons.speakerWave, color: ChatifyColors.white, size: 21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomGrid() {
    if (widget.videoUrls.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Center(child: Text("No videos available")),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(widget.videoUrls.length, (index) {
              final isActive = index == _activeIndex;
              final isHovered = ValueNotifier(false);
              final scale = ValueNotifier<double>(1.0);

              return ValueListenableBuilder<bool>(
                valueListenable: isHovered,
                builder: (context, hovered, _) {
                  return ValueListenableBuilder<double>(
                    valueListenable: scale,
                    builder: (context, scaleValue, _) {
                      return GestureDetector(
                        onTapDown: (_) => scale.value = 0.98,
                        onTapUp: (_) => scale.value = 1.0,
                        onTapCancel: () => scale.value = 1.0,
                        onLongPressStart: (_) => scale.value = 0.98,
                        onLongPressEnd: (_) => scale.value = 1.0,
                        onTap: () {
                          setState(() {
                            _activeIndex = index;
                          });
                          _pageController.animateToPage(_activeIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        child: MouseRegion(
                          onEnter: (_) {
                            if (!isActive) isHovered.value = true;
                          },
                          onExit: (_) {
                            if (!isActive) isHovered.value = false;
                          },
                          child: AnimatedScale(
                            scale: scaleValue,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeOutCubic,
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  width: 50,
                                  height: 50,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                    borderRadius: BorderRadius.circular(6),
                                    border: isActive ? Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.5) : null,
                                  ),
                                  child: FutureBuilder<Uint8List?>(
                                    future: _getVideoThumbnail(widget.videoUrls[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 2),
                                        );
                                      } else if (snapshot.hasData) {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      } else {
                                        return const Icon(Icons.videocam_off, color: ChatifyColors.white);
                                      }
                                    },
                                  ),
                                ),
                                if (!isActive && hovered)
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Container(
                                      decoration: BoxDecoration(color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()), borderRadius: BorderRadius.circular(6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
