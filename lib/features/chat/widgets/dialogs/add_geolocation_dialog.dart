import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/user_model.dart';
import '../../screens/send_geolocation_screen.dart';

void showAddGeolocationDialog(BuildContext context, UserModel user) {
  final GetStorage _storage = GetStorage();

  if (_storage.read<bool>(AppKeys.geolocationDialogShownKey) == true) {
    return;
  }

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        actionsPadding: const EdgeInsets.only(left: 20, right: 24, top: 20, bottom: 20),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                height: 140,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                child: const Center(child: Icon(Icons.location_on_outlined, size: 40, color: ChatifyColors.black)),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(S.of(context).sendNearbyPlaceLocation, style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).notNow,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _storage.write(AppKeys.geolocationDialogShownKey, true);

              if (!context.mounted) return;

              Navigator.of(context).pop();
              PermissionStatus status = await Permission.location.request();
              if (status.isGranted) {
                Navigator.push(context, createPageRoute(SendGeolocationScreen(user: user)));
              } else if (status.isPermanentlyDenied) {
                openAppSettings();
                Navigator.push(context, createPageRoute(SendGeolocationScreen(user: user)));
              }
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(S.of(context).continueButton,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      );
    },
  );
}
