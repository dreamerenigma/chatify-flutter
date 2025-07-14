import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class DialogController extends GetxController {
  var isWindowsDialogOpen = false.obs;
  var isSettingsDialogOpen = false.obs;

  final RxList<bool> selectedOptions = <bool>[false].obs;

  CameraController? cameraController;

  void openWindowsDialog() {
    isWindowsDialogOpen.value = true;
    isSettingsDialogOpen.value = false;
    log('Открыт диалог Windows');
  }

  void openSettingsDialog() {
    isSettingsDialogOpen.value = true;
    isWindowsDialogOpen.value = false;
    log('Открыт диалог настроек');
  }

  void closeWindowsDialog() {
    isWindowsDialogOpen.value = false;
  }

  void closeSettingsDialog() {
    isSettingsDialogOpen.value = false;
  }

  void setCheckboxValue(bool selected) {
    selectedOptions[0] = selected;
  }
}
