import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/send_geolocation_screen.dart';

void showAddGeolocationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 140,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                child: const Center(
                  child: Icon(Icons.location_on_outlined, color: Colors.white, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Чтобы отправить ближайшее место или своё местоположение, разрешите "Chatify" доступ к местоположению.',
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text('Не сейчас',
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      PermissionStatus status = await Permission.location.request();
                      if (status.isGranted) {
                        Navigator.push(context, createPageRoute(const SendGeolocationScreen()));
                      } else if (status.isPermanentlyDenied) {
                        openAppSettings();
                        Navigator.push(context, createPageRoute(const SendGeolocationScreen()));
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text('Продолжить',
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
