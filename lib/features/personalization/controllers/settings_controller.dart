import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  var sendWithEnter = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    sendWithEnter.value = box.read('sendWithEnter') ?? false;
    super.onInit();
  }

  void toggleSendWithEnter(bool value) {
    sendWithEnter.value = value;
    // Save value to storage
    box.write('sendWithEnter', value);
  }
}
