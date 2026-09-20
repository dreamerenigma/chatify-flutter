import 'dart:developer';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/chat_api.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../models/user_model.dart';

void showVideoMessageBottomSheetDialog(BuildContext context, UserModel user) {
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
      return VideoMessageBottomSheetContent(
        user: user,
        onRecordingFinished: (String localPath, int videoDuration) async {
          await ChatApi.sendVideoMessage(user, localPath, videoDuration: videoDuration);
        },
      );
    },
  );
}

class VideoMessageBottomSheetContent extends StatefulWidget {
  final UserModel user;
  final Future<void> Function(String localPath, int videoDuration) onRecordingFinished;

  const VideoMessageBottomSheetContent({
    super.key,
    required this.user,
    required this.onRecordingFinished,
  });

  @override
  State<VideoMessageBottomSheetContent> createState() => _VideoMessageBottomSheetContentState();
}

class _VideoMessageBottomSheetContentState extends State<VideoMessageBottomSheetContent> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        return;
      }

      final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front, orElse: () => cameras.first);
      final controller = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: true);

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isCameraInitialized = true;
      });
    } catch (e) {
      log('Camera initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), child: Container(color: ChatifyColors.black.withAlpha((0.65 * 255).toInt())))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 90, left: 20, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text('Видео сообщение', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 30),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.green),
                      child: const Icon(Icons.videocam, color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
