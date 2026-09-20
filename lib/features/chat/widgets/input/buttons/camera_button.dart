import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../status/widgets/images/camera_screen.dart';
import '../../../models/user_model.dart';

class CameraButton extends StatefulWidget {
  final UserModel user;
  final Function(File) onImagePicked;

  const CameraButton({
    super.key,
    required this.onImagePicked,
    required this.user,
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
        Navigator.push(context, createPageRoute(CameraScreen(user: widget.user)));
      },
      icon: Icon(Icons.camera_alt_outlined, color: ChatifyColors.textSecondary, size: 25),
    );
  }
}
