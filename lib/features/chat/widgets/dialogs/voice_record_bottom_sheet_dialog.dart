import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../api/apis.dart';
import '../../../../core/services/voice/voice_recorder_service.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../controls/voice_recording_control.dart';
import '../widget/voice_record_track_widget.dart';

void showVoiceRecordBottomSheetDialog(BuildContext context, UserModel user) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    showDragHandle: false,
    barrierColor: ChatifyColors.transparent,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (_) {
      return VoiceRecordBottomSheetContent(
        user: user,
        onRecordingFinished: (String localPath) async {
          await APIs.sendVoiceMessage(user, localPath);
        },
      );
    },
  );
}

class VoiceRecordBottomSheetContent extends StatefulWidget {
  final UserModel user;
  final Future<void> Function(String localPath) onRecordingFinished;

  const VoiceRecordBottomSheetContent({
    super.key,
    required this.user,
    required this.onRecordingFinished,
  });

  @override
  State<VoiceRecordBottomSheetContent> createState() => _VoiceRecordBottomSheetContentState();
}

class _VoiceRecordBottomSheetContentState extends State<VoiceRecordBottomSheetContent> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final VoiceRecorderService _recorderService = VoiceRecorderService();
  late final AnimationController _waveController;
  bool _isPaused = false;
  bool _isTimerActive = false;
  bool _isPlaying = false;
  double _smoothedLevel = 0.0;
  double _trackPosition = 0.0;
  String? _recordedFilePath;
  Timer? _recordTimer;
  DateTime? _recordStartedAt;
  DateTime? _pauseStartedAt;
  Duration _recordDuration = Duration.zero;
  Duration _pausedDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;

  static const Duration _maxRecordDuration = Duration(minutes: 20);

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _audioPlayer.positionStream.listen((position) {
      if (!mounted) return;

      setState(() {
        _playbackPosition = position;
        if (_playbackDuration.inMilliseconds > 0) {
          _trackPosition = position.inMilliseconds / _playbackDuration.inMilliseconds;
          _trackPosition = _trackPosition.clamp(0.0, 1.0);
        }
      });
    });
    _audioPlayer.durationStream.listen((duration) {
      if (!mounted || duration == null) return;

      setState(() {
        _playbackDuration = duration;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state.playing;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRecording();
    });
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _waveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void updateVoiceLevel(double value) {
    value = value.clamp(0.0, 1.0);
    _smoothedLevel += (value - _smoothedLevel) * 0.18;
  }

  void _startRecordTimer() {
    _recordTimer?.cancel();

    _recordStartedAt = DateTime.now();
    _pausedDuration = Duration.zero;
    _recordDuration = Duration.zero;

    _recordTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (_) {
        if (!mounted || _isPaused || _recordStartedAt == null) {
          return;
        }

        final elapsed = DateTime.now().difference(_recordStartedAt!) - _pausedDuration;

        if (elapsed >= _maxRecordDuration) {
          _finishVoiceRecording();
          return;
        }

        setState(() {
          _recordDuration = elapsed;
        });
      },
    );
  }

  Future<void> _onTrackChanged(double value) async {
    value = value.clamp(0.0, 1.0);

    if (_playbackDuration == Duration.zero) {
      return;
    }

    final position = Duration(milliseconds: (_playbackDuration.inMilliseconds * value).round());

    await _audioPlayer.seek(position);

    if (!mounted) return;

    setState(() {
      _trackPosition = value;
      _playbackPosition = position;
    });
  }

  Future<void> _startRecording() async {
    log('========== START RECORDING ==========');

    try {
      log('Starting AudioRecorder...');

      final path = await _recorderService.start();

      _recordedFilePath = path;

      log('AudioRecorder.start() completed');
      log('Recording path: $path');

      final isRecording = await _recorderService.isRecording();

      log('isRecording after start: $isRecording');

      if (!mounted) return;

      _startRecordTimer();

      log('Record timer started');
    } catch (e, stack) {
      log(
        'START RECORDING ERROR: $e',
        stackTrace: stack,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }

    log('======================================');
  }

  Future<void> _pauseRecording() async {
    log('========== PAUSE RECORDING ==========');

    if (_isPaused) {
      log('Pause ignored: already paused');
      return;
    }

    try {
      final beforeRecording = await _recorderService.isRecording();

      log('isRecording BEFORE pause: $beforeRecording');
      log('Current recorded path: $_recordedFilePath');
      log('Current record duration: $_recordDuration');

      log('Calling AudioRecorder.pause()...');

      await _recorderService.pause();

      log('AudioRecorder.pause() completed');

      final afterRecording = await _recorderService.isRecording();

      log('isRecording AFTER pause: $afterRecording');

      _waveController.stop();

      if (!mounted) return;

      setState(() {
        _isPaused = true;
        _pauseStartedAt = DateTime.now();
      });

      log('UI state changed: _isPaused = true');
    } catch (e, stack) {
      log(
        'PAUSE RECORDING ERROR: $e',
        stackTrace: stack,
      );
    }

    log('====================================');
  }

  Future<void> _resumeRecording() async {
    log('========== RESUME RECORDING ==========');

    if (!_isPaused) {
      log('Resume ignored: not paused');
      return;
    }

    if (_pauseStartedAt == null) {
      log('Resume ignored: _pauseStartedAt is null');
      return;
    }

    try {
      log('Current recorded path: $_recordedFilePath');
      log('Paused since: $_pauseStartedAt');

      final beforeRecording = await _recorderService.isRecording();

      log('isRecording BEFORE resume: $beforeRecording');

      log('Calling AudioRecorder.resume()...');

      await _recorderService.resume();

      log('AudioRecorder.resume() completed');

      final afterRecording = await _recorderService.isRecording();

      log('isRecording AFTER resume: $afterRecording');

      _pausedDuration += DateTime.now().difference(_pauseStartedAt!);

      log('Total paused duration: $_pausedDuration');

      _waveController.repeat();

      if (!mounted) return;

      setState(() {
        _isPaused = false;
        _pauseStartedAt = null;
      });

      log('UI state changed: _isPaused = false');
    } catch (e, stack) {
      log(
        'RESUME RECORDING ERROR: $e',
        stackTrace: stack,
      );
    }

    log('======================================');
  }

  Future<void> _finishVoiceRecording() async {
    log('========== FINISH RECORDING ==========');

    try {
      _recordTimer?.cancel();
      _recordTimer = null;

      log('Record timer cancelled');

      _waveController.stop();

      final isRecording = await _recorderService.isRecording();

      log('isRecording BEFORE finish: $isRecording');
      log('Current recorded path: $_recordedFilePath');
      log('Current record duration: $_recordDuration');

      if (isRecording) {
        log('Calling AudioRecorder.stop()...');

        final stoppedPath = await _recorderService.stop();

        log('AudioRecorder.stop() returned: $stoppedPath');

        if (stoppedPath != null) {
          _recordedFilePath = stoppedPath;
          log('Updated recorded path: $_recordedFilePath');
        }
      } else {
        log('Recorder is not active, stop() skipped');
      }

      log('Final recorded path: $_recordedFilePath');

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e, stack) {
      log(
        'FINISH RECORDING ERROR: $e',
        stackTrace: stack,
      );
    }

    log('======================================');
  }

  Future<void> _cancelVoiceRecording() async {
    _recordTimer?.cancel();
    _recordTimer = null;

    _waveController.stop();

    if (await _recorderService.isRecording()) {
      await _recorderService.stop();
    }

    if (!mounted) return;

    setState(() {
      _recordDuration = Duration.zero;
      _isPaused = false;
      _recordStartedAt = null;
      _pauseStartedAt = null;
      _pausedDuration = Duration.zero;
      _smoothedLevel = 0.0;
    });

    Navigator.pop(context);
  }

  Future<void> _playRecordedAudio() async {
    log('========== PLAY RECORDED AUDIO ==========');

    final path = _recordedFilePath;

    log('Recorded path: $path');

    if (path == null) {
      log('❌ PATH IS NULL');
      return;
    }

    final file = File(path);

    final exists = await file.exists();
    log('File exists: $exists');

    if (exists) {
      final size = await file.length();
      log('File size: $size bytes');
    }

    try {

    } catch (e, stack) {
      log('❌ PLAYBACK ERROR: $e', stackTrace: stack);
    }

    log('==========================================');
  }

  Future<void> _sendVoiceMessage() async {
    log('========== SEND VOICE MESSAGE ==========');

    try {
      final isRecording = await _recorderService.isRecording();

      log('isRecording before send: $isRecording');
      log('Current recorded path: $_recordedFilePath');

      _recordTimer?.cancel();
      _recordTimer = null;

      _waveController.stop();

      if (isRecording) {
        log('Stopping recorder before sending...');

        final stoppedPath = await _recorderService.stop();

        log('Recorder stopped. Path: $stoppedPath');

        if (stoppedPath != null && stoppedPath.isNotEmpty) {
          _recordedFilePath = stoppedPath;
        }
      }

      final path = _recordedFilePath;

      log('Final voice path: $path');

      if (path == null || path.isEmpty) {
        log('❌ Voice path is null or empty');
        return;
      }

      final file = File(path);
      final exists = await file.exists();

      log('Voice file exists: $exists');

      if (!exists) {
        log('❌ Voice file does not exist: $path');
        return;
      }

      final fileSize = await file.length();

      log('Voice file size: $fileSize bytes');

      if (fileSize == 0) {
        log('❌ Voice file is empty');
        return;
      }

      log('Voice file is ready to upload: $path');

      if (!mounted) return;

      await widget.onRecordingFinished(path);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e, stack) {
      log('❌ SEND VOICE MESSAGE ERROR: $e', stackTrace: stack);
    }

    log('==========================================');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceRecordTrack(
              isPaused: _isPaused,
              isPlaying: _isPlaying,
              isTimerActive: _isTimerActive,
              recordDuration: _recordDuration,
              playbackPosition: _playbackPosition,
              playbackDuration: _playbackDuration,
              trackPosition: _trackPosition,
              smoothedLevel: _smoothedLevel,
              waveAnimation: _waveController,
              onPlaybackTap: _playRecordedAudio,
              onTrackChanged: _onTrackChanged,
              onTimerTap: () {
                setState(() {
                  _isTimerActive = !_isTimerActive;
                });
              },
            ),
            const SizedBox(height: 20),
            VoiceRecordingControls(
              isPaused: _isPaused,
              isDarkMode: context.isDarkMode,
              onCancel: _cancelVoiceRecording,
              onTogglePause: () {
                if (_isPaused) {
                  _resumeRecording();
                } else {
                  _pauseRecording();
                }
              },
              onSend: _sendVoiceMessage,
            ),
          ],
        ),
      ),
    );
  }
}
