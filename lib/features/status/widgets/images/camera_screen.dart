import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/chat_target.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../chat/models/user_model.dart';
import 'camera_preview_widget.dart';

class CameraScreen extends StatefulWidget {
  final ChatTarget chatTarget;

  const CameraScreen({
    super.key,
    required this.chatTarget,
  });

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  final ImagePicker picker = ImagePicker();
  bool isPhotoMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ChatifyColors.black, body: CameraPreviewWidget(chatTarget: widget.chatTarget));
  }
}
