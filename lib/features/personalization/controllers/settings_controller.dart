import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final box = GetStorage();

  var sendWithEnter = false.obs;
  var syncContacts = false.obs;


  @override
  void onInit() {
    sendWithEnter.value = box.read('sendWithEnter') ?? false;
    syncContacts.value = box.read('syncContacts') ?? false;
    super.onInit();
  }

  void toggleSendWithEnter(bool value) {
    sendWithEnter.value = value;
    box.write('sendWithEnter', value);
  }

  void toggleSyncContacts(bool value) {
    syncContacts.value = value;
    box.write('syncContacts', value);
  }
}
