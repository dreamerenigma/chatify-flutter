import 'package:chatify/features/home/controllers/dialog_controller.dart';
import 'package:get/get.dart';
import '../core/services/calls/agora_call_service.dart';
import '../core/services/calls/call_service.dart';
import '../core/services/media/media_service.dart';
import '../core/services/media/yandex/yandex_disk_api.dart';
import '../core/services/media/yandex/yandex_disk_service.dart';
import '../core/services/voice/voice_playback_service.dart';
import '../core/services/voice/voice_recorder_service.dart';
import '../features/calls/controllers/call_controller.dart';
import '../features/chat/controllers/zoom_controller.dart';
import '../features/community/controllers/country_controller.dart';
import '../features/home/controllers/chat_lists_controller.dart';
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
    Get.put<LanguagesController>(LanguagesController());
    Get.put<ThemesController>(ThemesController());
    Get.put<SeasonsController>(SeasonsController());
    Get.put<ColorsController>(ColorsController());
    Get.put<FontsController>(FontsController());
    Get.put<ZoomsController>(ZoomsController());
    Get.put<UserController>(UserController());

    Get.put<SaveContactController>(SaveContactController());
    Get.put<DialogController>(DialogController());
    Get.put<OverlayColorController>(OverlayColorController());
    Get.put<ExpandController>(ExpandController());
    Get.put<CountryController>(CountryController());
    Get.put<ChatListsController>(ChatListsController());

    Get.put<EmailSendRepository>(EmailSendRepository());

    Get.put<CallService>(CallService());
    Get.put<AgoraCallService>(AgoraCallService());
    Get.put<CallController>(CallController());

    Get.put<VoiceRecorderService>(VoiceRecorderService());
    Get.put<VoicePlaybackService>(VoicePlaybackService());

    Get.put<YandexDiskApi>(YandexDiskApi());
    Get.put<MediaService>(YandexDiskService(Get.find<YandexDiskApi>()));
  }
}
