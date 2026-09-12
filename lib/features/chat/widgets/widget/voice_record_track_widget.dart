import 'package:chatify/features/chat/widgets/widget/voice_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../painters/moving_dots_painter.dart';

class VoiceRecordTrack extends StatefulWidget {
  final bool isPaused;
  final bool isPlaying;
  final bool isTimerActive;
  final Duration recordDuration;
  final Duration playbackPosition;
  final Duration playbackDuration;
  final double trackPosition;
  final double smoothedLevel;
  final Animation<double> waveAnimation;
  final VoidCallback onPlaybackTap;
  final ValueChanged<double> onTrackChanged;
  final VoidCallback onTimerTap;

  const VoiceRecordTrack({
    super.key,
    required this.isPaused,
    required this.isPlaying,
    required this.isTimerActive,
    required this.recordDuration,
    required this.playbackPosition,
    required this.playbackDuration,
    required this.trackPosition,
    required this.smoothedLevel,
    required this.waveAnimation,
    required this.onPlaybackTap,
    required this.onTrackChanged,
    required this.onTimerTap,
  });

  @override
  State<VoiceRecordTrack> createState() => _VoiceRecordTrackState();
}

class _VoiceRecordTrackState extends State<VoiceRecordTrack> {
  Color get _splashColor {
    return context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isPaused)
                _buildPlayButton(context)
              else
                SizedBox(
                  width: 55,
                  child: Text(
                    _formatDuration(widget.recordDuration),
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkGrey, fontSize: 21, fontWeight: FontWeight.w400),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isPaused
                    ? VoiceTrackWidget(
                        key: const ValueKey('static-track'),
                        progress: widget.trackPosition,
                        onChanged: widget.onTrackChanged,
                        color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey,
                        activeColor: ChatifyColors.darkGrey,
                        markerColor: ChatifyColors.green,
                      )
                    : ClipRect(
                        key: const ValueKey('moving-track'),
                        child: AnimatedBuilder(
                          animation: widget.waveAnimation,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: MovingDotsPainter(
                                progress: widget.waveAnimation.value,
                                color: context.isDarkMode ? ChatifyColors.textSecondary : ChatifyColors.darkGrey,
                                level: widget.smoothedLevel,
                              ),
                              size: const Size(double.infinity, 20),
                            );
                          },
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 10),
              if (widget.isPaused)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _formatDuration(widget.recordDuration),
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _buildTimerButton(context)),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(30),
        splashColor: _splashColor,
        highlightColor: _splashColor,
        hoverColor: _splashColor,
        onTap: widget.onPlaybackTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 36,
            color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildTimerButton(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(30),
        splashColor: _splashColor,
        highlightColor: _splashColor,
        hoverColor: _splashColor,
        onTap: widget.onTimerTap,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: SvgPicture.asset(
            widget.isTimerActive ? ChatifyVectors.timerOne : ChatifyVectors.timer,
            key: ValueKey(widget.isTimerActive),
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
