import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'add_data_about_screen.dart';
import 'links_screen.dart';

class AddLinksScreen extends StatefulWidget {
  const AddLinksScreen({super.key});

  @override
  State<AddLinksScreen> createState() => AddLinksScreenState();
}

class AddLinksScreenState extends State<AddLinksScreen> {
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
            title: Text(S.of(context).links, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      _buildAddLink(context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddLink(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            S.of(context).addingLinksAppProfileContacts,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildSocialLinkRow(
                ChatifyVectors.vk,
                S.of(context).vkontakte,
                context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddDataAboutScreen(title: S.of(context).vkontakte)));
                  },
              ),
              const SizedBox(height: 22),
              _buildSocialLinkRow(
                ChatifyVectors.ok,
                S.of(context).odnoklassniki,
                context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddDataAboutScreen(title: S.of(context).odnoklassniki)));
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: S.of(context).controlWhoSeeYourLinks, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.7)),
                TextSpan(
                  text: S.of(context).privacySettings,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.push(context, createPageRoute(LinksScreen()));
                  },
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinkRow(String iconAsset, String title, BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        splashColor: ChatifyColors.transparent,
        highlightColor: ChatifyColors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(iconAsset, height: 22, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
            const SizedBox(width: 28),
            Expanded(
              child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.add, size: 22, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
          ],
        ),
      ),
    );
  }
}
