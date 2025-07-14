import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialog/time_remaining_dialog.dart';
import 'create_link_call_screen.dart';

class LinkVideoScreen extends StatefulWidget {
  final String linkToSend;
  final UserModel user;

  const LinkVideoScreen({super.key, required this.linkToSend, required this.user});

  @override
  LinkVideoScreenState createState() => LinkVideoScreenState();
}

class LinkVideoScreenState extends State<LinkVideoScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  bool _isMicrophone = false;
  bool _isOverlayVisible = false;
  late String videoPath;
  Timer? _timer;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _requestPermission();
    _timer = Timer(const Duration(minutes: 2), () {
      if (mounted) {
        showTimeRemainingDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    if (_isMicrophone) {
      _microphoneOff();
    }
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
      );

      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        log('Error initializing camera: $e');
      }
    } else {
      log('No cameras available');
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController?.value.isRecordingVideo ?? false) return;

    if (kIsWeb) {
      return;
    }

    try {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      videoPath = path.join(appDirectory.path, '${DateTime.now()}.mp4');

      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!(_cameraController?.value.isRecordingVideo ?? false)) return;

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      log('Video saved to ${videoFile.path}');
    } catch (e) {
      log('Error stopping video recording: $e');
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _initializeRecorder();
    } else {
      log('Microphone permission denied');
    }
  }

  Future<void> _initializeRecorder() async {
    try {
      await _recorder.openRecorder();
      log('Recorder initialized');
    } catch (e) {
      log('Error initializing recorder: $e');
    }
  }

  Future<void> _microphoneOn() async {
    if (_isMicrophone) {
      log('Microphone is already on.');
      return;
    }

    try {
      log('Starting microphone...');
      await _recorder.startRecorder(toFile: 'audio_recording.aac');
      log('Microphone started.');
      setState(() {
        _isMicrophone = true;
      });
    } catch (e) {
      log('Error starting microphone recording: $e');
    }
  }

  Future<void> _microphoneOff() async {
    if (!_isMicrophone) {
      log('Microphone is already off.');
      return;
    }

    try {
      log('Stopping microphone...');
      await _recorder.stopRecorder();
      log('Microphone stopped.');
      setState(() {
        _isMicrophone = false;
      });
    } catch (e) {
      log('Error stopping microphone recording: $e');
    }
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          if (_isOverlayVisible)
          Container(
            color: ChatifyColors.darkerGrey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Вы',
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeMg,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.height * .13,
                      height: MediaQuery.of(context).size.height * .13,
                      imageUrl: widget.user.image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(
                        fontSize: ChatifySizes.fontSizeMg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage(ChatifyImages.appLogoLight), width: 16, color: ChatifyColors.white),
                  const SizedBox(width: 6),
                  Text(
                    'Ссылка на звонок',
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeLg,
                      color: ChatifyColors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isRecording) {
                            _stopRecording();
                          } else {
                            _startRecording();
                          }
                          _toggleOverlay();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: _isRecording ? ChatifyColors.blackGrey : ChatifyColors.white,
                          minimumSize: const Size(60, 60),
                          side: BorderSide.none,
                        ),
                        child: Icon(
                          Icons.videocam,
                          color: _isRecording ? ChatifyColors.white : ChatifyColors.black,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isMicrophone) {
                            _microphoneOff();
                          } else {
                            _microphoneOn();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: _isMicrophone ? Colors.white : ChatifyColors.blackGrey,
                          minimumSize: const Size(60, 60),
                          side: BorderSide.none,
                        ),
                        child: Icon(
                          _isMicrophone ? Icons.mic_off : Icons.mic,
                          color: _isMicrophone ? ChatifyColors.black : ChatifyColors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).toInt()),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(context, createPageRoute(CreateLinkCallScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ChatifyColors.black,
                              backgroundColor: ChatifyColors.darkerGrey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text(
                              'Пропустить',
                              style: TextStyle(fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text(
                              'Присоединиться',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
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
        ],
      ),
    );
  }
}
