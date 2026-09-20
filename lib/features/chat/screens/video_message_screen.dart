import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class VideoMessageScreen extends StatefulWidget {
  const VideoMessageScreen({super.key});

  @override
  State<VideoMessageScreen> createState() => _VideoMessageScreenState();
}

class _VideoMessageScreenState extends State<VideoMessageScreen> {
  Future<void>? initializeControllerFuture;
  CameraController? controller;
  VideoPlayerController? _videoMessageController;
  int _videoMessageDuration = 0;
  CameraLensDirection _currentLensDirection = CameraLensDirection.back;
  XFile? _recordedVideo;
  Timer? _videoMessageTimer;

  String _formatVideoMessageDuration() {
    final seconds = _videoMessageDuration.clamp(0, 59);

    return '0:${seconds.toString().padLeft(2, '0')}';
  }

  double get _videoMessageProgress {
    return (_videoMessageDuration / 60).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _videoMessageTimer?.cancel();
    controller?.dispose();
    _videoMessageController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();

    if (!mounted || !status.isGranted) {
      return;
    }

    try {
      final cameras = await availableCameras();

      if (!mounted || cameras.isEmpty) {
        return;
      }

      final camera = cameras.firstWhere((camera) => camera.lensDirection == _currentLensDirection, orElse: () => cameras.first);

      final newController = CameraController(camera, ResolutionPreset.low, enableAudio: true);

      await newController.initialize();

      if (!mounted) {
        await newController.dispose();
        return;
      }

      await newController.setFlashMode(FlashMode.off);

      if (!mounted) {
        await newController.dispose();
        return;
      }

      setState(() {
        controller = newController;
      });

      await _startVideoRecording();
    } catch (e, stackTrace) {
      log('${S.of(context).errorInitCamera}: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _switchCamera() async {
    final cameras = await availableCameras();

    if (!mounted || cameras.length < 2) {
      return;
    }

    final newLensDirection = _currentLensDirection == CameraLensDirection.front ? CameraLensDirection.back : CameraLensDirection.front;

    final newCamera = cameras.firstWhere((camera) => camera.lensDirection == newLensDirection);

    final oldController = controller;

    setState(() {
      controller = null;
      initializeControllerFuture = null;
    });

    await oldController?.dispose();

    if (!mounted) {
      return;
    }

    try {
      final newController = CameraController(newCamera, ResolutionPreset.high, enableAudio: true);

      final future = newController.initialize();

      setState(() {
        _currentLensDirection = newLensDirection;
        controller = newController;
        initializeControllerFuture = future;
      });

      await future;

      if (!mounted) {
        await newController.dispose();
        return;
      }

      await newController.setFlashMode(FlashMode.off);

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (e, stackTrace) {
      log('Error switching camera: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _startVideoRecording() async {
    final camera = controller;

    if (camera == null ||
        !camera.value.isInitialized ||
        camera.value.isRecordingVideo) {
      return;
    }

    try {
      await camera.startVideoRecording();

      if (!mounted) return;

      setState(() {
        _videoMessageDuration = 0;
      });

      _videoMessageTimer?.cancel();

      _videoMessageTimer = Timer.periodic(
        const Duration(seconds: 1),
            (_) {
          if (!mounted) return;

          if (_videoMessageDuration >= 59) {
            _stopVideoRecording();
            return;
          }

          setState(() {
            _videoMessageDuration++;
          });
        },
      );

      log('VIDEO RECORDING: started');
    } catch (e, stackTrace) {
      log(
        'VIDEO RECORDING START ERROR: $e',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _stopVideoRecording() async {
    final camera = controller;

    if (camera == null || !camera.value.isRecordingVideo) {
      return;
    }

    try {
      _videoMessageTimer?.cancel();
      _videoMessageTimer = null;

      final video = await camera.stopVideoRecording();

      if (!mounted) return;

      setState(() {
        _recordedVideo = video;
      });

      log('VIDEO RECORDING: stopped');
      log('VIDEO RECORDING: path=${video.path}');
    } catch (e, stackTrace) {
      log(
        'VIDEO RECORDING STOP ERROR: $e',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _cancelVideoRecording() async {
    _videoMessageTimer?.cancel();
    _videoMessageTimer = null;

    final camera = controller;

    if (camera != null && camera.value.isRecordingVideo) {
      try {
        final video = await camera.stopVideoRecording();

        final file = File(video.path);

        if (await file.exists()) {
          await file.delete();
        }
      } catch (e, stackTrace) {
        log(
          'VIDEO RECORDING CANCEL ERROR: $e',
          stackTrace: stackTrace,
        );
      }
    }

    final recordedVideo = _recordedVideo;

    if (recordedVideo != null) {
      try {
        final file = File(recordedVideo.path);

        if (await file.exists()) {
          await file.delete();
        }
      } catch (e, stackTrace) {
        log('VIDEO FILE DELETE ERROR: $e', stackTrace: stackTrace);
      }
    }

    if (!mounted) return;

    setState(() {
      _videoMessageDuration = 0;
      _recordedVideo = null;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final camera = controller;

    if (camera == null || !camera.value.isInitialized) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
    }

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.grey,
      body: SafeArea(
        child: Stack(
          children: [
            _buildVideoMessagePreview(camera),
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildVideoMessageDurationIndicator(),
                    Positioned(
                      right: 12,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, size: 28, color: ChatifyColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 76,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.buttonGrey),
                child: IconButton(
                  icon: SvgPicture.asset(ChatifyVectors.refreshDot, width: 20, height: 20, colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                  onPressed: _switchCamera,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(FluentIcons.delete_24_regular, size: 24, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                        onPressed: _cancelVideoRecording,
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: _stopVideoRecording,
                            icon: const Icon(Icons.stop_circle_outlined, size: 30, color: ChatifyColors.danger),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: ChatifyColors.black, size: 22),
                            onPressed: () {},
                          ),
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
    );
  }

  Widget _buildVideoMessageDurationIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: ChatifyColors.danger, borderRadius: BorderRadius.circular(20)),
      child: Text(_formatVideoMessageDuration(), style: const TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w400)),
    );
  }

  Widget _buildVideoMessagePreview(CameraController camera) {
    final isRecording = camera.value.isRecordingVideo;

    return Center(
      child: SizedBox(
        width: 362,
        height: 362,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isRecording)
              SizedBox(
                width: 362,
                height: 362,
                child: CircularProgressIndicator(
                  value: _videoMessageProgress,
                  strokeWidth: 3,
                  backgroundColor: ChatifyColors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
                ),
              ),
            Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: SizedBox(
                  width: 350,
                  height: 350,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(width: camera.value.previewSize?.height ?? 350, height: camera.value.previewSize?.width ?? 350, child: CameraPreview(camera)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
