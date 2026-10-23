import 'package:get/get.dart';

class ExpandController extends GetxController {
  var isExpanded = false.obs;

  void toggle() {
    isExpanded.value = !isExpanded.value;
  }
}