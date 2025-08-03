import 'package:chatify/features/calls/widgets/dialog/share_link_sheet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/add_participants_screen.dart';

void showWaitingParticipantBottomSheetDialog(BuildContext context) {
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
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(S.of(context).waitingForOtherParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            ),
            InkWell(
              onTap: () {
                showShareLinkBottomSheetDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      child: const Icon(Icons.link, color: ChatifyColors.white),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).shareLink, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(S.of(context).anyUserLinkCanJoin, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(const AddParticipantsScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      child: const Icon(Icons.person_add_alt_1_rounded, color: ChatifyColors.white),
                    ),
                    const SizedBox(width: 18),
                    Text(S.of(context).addParticipants, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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