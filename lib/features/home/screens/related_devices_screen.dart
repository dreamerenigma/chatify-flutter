import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_links.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/urls/url_utils.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class RelatedDevicesScreen extends StatefulWidget {
  const RelatedDevicesScreen({super.key});

  @override
  State<RelatedDevicesScreen> createState() => _RelatedDevicesScreenState();
}

class _RelatedDevicesScreenState extends State<RelatedDevicesScreen> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).appRelatedDevices, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        backgroundColor: ChatifyColors.blackGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Image.asset('assets/images/devices.png', width: 120, height: 120),
            const SizedBox(height: 16),
            _buildText(),
            const SizedBox(height: 16),
            _buildButton(),
            const SizedBox(height: 24),
            Divider(height: 10, thickness: 10, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).deviceStatus, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm)),
                  const SizedBox(height: 8),
                  Text(S.of(context).selectDevicesSignOut, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StatefulBuilder(
        builder: (context, setState) {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: S.of(context).linkOtherDevicesToAccount,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.3),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() => isTapped = true);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() => isTapped = false);
                        });

                        UrlUtils.launchURL(AppLinks.addSocialLink);
                      },
                      splashColor: ChatifyColors.blueAccent.withAlpha((0.2 * 255).toInt()),
                      highlightColor: ChatifyColors.blueAccent.withAlpha((0.1 * 255).toInt()),
                      child: Text(S.of(context).readMore, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500, color: ChatifyColors.blueAccent)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            foregroundColor: ChatifyColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.symmetric(vertical: 10),
            side: BorderSide.none,
          ),
          child: Text(S.of(context).linkingDevice, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }
}
