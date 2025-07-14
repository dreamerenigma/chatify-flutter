import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_sounds.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../widgets/dialog/protected_enctyption_sheet_dialog.dart';
import '../add_participants_screen.dart';

class OutgoingVideoCallScreen extends StatefulWidget {
  final UserModel user;

  const OutgoingVideoCallScreen({super.key, required this.user});

  @override
  OutgoingVideoCallScreenState createState() => OutgoingVideoCallScreenState();
}

class OutgoingVideoCallScreenState extends State<OutgoingVideoCallScreen> with SingleTickerProviderStateMixin {
  late String videoPath;
  bool isMuted = false;
  bool isRecording = false;
  bool showNewContent = false;
  bool isExternalSpeaker = false;
  int currentCameraIndex = 0;
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  late AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _initializeCamera();
    _initializeRecorder();

    audioPlayer = AudioPlayer();
    _requestPermission().then((_) {
      _startRingingTone();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    _stopRingingTone();
    _recorder.closeRecorder();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRingingTone() async {
    try {
      log('Starting ringing tone...');
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.play(AssetSource(ChatifySounds.cellPhoneRing));
      log('Ringing tone started successfully.');
    } catch (e) {
      log('Error starting ringing tone: $e');
    }
  }

  Future<void> _stopRingingTone() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      log('Error stopping ringing tone: $e');
    }
  }

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      log('Attempting to play sound...');
      if (audioPlayer.state == PlayerState.playing) {
        log('Audio player is already playing.');
        return;
      }
      await audioPlayer.setReleaseMode(ReleaseMode.stop);
      await audioPlayer.play(AssetSource(ChatifySounds.endCallButton));
      log('Sound played successfully.');
    } catch (e) {
      log('Error playing sound: $e');
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

  Future<void> _initializeRecorder() async {
    try {
      await _recorder.openRecorder();
      log('Recorder initialized');
    } catch (e) {
      log('Error initializing recorder: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.isEmpty) return;

    _animationController.reset();
    await _animationController.forward();

    currentCameraIndex = (currentCameraIndex + 1) % _cameras.length;
    CameraDescription selectedCamera = _cameras[currentCameraIndex];

    await _cameraController?.dispose();

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log('Error switching camera: $e');
    }
  }

  void _toggleMicrophone() async {
    setState(() {
      isMuted = !isMuted;
    });

    if (isMuted) {
      await _recorder.pauseRecorder();
    } else {
      await _recorder.startRecorder(toFile: 'path/to/your/recording/file');
    }
  }

  void _toggleSpeaker() {
    setState(() {
      isExternalSpeaker = !isExternalSpeaker;
    });

    if (isExternalSpeaker) {
      audioPlayer.setVolume(0);
    } else {
      audioPlayer.setVolume(1);
    }
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
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: ChatifyColors.darkSlate,
                      radius: 25,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()..rotateY(_animation.value * 3.1415926535897932),
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.flip_camera_ios_rounded, color: ChatifyColors.white),
                              onPressed: _switchCamera,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(const AddParticipantsScreen()));
                      },
                      child: const CircleAvatar(
                        backgroundColor: ChatifyColors.darkSlate,
                        radius: 25,
                        child: Icon(Icons.person_add_alt_1_rounded, color: ChatifyColors.white),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                            fontSize: ChatifySizes.fontSizeMd,
                            color: ChatifyColors.white,
                            shadows: const [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(128, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline, color: ChatifyColors.white, size: 16, shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(128, 0, 0, 0),
                              ),
                            ]),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 220,
                              child: Text(
                                'Защищено скозным шифрованием',
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeSm,
                                  color: ChatifyColors.white,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 2.0,
                                      color: Color.fromARGB(128, 0, 0, 0),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: ChatifyColors.darkSlate,
                        radius: 25,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, color: ChatifyColors.white, size: 30),
                          onPressed: () => showProtectedEncryptionBottomSheet(context),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          bool? shouldNavigate = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                                title: Text('Переключиться на видеозвонок?',
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.width * 0.005,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: Text(
                                      'Отмена',
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: Text(
                                      'Переключить',
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldNavigate == true) {
                            Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: APIs.me)));
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: ChatifyColors.darkSlate,
                          radius: 25,
                          child: Icon(Icons.videocam_rounded, color: ChatifyColors.white, size: 30),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: isExternalSpeaker ? ChatifyColors.darkSlate : ChatifyColors.white,
                        radius: 25,
                        child: IconButton(
                          icon: Icon(
                            Icons.volume_up,
                            color: isExternalSpeaker ? ChatifyColors.white : ChatifyColors.black,
                            size: 30,
                          ),
                          onPressed: _toggleSpeaker,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: ChatifyColors.darkSlate,
                        radius: 25,
                        child: IconButton(
                          icon: Icon(
                            isMuted ? Icons.mic : Icons.mic_off,
                            color: ChatifyColors.white,
                            size: 30,
                          ),
                          onPressed: _toggleMicrophone,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            await playClickButton(audioPlayer);
                            _stopRingingTone();
                            Navigator.pop(context);
                          } catch (e) {
                            log('Error in onTap: $e');
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: ChatifyColors.error,
                          radius: 25,
                          child: Icon(Icons.call_end, color: ChatifyColors.white, size: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
