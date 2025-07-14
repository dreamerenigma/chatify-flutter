import 'dart:math';
import 'package:chatify/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/screens/send/send_file_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialog/select_call_dialog.dart';
import 'link_audio_screen.dart';
import 'link_video_screen.dart';

class CallTypeController extends GetxController {
  var selectedCallType = 'Видео'.obs;
  var invitationId = ''.obs;

  CallTypeController() {
    regenerateInvitationId();
  }

  void updateCallType(String newCallType) {
    selectedCallType.value = newCallType;
    regenerateInvitationId();
  }

  void regenerateInvitationId() {
    invitationId.value = _generateUniqueId();
  }

  String _generateUniqueId({int length = 16}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}

class CreateLinkCallScreen extends StatelessWidget {
  const CreateLinkCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CallTypeController callTypeController = Get.put(CallTypeController());

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Создать ссылку на звонок', style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              'Любой пользователь Chatify может присоединиться к звонку по этой ссылке. Делитесь ей только с теми людьми, которым вы доверяете.',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
            ),
          ),
          InkWell(
            onTap: () {
              String invitationLink = _buildInvitationLink(
                callTypeController.selectedCallType.value,
                callTypeController.invitationId.value,
              );

              if (callTypeController.selectedCallType.value == 'Аудио') {
                Navigator.push(context, createPageRoute(LinkAudioScreen(linkToSend: invitationLink, user: APIs.me)));
              } else {
                Navigator.push(context, createPageRoute(LinkVideoScreen(linkToSend: invitationLink, user: APIs.me)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        child: Obx(() {
                          IconData icon = callTypeController.selectedCallType.value == 'Видео' ? Icons.videocam_outlined : Icons.call_outlined;
                          return Icon(
                            icon,
                            size: 32.0,
                          );
                        }),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Obx(() {
                          String invitationLink = _buildInvitationLink(
                            callTypeController.selectedCallType.value,
                            callTypeController.invitationId.value,
                          );
                          return Text(
                            invitationLink,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            maxLines: 2,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              showSelectCallDialog(
                context,
                'Выберите тип звонка',
                callTypeController.selectedCallType.value, (String newCallType) {
                  callTypeController.updateCallType(newCallType);
                },
              );
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 90),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Тип звонка', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    callTypeController.selectedCallType.value,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Divider(height: 0, thickness: 1),
          InkWell(
            onTap: () {
              String invitationLink = _buildInvitationLink(
                callTypeController.selectedCallType.value,
                callTypeController.invitationId.value,
              );

              Navigator.push(context, createPageRoute(SendFileScreen(linkToSend: invitationLink, fileToSend: '')));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(PhosphorIcons.arrow_bend_double_up_right_bold, color: ChatifyColors.darkGrey),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Отправить ссылку через Chatify',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLg),
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String invitationLink = _buildInvitationLink(
                callTypeController.selectedCallType.value,
                callTypeController.invitationId.value,
              );
              Clipboard.setData(ClipboardData(text: invitationLink)).then((_) {
                Dialogs.showSnackbarMargin(context, 'Ссылка скопированна', margin: const EdgeInsets.only(left: 10, right: 10));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, color: ChatifyColors.darkGrey),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  Text('Копировать ссылку', style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String invitationLink = _buildInvitationLink(
                callTypeController.selectedCallType.value,
                callTypeController.invitationId.value,
              );
              Share.share(invitationLink);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: ChatifyColors.darkGrey),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  Text('Поделиться ссылкой', style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildInvitationLink(String callType, String invitationId) {
    String callPath = callType == 'Видео' ? 'video' : 'voice';
    return 'https://call.chatify.ru/$callPath/$invitationId';
  }
}
