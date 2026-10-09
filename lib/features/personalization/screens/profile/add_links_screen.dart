import 'dart:developer';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../models/social_link_model.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'add_data_about_screen.dart';
import 'links_screen.dart';

class AddLinksScreen extends StatefulWidget {
  final UserModel user;

  const AddLinksScreen({
    super.key,
    required this.user,
  });

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
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).links, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
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
    final vkLinks = widget.user.links.where((link) => link.type == 'vk').toList();
    final okLinks = widget.user.links.where((link) => link.type == 'ok').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            S.of(context).addingLinksAppProfileContacts,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            _buildSocialLinkRow(
              ChatifyVectors.vk,
              S.of(context).vkontakte,
              context,
              () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddDataAboutScreen(title: S.of(context).vkontakte, type: 'vk')));
              },
            ),
            if (vkLinks.isNotEmpty) ...[
              ...vkLinks.map((link) => _buildLinkContainer(context, ChatifyVectors.vk, link)),
            ],
            const SizedBox(height: 8),
            _buildSocialLinkRow(
              ChatifyVectors.ok,
              S.of(context).odnoklassniki,
              context,
              () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddDataAboutScreen(title: S.of(context).odnoklassniki, type: 'ok')));
              },
            ),
            if (okLinks.isNotEmpty) ...[
              ...okLinks.map((link) => _buildLinkContainer(context, ChatifyVectors.ok, link)),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: S.of(context).controlWhoSeeYourLinks,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeSm, height: 1.6),
                ),
                TextSpan(
                  text: S.of(context).privacySettings,
                  style: TextStyle(
                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.w400,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.push(context, createPageRoute(LinksScreen()));
                  },
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkContainer(BuildContext context, String icon, SocialLinkModel link) {
    final themeColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return GestureDetector(
      onTap: () async {
        log('LINK: ${link.username}');

        final url = Uri.tryParse(link.url);

        log('URI: $url');

        if (url == null) {
          log('URL IS NULL');
          return;
        }

        final canLaunch = await canLaunchUrl(url);

        log('CAN LAUNCH: $canLaunch');

        if (!canLaunch) return;

        await launchUrl(url, mode: LaunchMode.externalApplication);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 38),
        padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightBackground, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Text(link.username, style: TextStyle(color: themeColor, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () async {},
              icon: const Icon(FluentIcons.delete_24_regular, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
              color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinkRow(String iconAsset, String title, BuildContext context, VoidCallback onTap) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        mouseCursor: SystemMouseCursors.basic,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(iconAsset, width: 22, height: 22, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, BlendMode.srcIn)),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))),
              Icon(Icons.add, size: 22, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
