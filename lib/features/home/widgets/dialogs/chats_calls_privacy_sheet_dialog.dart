import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_color_assets.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showChatsCallsPrivacyBottomSheet(BuildContext context, {required String headerText, required String titleText}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 14),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 25),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(child: SvgPicture.asset(colorsController.getAsset(ChatifyColorAssetsList.strongbox), width: 100, height: 100)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(child: Text(headerText, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Center(
                child: Text(titleText, style: TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400, height: 1.5), textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 16),
            _buildIconTextRow(context, svgAsset: ChatifyVectors.messageOutline, text: S.of(context).textVoiceMessages),
            _buildIconTextRow(context, icon: Icons.call_outlined, text: S.of(context).audioVideoCalls),
            _buildIconTextRow(context, icon: Icons.attach_file, text: S.of(context).photosVideosDocuments),
            _buildIconTextRow(context, icon: Icons.location_on_outlined, text: S.of(context).yourLocation),
            _buildIconTextRow(context, svgAsset: ChatifyVectors.status, text: S.of(context).statusUpdates, isSvg: true),
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
                  child: Text(S.of(context).readMore, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildIconTextRow(BuildContext context, {IconData? icon, String? svgAsset, double iconSize = 24, required String text, bool isSvg = false}) {
  Widget leadingIcon;
  if (svgAsset != null) {
    leadingIcon = SvgPicture.asset(svgAsset, width: iconSize, height: iconSize, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, BlendMode.srcIn));
  } else if (icon != null) {
    leadingIcon = Icon(icon, size: iconSize, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black);
  } else {
    leadingIcon = const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        leadingIcon,
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400))),
      ],
    ),
  );
}
