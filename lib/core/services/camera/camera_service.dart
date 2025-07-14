import 'dart:developer';
import 'package:camera/camera.dart';

class CameraService {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool isCameraInitialized = false;

  Future<bool> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        log("Нет доступных камер");
        return false;
      }

      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
      isCameraInitialized = true;
      return true;
    } on CameraException catch (e) {
      log("Ошибка инициализации камеры: $e");

      return false;
    } catch (e) {
      log("Неизвестная ошибка: $e");
      isCameraInitialized = false;
      return false;
    }
  }

  void dispose() {
    _cameraController?.dispose();
  }

  CameraController? get controller => _cameraController;

  bool get isCameraAvailable => _cameras.isNotEmpty;
}
