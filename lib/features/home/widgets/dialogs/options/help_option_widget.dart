import 'package:chatify/utils/urls/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_links.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../version.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../overlays/contacting_support_overlay.dart';
import '../overlays/license_overlay.dart';

class HelpOptionWidget extends StatefulWidget {
  final OverlayEntry overlayEntry;

  const HelpOptionWidget({super.key, required this.overlayEntry});

  @override
  State<HelpOptionWidget> createState() => _HelpOptionWidgetState();
}

class _HelpOptionWidgetState extends State<HelpOptionWidget> {
  final ScrollController scrollController = ScrollController();
  bool isInside = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      scrollController: scrollController,
      isInsidePersonalizedOption: isInside,
      onHoverChange: (bool isHovered) {
        setState(() {
          isInside = isHovered;
        });
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            Text(S.of(context).help, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
            const SizedBox(height: 25),
            Text(S.of(context).appForWindows, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
            const SizedBox(height: 10),
            Text('${S.of(context).version} $appVersion $appBuildNumber', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
            const SizedBox(height: 15),
            Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
            const SizedBox(height: 10),
            Text(S.of(context).writeToUs, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300)),
            const SizedBox(height: 10),
            Text(S.of(context).weThinkAboutThisApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
            const SizedBox(height: 5),
            _buildHelpInfo(S.of(context).writeToUs, () {
              widget.overlayEntry.remove();
              ContactingSupportOverlay(context).show();
            }),
            _buildHelpInfo(S.of(context).rateApp, () {
              UrlUtils.launchURL(AppLinks.app);
            }),
            const SizedBox(height: 10),
            Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
            const SizedBox(height: 5),
            _buildHelpInfo(S.of(context).helpCenter, () {
              UrlUtils.launchURL(AppLinks.helpCenter);
            }),
            _buildHelpInfo(S.of(context).licenses, () {
              LicenseOverlay(context).show();
            }),
            _buildHelpInfo(S.of(context).termsPrivacyPolicy, () {
              UrlUtils.launchURL(AppLinks.legal);
            }),
            const SizedBox(height: 10),
            Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
            const SizedBox(height: 15),
            Text('© ${DateTime.now().year} Input Studios Inc.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpInfo(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            onEnter: (_) {},
            onExit: (_) {},
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.1 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.1 * 255).toInt()),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: ChatifyColors.transparent, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
