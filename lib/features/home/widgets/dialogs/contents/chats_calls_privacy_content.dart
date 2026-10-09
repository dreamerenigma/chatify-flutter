import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_color_assets.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_links.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/urls/url_utils.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

class ChatsCallsPrivacyContent extends StatelessWidget {
  final String headerText;
  final String titleText;
  final bool isDialog;

  const ChatsCallsPrivacyContent({
    super.key,
    required this.headerText,
    required this.titleText,
    this.isDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isDialog) ...[
            const SizedBox(height: 14),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
          ],
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          if (isDialog)
            const SizedBox(height: 40),
          Center(child: SvgPicture.asset(colorsController.getAsset(ChatifyColorAssetsList.strongbox), width: 100, height: 100)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(child: Text(headerText, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Center(
              child: Text(titleText, style: TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400, height: 1.5), textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: 10),
          _buildIconTextRow(context, svgAsset: ChatifyVectors.messageOutline, text: S.of(context).textVoiceMessages, iconSize: 23),
          _buildIconTextRow(context, icon: Icons.call_outlined, text: S.of(context).audioVideoCalls, iconSize: 22),
          _buildIconTextRow(context, icon: Icons.attach_file, text: S.of(context).photosVideosDocuments, iconSize: 23),
          _buildIconTextRow(context, icon: Icons.location_on_outlined, text: S.of(context).yourLocation),
          _buildIconTextRow(context, svgAsset: ChatifyVectors.status, text: S.of(context).statusUpdates, isSvg: true, iconSize: 22),
          const SizedBox(height: 25),
          if (isDialog) ...[
            const SizedBox(height: 5),
            _buildDialogButtons(context),
          ] else
            _buildBottomSheetButton(context),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButton(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildDialogButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () async {
              await UrlUtils.launchURL(AppLinks.security);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.2)),
            child: Text(
              S.of(context).readMore,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              side: BorderSide.none,
            ),
            child: Text(S.of(context).ok, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 25, child: leadingIcon),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400))),
        ],
      ),
    );
  }
}
