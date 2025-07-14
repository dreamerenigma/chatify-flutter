import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/enter_status_screen.dart';
import '../images/camera_screen.dart';

class StatusFAB extends StatelessWidget {
  const StatusFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80, right: 7),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, createPageRoute(EnterStatusScreen(user: APIs.me)));
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Icon(Icons.edit, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            heroTag: 'status',
            onPressed: () {
              Navigator.push(context, createPageRoute(const CameraScreen()));
            },
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            foregroundColor: ChatifyColors.white,
            elevation: 2,
            child: SvgPicture.asset(ChatifyVectors.cameraAdd, color: ChatifyColors.white, width: 28, height: 28),
          ),
        ),
      ],
    );
  }
}
