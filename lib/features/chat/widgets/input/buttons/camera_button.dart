import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../../status/widgets/images/camera_screen.dart';

class CameraButton extends StatefulWidget {
  final Function(File) onImagePicked;

  const CameraButton({super.key, required this.onImagePicked});

  @override
  CameraButtonState createState() => CameraButtonState();
}

class CameraButtonState extends State<CameraButton> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        Navigator.push(context, createPageRoute(const CameraScreen()));
      },
      icon: Icon(
        Icons.camera_alt_rounded,
        color: colorsController.getColor(colorsController.selectedColorScheme.value),
        size: 26,
      ),
    );
  }
}
