import 'package:chatify/features/home/controllers/dialog_controller.dart';
import 'package:get/get.dart';
import '../features/chat/controllers/zoom_controller.dart';
import '../features/community/controllers/country_controller.dart';
import '../features/home/controllers/overlay_color_controller.dart';
import '../features/personalization/controllers/colors_controller.dart';
import '../features/personalization/controllers/fonts_controller.dart';
import '../features/personalization/controllers/language_controller.dart';
import '../features/personalization/controllers/seasons_controller.dart';
import '../features/personalization/controllers/themes_controller.dart';
import '../features/personalization/controllers/user_controller.dart';
import '../data/repositories/email/email_send_repository.dart';
import '../features/calls/widgets/dialog/save_contact_dialog.dart';
import '../features/status/controllers/expanded_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LanguageController>(LanguageController());
    Get.put<ThemesController>(ThemesController());
    Get.put<SeasonsController>(SeasonsController());
    Get.put<ColorsController>(ColorsController());
    Get.put<FontsController>(FontsController());
    Get.put<ZoomsController>(ZoomsController());
    Get.put<UserController>(UserController());
    Get.put<EmailSendRepository>(EmailSendRepository());
    Get.put<SaveContactController>(SaveContactController());
    Get.put<DialogController>(DialogController());
    Get.put<OverlayColorController>(OverlayColorController());
    Get.put<ExpandController>(ExpandController());
    Get.put<CountryController>(CountryController());
  }
}
