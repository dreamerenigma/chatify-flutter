import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'add_email_screen.dart';

class EmailAddressScreen extends StatelessWidget {
  const EmailAddressScreen({super.key});

  static const Map<String, int> _schemeMap = {
    'blue': 0,
    'red': 1,
    'green': 2,
    'orange': 3,
  };

  String getAsset(int schemeIndex) {
    switch (schemeIndex) {
      case 0:
        return ChatifyVectors.envelopeBlue;
      case 1:
        return ChatifyVectors.envelopeRed;
      case 2:
        return ChatifyVectors.envelopeGreen;
      case 3:
        return ChatifyVectors.envelopeOrange;
      default:
        return ChatifyVectors.envelopeBlue;
    }
  }

  int mapSchemeToIndex(String scheme) {
    return _schemeMap[scheme.toLowerCase().trim()] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Color dynamicIconColor = colorsController.getColor(colorsController.selectedColorScheme.value);
    String scheme = colorsController.selectedColorScheme.value.toString();
    int schemeIndex = mapSchemeToIndex(scheme);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            title: Text(S.of(context).emailAddress, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Center(child: SvgPicture.asset(getAsset(schemeIndex), width: 70, height: 70)),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      S.of(context).addEmailAddressSecureAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildItemInfo(icon: BootstrapIcons.shield_check, text: S.of(context).confirmAccountEven, iconColor: dynamicIconColor),
                  _buildItemInfo(icon: MdiIcons.messageQuestionOutline, text: S.of(context).emailAddressContactProvideSupport, iconColor: dynamicIconColor),
                  _buildItemInfo(icon: Icons.lock_outline_rounded, text: S.of(context).emailAddressDisplayedUsers, iconColor: dynamicIconColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(S.of(context).readMore, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, createPageRoute(const AddEmailScreen()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: ChatifyColors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).addEmailAddress, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: ChatifyColors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo({required IconData icon, required String text, required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 40, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(alignment: Alignment.center, height: 24, child: Icon(icon, size: 24, color: iconColor)),
          const SizedBox(width: 20),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.3), softWrap: true, overflow: TextOverflow.visible)),
        ],
      ),
    );
  }
}
