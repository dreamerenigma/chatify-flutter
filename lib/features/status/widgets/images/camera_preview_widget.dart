import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  CameraPreviewWidgetState createState() => CameraPreviewWidgetState();
}

class CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  CameraController? controller;
  Future<void>? initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          final firstCamera = cameras.first;

          controller = CameraController(
            firstCamera,
            ResolutionPreset.high,
          );

          initializeControllerFuture = controller!.initialize();
        } else {
          log('No cameras available');
        }
      } catch (e) {
        log('Error initializing camera: $e');
      }
    } else {
      log('Camera permission denied');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(controller!);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
        }
      },
    );
  }
}
