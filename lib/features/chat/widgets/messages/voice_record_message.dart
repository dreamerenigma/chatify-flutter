import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../painters/voice_track_painter.dart';

class VoiceRecordMessage extends StatefulWidget {
  final MessageModel message;
  final UserModel user;
  final bool isSender;

  const VoiceRecordMessage({
    super.key,
    required this.message,
    required this.user,
    required this.isSender,
  });

  @override
  State<VoiceRecordMessage> createState() => _VoiceRecordMessageState();
}

class _VoiceRecordMessageState extends State<VoiceRecordMessage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool isLoadingProfileImage = false;
  String? _profileImageUrl;
  double _progress = 0.0;
  double _playbackSpeed = 1.0;
  Duration _currentPosition = Duration.zero;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.positionStream.listen((position) {
      if (!mounted) return;

      final playerDuration = _audioPlayer.duration;
      final totalDuration = playerDuration ?? Duration(milliseconds: widget.message.audioDuration ?? 0);

      setState(() {
        _currentPosition = position;

        if (totalDuration.inMilliseconds > 0) {
          _progress = (position.inMilliseconds / totalDuration.inMilliseconds).clamp(0.0, 1.0);
        }
      });
    });
    _audioPlayer.durationStream.listen((duration) {
      log('Audio duration: $duration');
    });
    _audioPlayer.playerStateStream.listen((state) async {
      if (!mounted) return;

      if (state.processingState == ProcessingState.completed) {
        await _audioPlayer.pause();
        await _audioPlayer.seek(Duration.zero);

        if (!mounted) return;

        setState(() {
          _isPlaying = false;
          _progress = 0.0;
          _currentPosition = Duration.zero;
        });

        return;
      }

      final isPlaying = state.playing && state.processingState != ProcessingState.completed;

      if (_isPlaying != isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
    _loadProfileImage();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
        return;
      }

      if (_audioPlayer.processingState == ProcessingState.ready) {
        await _audioPlayer.setSpeed(_playbackSpeed);
        await _audioPlayer.play();
        return;
      }

      final yandexPath = widget.message.msg;
      final url = await APIs.mediaService.getUrl(yandexPath);

      if (url == null || url.isEmpty) {
        throw Exception(
          'Failed to get Yandex Disk download URL',
        );
      }

      await _audioPlayer.setUrl(url);
      await _audioPlayer.setSpeed(_playbackSpeed);

      await _audioPlayer.play();
    } catch (e, stackTrace) {
      log('VOICE PLAYBACK ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _changePlaybackSpeed() async {
    final newSpeed = switch (_playbackSpeed) {
      1.0 => 1.5, 1.5 => 2.0, _ => 1.0
    };

    setState(() {
      _playbackSpeed = newSpeed;
    });

    await _audioPlayer.setSpeed(newSpeed);
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      log('PROFILE IMAGE: resolved URL = $url');

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        isLoadingProfileImage = false;
      });

      log('PROFILE IMAGE URL: $_profileImageUrl');
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: widget.message.audioDuration ?? 0);

    return SizedBox(
      height: 54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: widget.isSender ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: GestureDetector(
              onTap: _changePlaybackSpeed,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isPlaying
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        key: const ValueKey('speed'),
                        width: 60,
                        height: 33,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black.withValues(alpha: 0.25) : ChatifyColors.grey, borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          '${_playbackSpeed % 1 == 0 ? _playbackSpeed.toInt() : _playbackSpeed}x',
                          style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w600, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                _profileImageUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) {
                                  return Container(color: ChatifyColors.grey, child: SvgPicture.asset(ChatifyVectors.profile, width: 50, height: 50));
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            left: widget.isSender ? -6 : null,
                            right: widget.isSender ? null : -6,
                            bottom: -2,
                            child: SvgPicture.asset(ChatifyVectors.microphoneFilled, width: 21, height: 21),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: _togglePlayback,child: SvgPicture.asset(_isPlaying ? ChatifyVectors.pauseFilled : ChatifyVectors.playFilled, width: 27, height: 27, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildWaveform()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Text(
                    _formatDuration(duration),
                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, height: 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final progress = (localPosition.dx / renderBox.size.width).clamp(0.0, 1.0);

        setState(() {
          _progress = progress;
        });
      },

      child: SizedBox(
        width: double.infinity,
        height: 30,
        child: CustomPaint(
          painter: VoiceTrackPainter(
            progress: _progress,
            color: context.isDarkMode ? ChatifyColors.darkGrey.withValues(alpha: 0.5) : ChatifyColors.grey,
            activeColor: ChatifyColors.darkGrey,
            markerColor: ChatifyColors.lightBlueLink,
          ),
        ),
      ),
    );
  }
}
