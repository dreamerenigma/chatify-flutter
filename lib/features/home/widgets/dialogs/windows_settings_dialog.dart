import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../controllers/dialog_controller.dart';

void showWindowsSettingsDialog(BuildContext context, String settingsUri) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      dialogController.openWindowsDialog();

      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final dialogWidth = 423.0;
      final dialogHeight = 241.0;
      final offsetX = (screenWidth - dialogWidth) / 2;
      final offsetY = (screenHeight - dialogHeight) / 2;

      return GestureDetector(
        onTap: () {},
        child: Positioned(
          top: offsetY,
          left: offsetX,
          child: Material(
            color: ChatifyColors.transparent,
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              backgroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.darkGrey,
              child: Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: ChatifyColors.buttonDarkGrey, width: 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: ChatifyColors.transparent, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Вы хотели переключить приложения?",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.white),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Вы хотели переключить приложения?",
                            style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w300, color: ChatifyColors.white),
                          ),
                          SizedBox(height: 8),
                          Text('"Chatify" пытается открыть "Параметры".', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                overlayEntry.remove();
                                dialogController.closeWindowsDialog();
                                final Uri uri = Uri.parse(settingsUri);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  log("Не удалось открыть настройки Windows.");
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: ChatifyColors.mildNight,
                                foregroundColor: ChatifyColors.darkerGrey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text("Да", style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Future.delayed(Duration(milliseconds: 100), () {
                                  overlayEntry.remove();
                                  dialogController.closeWindowsDialog();
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: ChatifyColors.blue,
                                foregroundColor: ChatifyColors.ascentBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text("Нет", style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.black)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(overlayEntry);
}
