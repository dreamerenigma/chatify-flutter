import 'package:chatify/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../chat/models/user_model.dart';

class OutgoingVideoCallWidget extends StatefulWidget {
  final UserModel user;

  const OutgoingVideoCallWidget({super.key, required this.user});

  @override
  State<OutgoingVideoCallWidget> createState() => OutgoingVideoCallWidgetState();
}

class OutgoingVideoCallWidgetState extends State<OutgoingVideoCallWidget> {

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.groupBackgroundDark : ChatifyImages.groupBackgroundLight;

    return Scaffold(
      backgroundColor: ChatifyColors.blackGrey,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ChatifyColors.black, width: 1.5),
            image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
