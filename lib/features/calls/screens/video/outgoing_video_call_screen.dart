import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/call_status_type.dart';
import '../../../../core/enums/call_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_sounds.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/call_result.dart';
import '../../widgets/dialog/protected_enctyption_sheet_dialog.dart';
import '../../widgets/panels/video_call_control_panel.dart';
import '../../widgets/timers/call_duration_timer.dart';
import '../add_participants_screen.dart';

class OutgoingVideoCallScreen extends StatefulWidget {
  final UserModel user;

  const OutgoingVideoCallScreen({super.key, required this.user});

  @override
  OutgoingVideoCallScreenState createState() => OutgoingVideoCallScreenState();
}

class OutgoingVideoCallScreenState extends State<OutgoingVideoCallScreen> with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  late List<CameraDescription> _cameras;
  late AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String videoPath;
  bool isMuted = false;
  bool isRecording = false;
  bool isConnected = false;
  bool showNewContent = false;
  bool isExternalSpeaker = false;
  int currentCameraIndex = 0;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _initializeCamera();
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
    _recorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRingingTone() async {
    try {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.play(AssetSource(ChatifySounds.cellPhoneRing));
    } catch (e) {
      log('${S.of(context).errorStartingRingingTone}: $e');
    }
  }

  Future<void> _stopRingingTone() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      log('${S.of(context).errorStopingRingingTone}: $e');
    }
  }

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      if (audioPlayer.state == PlayerState.playing) {
        return;
      }
      await audioPlayer.setReleaseMode(ReleaseMode.stop);
      await audioPlayer.play(AssetSource(ChatifySounds.endCallButton));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      log('Microphone permission granted');
    } else {
      log(S.of(context).microPermissionDenied);
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras[0], ResolutionPreset.high);

      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        log('${S.of(context).errorInitCamera}: $e');
      }
    } else {
      log(S.of(context).noCamerasAvailable);
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.isEmpty) return;

    _animationController.reset();
    await _animationController.forward();

    currentCameraIndex = (currentCameraIndex + 1) % _cameras.length;
    CameraDescription selectedCamera = _cameras[currentCameraIndex];

    await _cameraController?.dispose();

    _cameraController = CameraController(selectedCamera, ResolutionPreset.high);

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log('${S.of(context).errorSwitchingCamera}: $e');
    }
  }

  void _toggleMicrophone() async {
    setState(() {
      isMuted = !isMuted;
    });

    if (isMuted) {
      await _recorder.pause();
    } else {
      await _recorder.resume();
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
          Positioned.fill(child: CameraPreview(_cameraController!)),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isConnected) ...[
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: ChatifyColors.darkSlate,
                        radius: 25,
                        child: SvgPicture.asset(ChatifyVectors.resize, width: 26, height: 26, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: isConnected ? 0 : 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.user.name} ${widget.user.surname}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: ChatifyColors.white, fontSize: 17, fontWeight: FontWeight.w500, shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))]),
                        ),
                        const SizedBox(height: 2),
                        if (isConnected)
                          const CallDurationTimer(isRunning: true)
                        else
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: ChatifyColors.white,
                                    size: 14,
                                    shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(
                                  text: S.of(context).protectedWithEndToEndEncryption,
                                  style: TextStyle(
                                    color: ChatifyColors.grey,
                                    fontSize: ChatifySizes.fontSizeSm,
                                    fontWeight: FontWeight.w400,
                                    shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
                                    height: 1.4
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {
                          Navigator.push(context, createPageRoute(const AddParticipantsScreen()));
                        },
                        child: CircleAvatar(
                          backgroundColor: ChatifyColors.darkSlate, radius: 27,
                          child: SvgPicture.asset(ChatifyVectors.addUser, width: 28, height: 28, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CircleAvatar(
                      backgroundColor: ChatifyColors.darkSlate,
                      radius: 27,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()..rotateY(_animation.value * 3.1415926535897932),
                            alignment: Alignment.center,
                            child: IconButton(icon: Icon(Icons.flip_camera_ios_rounded, size: 28, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), onPressed: _switchCamera),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {
                          Navigator.push(context, createPageRoute(const AddParticipantsScreen()));
                        },
                        child: CircleAvatar(
                          backgroundColor: ChatifyColors.darkSlate, radius: 27,
                          child: SvgPicture.asset(
                            ChatifyVectors.wizard, width: 28, height: 28, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VideoCallControlPanel(
            isConnected: isConnected,
            isExternalSpeaker: isExternalSpeaker,
            isMuted: isMuted,
            onMore: () => showProtectedEncryptionBottomSheet(context),
            onSwitchToVideo: () async {
              final bool? shouldNavigate = await showDialog<bool>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog();
                },
              );

              if (shouldNavigate == true) {
                if (!mounted) return;

                Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: APIs.me)));
              }
            },
            onToggleSpeaker: _toggleSpeaker,
            onToggleMicrophone: _toggleMicrophone,
            onEndCall: () async {
              try {
                await playClickButton(audioPlayer);
                await _stopRingingTone();

                if (!mounted) return;

                Navigator.pop(context, CallResult(type: CallType.video, status: CallStatusType.noAnswer));
              } catch (e) {
                log('${S.of(context).errorInOnTap}: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
