import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showChatsCallsPrivacyBottomSheet(BuildContext context, {required String headerText, required String titleText}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(child: SvgPicture.asset(colorsController.getImagePath(), width: 100, height: 100)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Center(child: Text(headerText, style: TextStyle(fontSize: ChatifySizes.fontSizeBg), textAlign: TextAlign.center)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
              child: Center(
                child: Text(titleText, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5), textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 16),
            _buildIconTextRow(icon: Icons.message_outlined, text: S.of(context).textVoiceMessages),
            _buildIconTextRow(icon: Icons.call_outlined, text: S.of(context).audioVideoCalls),
            _buildIconTextRow(icon: Icons.attach_file, text: S.of(context).photosVideosDocuments),
            _buildIconTextRow(icon: Icons.location_on_outlined, text: S.of(context).yourLocation),
            _buildIconTextRow(icon: Icons.update, text: S.of(context).statusUpdates, isSvg: true),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await UrlUtils.launchURL(AppLinks.security);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    side: BorderSide.none,
                  ),
                  child: Text(S.of(context).readMore, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildIconTextRow({required IconData icon, required String text, bool isSvg = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isSvg
          ? SvgPicture.asset(ChatifyVectors.status, width: 24, height: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value))
          : Icon(icon, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500, color: ChatifyColors.darkGrey)),
        ),
      ],
    ),
  );
}
