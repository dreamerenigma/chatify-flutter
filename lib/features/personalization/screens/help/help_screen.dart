import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mono_icons/mono_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
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
          decoration: BoxDecoration(
            color: Colors.white,
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text(S.of(context).help, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
            iconTheme: IconThemeData(
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Body
            const SizedBox(height: ChatifySizes.spaceBtwItems),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsMenuTile(
                  icon: Icons.help,
                  title: S.of(context).helpCenter,
                  subTitle: S.of(context).subtitleHelpCenter,
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onTap: () => Get.to(() => const HelpCenterScreen()),
                ),
                SettingsMenuTile(
                  icon: MonoIcons.document,
                  title: S.of(context).termsPrivacyPolicy,
                  subTitle: '',
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onTap: () {
                    launchUrl(Uri.parse('https://inputstudios.vercel.app/privacy'));
                  },
                ),
                SettingsMenuTile(
                  icon: Icons.warning_amber_rounded,
                  title: S.of(context).complaints,
                  subTitle: '',
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onTap: () => Get.to(() => const ComplaintsScreen()),
                ),
                SettingsMenuTile(
                  icon: Icons.info_outline,
                  title: S.of(context).subtitleAbout,
                  subTitle: '',
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
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
