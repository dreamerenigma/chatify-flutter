import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/screens/send/send_file_screen.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../screens/add_user_screen.dart';

void showInviteParticipantsBottomSheetDialog(BuildContext context, String fileToSend) {
  String invitationId = _generateUniqueId();
  String invitationLink = 'https://chat.chatify.ru/$invitationId';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: Center(child: CircleAvatar(backgroundColor: ChatifyColors.blueGreenDark.withValues(alpha: 0.1), radius: 30, child: const Icon(Icons.person_add_alt_1_rounded, color: ChatifyColors.blueGreenDark, size: 32))),
          ),
          const SizedBox(height: 14),
          Center(child: Text(S.of(context).inviteParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          const SizedBox(height: 25),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                SharePlus.instance.share(ShareParams(text: invitationLink));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const CircleAvatar(backgroundColor: ChatifyColors.green, radius: 26, child: Icon(Icons.link, size: 24, color: ChatifyColors.black)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(invitationLink, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  ],
                ),
              ),
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, createPageRoute(SendFileScreen(fileToSend: fileToSend, linkToSend: '')));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 18, height: 18, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(S.of(context).sendLinkViaApp, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, createPageRoute(const AddUserScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.person_add_alt_outlined),
                    const SizedBox(width: 16),
                    Expanded(child: Text(S.of(context).addParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  ],
                ),
              ),
            ),
          ),
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
