import 'package:chatify/features/personalization/screens/privacy/protection_accounts_privacy_check_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/select_contact_privacy_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import 'control_data_privacy_check_screen.dart';
import 'extra_privacy_chats_check_screen.dart';

class PrivacyCheckScreen extends StatefulWidget {
  const PrivacyCheckScreen({super.key});

  @override
  State<PrivacyCheckScreen> createState() => PrivacyCheckScreenState();
}

class PrivacyCheckScreenState extends State<PrivacyCheckScreen> {

  @override
  Widget build(BuildContext context) {
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
            title: Text(S.of(context).privacyCheck, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ChatifyVectors.checkPrivacy, height: 120, width: 120),
                    const SizedBox(height: 16),
                    Text(S.of(context).weCareAboutYourPrivacy, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: Text(S.of(context).manageCustomizeAppPrivacySettings, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 10),
                    _buildCheckPrivacy(icon: Icons.wifi_calling_sharp, text: S.of(context).chooseWhoContactYou, onTap: () {
                      Navigator.push(context, createPageRoute(const SelectContactPrivacyCheckScreen()));
                    }),
                    _buildCheckPrivacy(icon: Icons.person_outline, text: S.of(context).controlYourPersonalData, onTap: () {
                      Navigator.push(context, createPageRoute(const ControlDataPrivacyCheckScreen()));
                    }),
                    _buildCheckPrivacy(icon: Icons.message_outlined, text: S.of(context).additionalPrivacyInformation, onTap: () {
                      Navigator.push(context, createPageRoute(const ExtraPrivacyChatsCheckScreen()));
                    }),
                    _buildCheckPrivacy(icon: Icons.lock_person_outlined, text: S.of(context).additionalProtectionYourAccount, onTap: () {
                      Navigator.push(context, createPageRoute(const ProtectionAccountsPrivacyCheckScreen()));
                    }),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                          children: [
                            TextSpan(text: S.of(context).goTo, style: TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(text: S.of(context).settings, style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' > '),
                            TextSpan(text: S.of(context).privacy, style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: S.of(context).viewAdditionalPrivacySettings, style: TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckPrivacy({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: ChatifyColors.darkGrey, size: 26),
            const SizedBox(width: 25),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.3))),
            const SizedBox(width: 35),
            const Icon(Icons.arrow_forward_rounded, color: ChatifyColors.darkGrey, size: 24),
          ],
        ),
      ),
    );
  }
}
