import 'package:camera/camera.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:iconoir_icons/iconoir_icons.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../core/services/camera/camera_service.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/controllers/dialog_controller.dart';
import '../../../home/widgets/dialogs/confirmation_dialog.dart';
import '../../../home/widgets/dialogs/settings_dialog.dart';
import 'light_dialog.dart';

void showTakePhotoDialog(BuildContext context) async {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  CameraService cameraService = CameraService();

  try {
    bool cameraInitialized = await cameraService.initializeCamera();

    if (!cameraInitialized) {
      showConfirmationDialog(
        context: context,
        width: 535,
        title: S.of(context).appFindConnectedCamera,
        description: S.of(context).videoCallsAppCameraConnectComputer,
        cancelText: S.of(context).ok,
        confirmButton: true,
        onConfirm: () {},
      );
      return;
    }

    dialogController.openWindowsDialog();

    overlayEntry = OverlayEntry(
      builder: (context) {
        dialogController.openWindowsDialog();

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  overlayEntry.remove();
                  dialogController.closeWindowsDialog();
                  cameraService.dispose();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(color: ChatifyColors.black.withAlpha((0.5 * 255).toInt())),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Material(
                color: ChatifyColors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
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
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).takePhoto,
                                      style: TextStyle(
                                        fontSize: ChatifySizes.fontSizeBg,
                                        fontWeight: FontWeight.w500,
                                        color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        overlayEntry.remove();
                                        cameraService.dispose();
                                      },
                                      mouseCursor: SystemMouseCursors.basic,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Icon(Ionicons.close_outline, size: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                height: 200,
                                child: cameraService.isCameraInitialized ? CameraPreview(cameraService.controller!) : Center(child: Text('Не удалось инициализировать камеру')),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softGrey,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                            border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.buttonGrey, width: 0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                color: ChatifyColors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    overlayEntry.remove();
                                    final RenderBox renderBox = context.findRenderObject() as RenderBox;
                                    final position = renderBox.localToGlobal(Offset.zero);
                                    showSettingsDialog(context, position, initialIndex: 3);
                                  },
                                  mouseCursor: SystemMouseCursors.basic,
                                  borderRadius: BorderRadius.circular(30),
                                  splashColor: ChatifyColors.transparent,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Iconoir(IconoirIcons.moreHoriz, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 24),
                                  ),
                                ),
                              ),
                              SizedBox(width: 25),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                                child: Icon(Icons.camera_alt, color: ChatifyColors.black, size: 20),
                              ),
                              SizedBox(width: 25),
                              Material(
                                color: ChatifyColors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  mouseCursor: SystemMouseCursors.basic,
                                  borderRadius: BorderRadius.circular(30),
                                  splashColor: ChatifyColors.transparent,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: HeroIcon(HeroIcons.videoCamera, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 24),
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
          ],
        );
      },
    );

    overlay.insert(overlayEntry);

  } catch (e) {
    showConfirmationDialog(
      context: context,
      width: 535,
      description: S.of(context).failedCaptureVideoCameraApp,
      cancelText: S.of(context).ok,
      confirmButton: true,
      onConfirm: () {},
    );
  }
}
