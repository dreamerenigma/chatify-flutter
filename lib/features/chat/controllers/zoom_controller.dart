import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ZoomsController extends GetxController {
  static ZoomsController get instance => Get.find();
  final List<int> zoomLevels = [25, 50, 75, 100, 125, 150, 175, 200, 250, 300, 400, 600, 800, 1000];
  var selectedZoomPercent = 25.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedZoomPercent.value = box.read('selectedZoomPercent') ?? 100;
    applyZoom(selectedZoomPercent.value);
  }

  void applyZoom(int percent) {
    if (zoomLevels.contains(percent)) {
      selectedZoomPercent.value = percent;
      box.write('selectedZoomPercent', percent);
    }
  }

  double get scaleFactor => selectedZoomPercent.value / 100.0;

  void zoomIn() {
    final currentIndex = zoomLevels.indexOf(selectedZoomPercent.value);
    if (currentIndex < zoomLevels.length - 1) {
      applyZoom(zoomLevels[currentIndex + 1]);
    }
  }

  void zoomOut() {
    final currentIndex = zoomLevels.indexOf(selectedZoomPercent.value);
    if (currentIndex > 0) {
      applyZoom(zoomLevels[currentIndex - 1]);
    }
  }
}
