import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../personalization/screens/send/send_file_screen.dart';
import '../../screens/create_link_call_screen.dart';

void showShareLinkBottomSheetDialog(BuildContext context) {
  final CallTypeController callTypeController = Get.put(CallTypeController());

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(S.of(context).shareLink, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            ),
            const Divider(height: 0, thickness: 1),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                String invitationLink = _buildInvitationLink(callTypeController.selectedCallType.value, callTypeController.invitationId.value);
                Navigator.push(context, createPageRoute(SendFileScreen(linkToSend: invitationLink, fileToSend: '')));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(PhosphorIcons.arrow_bend_double_up_right_bold, color: ChatifyColors.darkGrey),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 230,
                      child: Text(S.of(context).sendLinkViaApp, style: TextStyle(fontSize: ChatifySizes.fontSizeLg), softWrap: true),
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
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: invitationLink)).then((_) {
                  Dialogs.showSnackbarMargin(context, S.of(context).linkCopied, margin: const EdgeInsets.only(left: 10, right: 10));
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, color: ChatifyColors.darkGrey),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    Text(S.of(context).copyLink, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                String invitationLink = _buildInvitationLink(callTypeController.selectedCallType.value, callTypeController.invitationId.value);
                SharePlus.instance.share(
                  ShareParams(text: invitationLink),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: ChatifyColors.darkGrey),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    Text(S.of(context).shareLink, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String _buildInvitationLink(String callType, String invitationId) {
  String callPath = callType == 'Видео' ? 'video' : 'voice';
  return 'https://call.chatify.ru/$callPath/$invitationId';
}
