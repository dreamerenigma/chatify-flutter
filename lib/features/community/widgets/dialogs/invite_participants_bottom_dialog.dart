import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/screens/send/send_file_screen.dart';
import '../../screens/add_user_screen.dart';

void showBottomSheetDialogNewGroups(BuildContext context, String fileToSend) {
  String invitationId = _generateUniqueId();
  String invitationLink = 'https://chat.chatify.ru/$invitationId';

  showModalBottomSheet(
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: Center(
              child: CircleAvatar(
                backgroundColor: ChatifyColors.green,
                radius: 30,
                child: Icon(Icons.person_add_alt_1_rounded, color: ChatifyColors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text('Пригласить участников', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 18.0),
          const Divider(height: 0, thickness: 1),
          InkWell(
            onTap: () {
              Share.share(invitationLink);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.link, color: ChatifyColors.white)),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(invitationLink, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0, thickness: 1),
          InkWell(
            onTap: () {
              Navigator.push(context, createPageRoute(SendFileScreen(fileToSend: fileToSend, linkToSend: '')));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const Icon(PhosphorIcons.arrow_bend_double_up_right_bold),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text('Отправить ссылку через Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, createPageRoute(const AddUserScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const Icon(Icons.person_add_alt_outlined),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text('Добавить участников', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      );
    },
  );
}

String _generateUniqueId({int length = 16}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}
