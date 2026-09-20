import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import '../../../../api/apis.dart';
import '../../../../api/chat_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/screens/select_contact_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/buttons/camera_icon_button.dart';
import '../../../personalization/screens/qr_code/gallery_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';

class CameraPreviewWidget extends StatefulWidget {
  final UserModel user;

  const CameraPreviewWidget({
    super.key,
    required this.user,
  });

  @override
  CameraPreviewWidgetState createState() => CameraPreviewWidgetState();
}

class CameraPreviewWidgetState extends State<CameraPreviewWidget> with TickerProviderStateMixin {
  final ImagePicker picker = ImagePicker();
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  bool isPhotoMode = true;
  bool isVideoMessageMode = false;
  bool isVideoMode = false;
  bool _areImagesVisible = true;
  bool _isFlashOff = true;
  bool _isVideoMessageRecorded = false;
  bool _isVideoMessagePlaying = false;
  int _videoDuration = 0;
  int _videoMessageDuration = 0;
  List<AssetEntity> _images = [];
  List<bool> _selectedImages = [];
  String? _videoMessagePath;
  Timer? _videoTimer;
  Timer? _videoMessageTimer;
  VideoPlayerController? _videoMessageController;

  CameraLensDirection _currentLensDirection = CameraLensDirection.front;

  String _formatDuration() {
    final minutes = _videoDuration ~/ 60;
    final seconds = _videoDuration % 60;

    return '${minutes.toString().padLeft(2, '0')}:' '${seconds.toString().padLeft(2, '0')}';
  }

  String _formatVideoMessageDuration() {
    final seconds = _videoMessageDuration.clamp(0, 59);

    return '00:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatVideoMessagePlaybackDuration(Duration position) {
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:' '${seconds.toString().padLeft(2, '0')}';
  }

  double get _videoMessageProgress {
    return (_videoMessageDuration / 60).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadImages();
  }

  @override
  void dispose() {
    _videoTimer?.cancel();
    controller?.dispose();
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

      setState(() {
        controller = newController;
        initializeControllerFuture = Future.value();
      });
    } catch (e, stackTrace) {
      log('${S.of(context).errorInitCamera}: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _loadImages() async {
    final permissionStatus =
    await PhotoManager.requestPermissionExtend();

    if (!permissionStatus.isAuth) return;

    final assetPaths = await PhotoManager.getAssetPathList(type: RequestType.image);

    if (assetPaths.isEmpty) return;

    final images = await assetPaths.first.getAssetListPaged(page: 0, size: 5);

    if (!mounted) return;

    setState(() {
      _images = images;
      _selectedImages =
      List<bool>.filled(images.length, false);
    });
  }

  Future<void> _toggleFlash() async {
    final camera = controller;

    if (camera == null || !camera.value.isInitialized) {
      return;
    }

    try {
      final newFlashMode = _isFlashOff ? FlashMode.torch : FlashMode.off;

      await camera.setFlashMode(newFlashMode);

      if (!mounted) return;

      setState(() {
        _isFlashOff = !_isFlashOff;
      });
    } catch (e) {
      log('Flash error: $e');
    }
  }

  Future<void> _startVideoRecording() async {
    final camera = controller;

    if (camera == null || !camera.value.isInitialized) {
      return;
    }

    if (camera.value.isRecordingVideo) {
      return;
    }

    try {
      _resetVideoTimer();

      await camera.startVideoRecording();

      if (!mounted) return;

      _startVideoTimer();
    } catch (e, stackTrace) {
      log('Error starting video recording: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _stopVideoRecording() async {
    final camera = controller;

    if (camera == null || !camera.value.isRecordingVideo) {
      return;
    }

    try {
      await camera.stopVideoRecording();

      _stopVideoTimer();

      log('Video duration: $_videoDuration seconds');
    } catch (e, stackTrace) {
      log('Error stopping video recording: $e', stackTrace: stackTrace);
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
        _isFlashOff = true;
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

  Future<void> _startVideoMessageRecording() async {
    final camera = controller;

    if (camera == null || !camera.value.isInitialized) {
      return;
    }

    if (camera.value.isRecordingVideo) {
      return;
    }

    try {
      setState(() {
        _isVideoMessageRecorded = false;
        _isVideoMessagePlaying = false;
        _videoMessageDuration = 0;
      });

      await _videoMessageController?.dispose();
      _videoMessageController = null;

      await camera.startVideoRecording();

      if (!mounted) return;

      _videoMessageTimer?.cancel();

      _videoMessageTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          if (!mounted) {
            timer.cancel();
            return;
          }

          setState(() {
            _videoMessageDuration++;
          });

          if (_videoMessageDuration >= 60) {
            timer.cancel();
            _videoMessageTimer = null;

            await _stopVideoMessageRecording();
          }
        },
      );
    } catch (e, stackTrace) {
      log('Error starting video message recording: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _stopVideoMessageRecording() async {
    final camera = controller;

    if (camera == null || !camera.value.isRecordingVideo) {
      return;
    }

    _videoMessageTimer?.cancel();
    _videoMessageTimer = null;

    try {
      final xFile = await camera.stopVideoRecording();

      _videoMessagePath = xFile.path;

      final file = File(xFile.path);

      log('Video message recorded: ${file.path}');
      log('Video exists: ${await file.exists()}');
      log('Video size: ${await file.length()} bytes');

      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (!await file.exists()) {
        throw Exception('Recorded video file does not exist: ${file.path}');
      }

      final fileSize = await file.length();

      if (fileSize == 0) {
        throw Exception('Recorded video file is empty: ${file.path}',);
      }

      final videoController = VideoPlayerController.file(file);

      await videoController.initialize();

      if (!mounted) {
        await videoController.dispose();
        return;
      }

      setState(() {
        _videoMessageController = videoController;
        _isVideoMessageRecorded = true;
        _isVideoMessagePlaying = false;
      });

      log('Video initialized: ''${videoController.value.size.width}x''${videoController.value.size.height}, ''duration: ${videoController.value.duration}');
    } catch (e, stackTrace) {
      log('Error stopping video message recording: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _playVideoMessage() async {
    final videoController = _videoMessageController;

    if (videoController == null) {
      return;
    }

    if (!videoController.value.isInitialized) {
      return;
    }

    if (videoController.value.isPlaying) {
      await videoController.pause();

      if (!mounted) return;

      setState(() {
        _isVideoMessagePlaying = false;
      });

      return;
    }

    await videoController.play();

    if (!mounted) return;

    setState(() {
      _isVideoMessagePlaying = true;
    });

    videoController.addListener(_handleVideoMessagePlayback);
  }

  Future<void> _sendVideoMessage() async {
    log('VIDEO SEND: button pressed');

    final localPath = _videoMessagePath;

    log('VIDEO SEND: localPath = $localPath');

    if (localPath == null || localPath.isEmpty) {
      log('VIDEO SEND: ERROR - localPath is null or empty');
      return;
    }

    final file = File(localPath);
    final exists = await file.exists();

    log('VIDEO SEND: file exists = $exists');

    if (!exists) {
      log('VIDEO SEND: ERROR - file does not exist');
      return;
    }

    final fileSize = await file.length();

    log('VIDEO SEND: file size = $fileSize bytes');

    VideoPlayerController? controller;

    try {
      controller = VideoPlayerController.file(file);

      await controller.initialize();

      final duration = controller.value.duration;
      final videoDuration = duration.inSeconds;

      log('VIDEO SEND: duration = $duration');
      log('VIDEO SEND: videoDuration = $videoDuration seconds');

      log('VIDEO SEND: calling APIs.sendVideoMessage()');

      final messageId = await ChatApi.sendVideoMessage(widget.user,
        localPath,
        fileName: 'video_message.mp4',
        fileSize: fileSize.toString(),
        videoDuration: videoDuration,
      );

      log('VIDEO SEND: sendVideoMessage completed');
      log('VIDEO SEND: messageId = $messageId');

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e, stackTrace) {
      log('VIDEO SEND: ERROR = $e', stackTrace: stackTrace);
    } finally {
      await controller?.dispose();
    }
  }

  void _toggleSelection(int index) {
    if (index < 0 || index >= _selectedImages.length) {
      return;
    }

    setState(() {
      _selectedImages[index] =
      !_selectedImages[index];
    });
  }

  void _toggleImagesVisibility() {
    setState(() {
      _areImagesVisible = !_areImagesVisible;
    });
  }

  void _startVideoTimer() {
    _videoTimer?.cancel();

    _videoTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _videoDuration++;
        });

        if (_videoDuration >= 60) {
          timer.cancel();
          _videoTimer = null;

          _stopVideoRecording();
        }
      },
    );
  }

  void _stopVideoTimer() {
    _videoTimer?.cancel();
    _videoTimer = null;

    if (!mounted) return;

    setState(() {
      _videoDuration = 0;
    });
  }

  void _resetVideoTimer() {
    if (!mounted) return;

    setState(() {
      _videoDuration = 0;
    });
  }

  void _handleVideoMessagePlayback() {
    final videoController = _videoMessageController;

    if (videoController == null || !mounted) {
      return;
    }

    if (videoController.value.position >= videoController.value.duration) {
      videoController.removeListener(_handleVideoMessagePlayback);

      setState(() {
        _isVideoMessagePlaying = false;
      });
    }
  }

  void _handleCameraClose() {
    if (isVideoMessageMode && _isVideoMessageRecorded) {
      _videoMessageController?.pause();

      setState(() {
        _isVideoMessagePlaying = false;
        _isVideoMessageRecorded = false;
        _videoMessageDuration = 0;
      });

      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final camera = controller;
    final future = initializeControllerFuture;

    if (camera == null || future == null) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
    }

    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
        }

        if (snapshot.hasError) {
          return Center(child: Text('${S.of(context).error}: ${snapshot.error}', style: const TextStyle(color: ChatifyColors.white)));
        }

        return _buildCameraInterface(camera);
      },
    );
  }

  Widget _buildCameraInterface(CameraController camera) {
    final isVideoMessage = isVideoMessageMode;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isVideoMessage)
          Container(color: ChatifyColors.black, child: _isVideoMessageRecorded ? _buildRecordedVideoMessagePreview() : _buildVideoMessagePreview(camera))
        else
          CameraPreview(camera),
        Positioned(
          top: 0,
          left: 8,
          right: 8,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: !(isVideoMessageMode && (controller?.value.isRecordingVideo ?? false)),
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CameraIconButton(
                        icon: const Icon(Icons.close, color: ChatifyColors.white),
                        size: 40,
                        onPressed: _handleCameraClose,
                      ),
                    ),
                  ),
                  if (!isPhotoMode)
                    _buildVideoMessageDurationIndicator(),
                  Visibility(
                    visible: !(isVideoMessageMode && ((controller?.value.isRecordingVideo ?? false) || _isVideoMessageRecorded)),
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CameraIconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Icon(
                            _isFlashOff ? FluentIcons.flash_off_20_regular : FluentIcons.flash_20_regular,
                            key: ValueKey<bool>(_isFlashOff),
                            color: ChatifyColors.white,
                          ),
                        ),
                        size: 40,
                        onPressed: _toggleFlash,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomControls()),
      ],
    );
  }

  Widget _buildVideoMessageDurationIndicator() {
    final videoController = _videoMessageController;
    final isRecording = controller?.value.isRecordingVideo ?? false;

    if (!isVideoMessageMode) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: ChatifyColors.youngNight.withAlpha((0.5 * 255).toInt()), borderRadius: BorderRadius.circular(20)),
        child: Text(_formatDuration(), style: const TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w400)),
      );
    }

    if (isRecording) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: ChatifyColors.danger, borderRadius: BorderRadius.circular(20)),
        child: Text(_formatVideoMessageDuration(), style: const TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w400)),
      );
    }

    if (!_isVideoMessageRecorded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: ChatifyColors.youngNight.withAlpha((0.5 * 255).toInt()), borderRadius: BorderRadius.circular(20)),
        child: Text(_formatVideoMessageDuration(), style: const TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w400)),
      );
    }

    if (videoController == null || !videoController.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: videoController,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: ChatifyColors.youngNight.withAlpha((0.5 * 255).toInt()), borderRadius: BorderRadius.circular(20)),
          child: Text(
            _formatVideoMessagePlaybackDuration(value.position),
            style: const TextStyle(color: ChatifyColors.white, fontSize: 15,fontWeight: FontWeight.w400),
          ),
        );
      },
    );
  }

  Widget _buildGalleryToggleButton() {
    return GestureDetector(
      onTap: _toggleImagesVisibility,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: Icon(_areImagesVisible ? Icons.remove : Icons.keyboard_arrow_up_rounded, color: ChatifyColors.white, size: 24)),
      ),
    );
  }

  Widget _buildBottomControls() {
    final camera = controller;
    final isRecording = camera?.value.isRecordingVideo ?? false;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isVideoMessageMode) ...[
            _buildGalleryToggleButton(),
            AnimatedSize(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, child: _areImagesVisible ? _buildImagesList() : const SizedBox.shrink()),
          ],
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                  Positioned(
                    left: 24,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isVideoMessageMode)
                          CameraIconButton(
                            icon: const Icon(Icons.image_outlined, color: ChatifyColors.white, size: 27),
                            onPressed: () {
                              Navigator.push(context, createPageRoute(const GalleryScreen(title: 'Недавние')));
                            },
                          ),
                        if (!isRecording && !_isVideoMessageRecorded) ...[
                          const SizedBox(width: 16),
                          CameraIconButton(
                            icon: SvgPicture.asset(ChatifyVectors.wizard, width: 27, height: 27, colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                            onPressed: () {
                              Navigator.push(context, createPageRoute(const GalleryScreen(title: 'Недавние')));
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                if (isVideoMessageMode && !_isVideoMessageRecorded)
                  _buildVideoMessageShutterButton()
                else if (!isVideoMessageMode)
                  _buildShutterButton(),
                if (!_isVideoMessageRecorded)
                  Positioned(
                    right: 24,
                    child: CameraIconButton(
                      icon: SvgPicture.asset(ChatifyVectors.refreshDot, width: 27, height: 27, colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                      onPressed: _switchCamera,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 84,
            child: isVideoMessageMode && _isVideoMessageRecorded
              ? _buildVideoMessageSendBar()
              : (isVideoMessageMode && (controller?.value.isRecordingVideo ?? false))
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildModeSelector(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesList() {
    return Container(
      height: 75,
      color: ChatifyColors.transparent,
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _toggleSelection(index);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 75,
                    height: 75,
                    child: FutureBuilder<Uint8List?>(
                      future: _images[index].thumbnailData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          return Image.memory(snapshot.data!, width: 60, height: 50, fit: BoxFit.cover);
                        }

                        return Container(color: ChatifyColors.grey);
                      },
                    ),
                  ),

                  if (_selectedImages.length > index && _selectedImages[index])
                    const Icon(Icons.check, color: ChatifyColors.white),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShutterButton() {
    final isVideoMode = !isPhotoMode && !isVideoMessageMode;
    final isVideoMessageModeActive = isVideoMessageMode;
    final shutterSize = isVideoMode || isVideoMessageModeActive ? 34.0 : 50.0;

    return GestureDetector(
      onTap: () async {
        if (!isPhotoMode && !isVideoMessageMode) {
          if (_videoTimer == null) {
            await _startVideoRecording();
          } else {
            await _stopVideoRecording();
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 75, height: 75, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.white, width: 3.5))),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(width: shutterSize, height: shutterSize, decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoMessageShutterButton() {
    final camera = controller;
    final isRecording = camera?.value.isRecordingVideo ?? false;

    return GestureDetector(
      onTap: () async {
        if (isRecording) {
          await _stopVideoMessageRecording();
        } else {
          await _startVideoMessageRecording();
        }
      },
      child: SizedBox(
        width: 75,
        height: 75,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 75,
              height: 75,
              child: CircularProgressIndicator(value: 1.0, strokeWidth: 3.5, backgroundColor: ChatifyColors.transparent, valueColor: AlwaysStoppedAnimation<Color>(ChatifyColors.white)),
            ),
            if (isRecording)
              SizedBox(
                width: 75,
                height: 75,
                child: CircularProgressIndicator(value: _videoMessageProgress, strokeWidth: 3.5, backgroundColor: ChatifyColors.transparent, valueColor: const AlwaysStoppedAnimation<Color>(ChatifyColors.red)),
              ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isRecording
                ? Container(
                    key: const ValueKey('recording'),
                    width: 32,
                    height: 34,
                    decoration: BoxDecoration(color: ChatifyColors.danger, borderRadius: BorderRadius.circular(8)),
                  )
                : Container(
                    key: const ValueKey('idle'),
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(color: ChatifyColors.white, shape: BoxShape.circle),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      color: ChatifyColors.transparent,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildModeItem(
            title: S.of(context).video,
            isActive: !isPhotoMode && !isVideoMessageMode,
            onTap: () {
              setState(() {
                isPhotoMode = false;
                isVideoMessageMode = false;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildModeItem(
            title: S.of(context).photo,
            isActive: isPhotoMode && !isVideoMessageMode,
            onTap: () {
              setState(() {
                isPhotoMode = true;
                isVideoMessageMode = false;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildModeItem(
            title: 'Видеозаметка',
            isActive: isVideoMessageMode,
            onTap: () {
              setState(() {
                isVideoMessageMode = true;
                isPhotoMode = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeItem({required String title, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: isActive ? ChatifyColors.nightGrey : ChatifyColors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(title, style: TextStyle(color: isActive ? ChatifyColors.white : ChatifyColors.grey, fontWeight: FontWeight.w400)),
      ),
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
                child: CircularProgressIndicator(value: _videoMessageProgress, strokeWidth: 3, backgroundColor: ChatifyColors.transparent, valueColor: const AlwaysStoppedAnimation<Color>(ChatifyColors.white)),
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

  Widget _buildRecordedVideoMessagePreview() {
    final isFrontCamera = _currentLensDirection == CameraLensDirection.front;
    final videoController = _videoMessageController;

    if (videoController == null || !videoController.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: videoController,
      builder: (context, value, child) {
        final duration = value.duration;
        final position = value.position;
        final progress = duration.inMilliseconds > 0 ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0) : 0.0;

        return Center(
          child: SizedBox(
            width: 362,
            height: 362,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox(
                      width: 350,
                      height: 350,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: isFrontCamera ? (Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0)) : Matrix4.identity(),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(width: value.size.width, height: value.size.height, child: VideoPlayer(videoController)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 362,
                  height: 362,
                  child: CircularProgressIndicator(value: progress, strokeWidth: 3, backgroundColor: ChatifyColors.transparent, valueColor: const AlwaysStoppedAnimation<Color>(ChatifyColors.white)),
                ),
                GestureDetector(
                  onTap: _playVideoMessage,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.black.withAlpha((0.4 * 255).toInt())),
                    alignment: Alignment.center,
                    child: Icon(_isVideoMessagePlaying ? Icons.pause : Icons.play_arrow_rounded, color: ChatifyColors.white, size: 54),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoMessageSendBar() {
    final user = APIs.me;
    final phoneNumber = user.phoneNumber;
    final name = user.name;
    final isMe = user.id == APIs.me.id;

    return Container(
      width: double.infinity,
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white),
      child: Row(
        children: [
          Material(
            color: ChatifyColors.transparent,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(22)),
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(22),
                splashColor: ChatifyColors.darkGrey.withValues(alpha: 0.15),
                highlightColor: ChatifyColors.darkGrey.withValues(alpha: 0.15),
                hoverColor: ChatifyColors.darkGrey.withValues(alpha: 0.15),
                onTap: () {
                  Navigator.push(context, createPageRoute(SelectContactScreen(user: user)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    '$phoneNumber (${isMe ? 'Вы' : name})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Spacer(),
          Material(
            color: ChatifyColors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: ChatifyColors.transparent,
              highlightColor: ChatifyColors.transparent,
              onTap: () => _sendVideoMessage(),
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.green),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Icon(Icons.send_rounded, size: 24, color: ChatifyColors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
