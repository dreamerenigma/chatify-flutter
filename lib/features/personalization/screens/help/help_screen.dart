import 'package:chatify/features/personalization/screens/help/support/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'about_app_screen.dart';
import 'complaints_screen.dart';
import 'help_center_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: ChatifyColors.white, boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))]),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text(S.of(context).help, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
            iconTheme: IconThemeData(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsMenuTile(
                  icon: Icons.help,
                  title: S.of(context).helpCenter,
                  subTitle: S.of(context).subtitleHelpCenter,
                  titleFontSize: 15,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: ChatifyColors.transparent,
                  noRoundedCorners: true,
                  onTap: () => Get.to(() => const HelpCenterScreen()),
                ),
                SettingsMenuTile(
                  icon: Icons.bug_report,
                  title: S.of(context).reportBug,
                  subTitle: S.of(context).subtitleReportBug,
                  titleFontSize: 15,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: ChatifyColors.transparent,
                  noRoundedCorners: true,
                  onTap: () => Navigator.push(context, createPageRoute(const SupportScreen(title: 'Сообщить об ошибке', showText: false, showReadMoreText: true, showCompactButtonOnly: true))),
                ),
                SettingsMenuTile(
                  icon: MonoIcons.document,
                  title: S.of(context).termsPrivacyPolicy,
                  subTitle: '',
                  titleFontSize: 15,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: ChatifyColors.transparent,
                  noRoundedCorners: true,
                  onTap: () {
                    UrlUtils.launchURL(AppLinks.privacyPolicy);
                  },
                ),
                SettingsMenuTile(
                  icon: Icons.warning_amber_rounded,
                  title: S.of(context).complaints,
                  subTitle: '',
                  titleFontSize: 15,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: ChatifyColors.transparent,
                  noRoundedCorners: true,
                  onTap: () => Get.to(() => const ComplaintsScreen()),
                ),
                SettingsMenuTile(
                  icon: Icons.info_outline,
                  title: S.of(context).subtitleAbout,
                  subTitle: '',
                  titleFontSize: 15,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: ChatifyColors.transparent,
                  noRoundedCorners: true,
                  onTap: () => Get.to(() => const AboutAppScreen()),
                ),
                const SizedBox(height: ChatifySizes.spaceBtwItems),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
