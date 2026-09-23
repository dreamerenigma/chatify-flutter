import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../domain/entities/chat_target.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../status/widgets/images/camera_screen.dart';

class CameraButton extends StatefulWidget {
  final ChatTarget chatTarget;
  final Function(File) onImagePicked;

  const CameraButton({
    super.key,
    required this.chatTarget,
    required this.onImagePicked,
  });

  @override
  CameraButtonState createState() => CameraButtonState();
}

class CameraButtonState extends State<CameraButton> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        Navigator.push(context, createPageRoute(CameraScreen(chatTarget: widget.chatTarget)));
      },
      icon: Icon(Icons.camera_alt_outlined, color: ChatifyColors.textSecondary, size: 25),
    );
  }
}
