import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'automatic_timer_screen.dart';
import 'last_visited_time_screen.dart';

class ExtraPrivacyChatsCheckScreen extends StatefulWidget {
  const ExtraPrivacyChatsCheckScreen({super.key});

  @override
  State<ExtraPrivacyChatsCheckScreen> createState() => ExtraPrivacyChatsCheckScreenState();
}

class ExtraPrivacyChatsCheckScreenState extends State<ExtraPrivacyChatsCheckScreen> {
  static const Map<String, int> _schemeMap = {
    'blue': 0,
    'red': 1,
    'green': 2,
    'orange': 3,
  };

  String getAsset(int schemeIndex) {
    switch (schemeIndex) {
      case 0:
        return ChatifyVectors.lockBlue;
      case 1:
        return ChatifyVectors.lockRed;
      case 2:
        return ChatifyVectors.lockGreen;
      case 3:
        return ChatifyVectors.lockOrange;
      default:
        return ChatifyVectors.lockBlue;
    }
  }

  int mapSchemeToIndex(String scheme) {
    return _schemeMap[scheme.toLowerCase().trim()] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
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
                    Stack(
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(ChatifyVectors.message, height: 100, width: 100),
                        Positioned(
                          right: -35,
                          top: 16,
                          child: Center(child: SvgPicture.asset(getAsset(schemeIndex), height: 70, width: 70)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(S.of(context).extraPrivacyYourChats, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: Text(S.of(context).usePrivacyProtectAccessMessageMedia, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 10),
                    _buildCheckPrivacy(
                      icon: Icons.timer,
                      text: S.of(context).automaticMessageTimer,
                      subtitle: S.of(context).newChatsMessagesDisappearSetTimer,
                      onTap: () {
                        Navigator.push(context, createPageRoute(const AutomaticTimerScreen()));
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildCheckPrivacy(
                      icon: Icons.lock_outline,
                      text: S.of(context).backupEndToEndEncryption,
                      subtitle: S.of(context).enableEncryptionBackupEmployeesAccess,
                      onTap: () {
                        Navigator.push(context, createPageRoute(const LastVisitedTimeScreen()));
                      }
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
    IconData? icon,
    String? svgIconPath,
    required String text,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: ChatifyColors.darkGrey, size: 26)
            else if (svgIconPath != null)
              SvgPicture.asset(svgIconPath, color: ChatifyColors.darkGrey, width: 26, height: 26)
            else
              const SizedBox(width: 26, height: 26),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal, height: 1.3)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, height: 1.3, color: ChatifyColors.darkGrey)),
                ],
              ),
            ),
            const SizedBox(width: 35),
            const Icon(Icons.arrow_forward_rounded, color: ChatifyColors.darkGrey, size: 24),
          ],
        ),
      ),
    );
  }
}
