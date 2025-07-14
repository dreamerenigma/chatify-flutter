import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(ChatifyImages.videoCallBackground), fit: BoxFit.cover),
            ),
          ),
          Container(
            color: ChatifyColors.black.withAlpha((0.5 * 255).toInt()),
          ),
          Center(
            child: IconButton(
              icon: const Icon(Icons.close, color: ChatifyColors.red, size: 35.0),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
