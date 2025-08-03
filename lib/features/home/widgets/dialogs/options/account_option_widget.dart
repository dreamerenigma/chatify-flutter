import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../common/widgets/switches/custom_switch.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_links.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/urls/url_utils.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';

class AccountOptionWidget extends StatefulWidget {
  const AccountOptionWidget({super.key});

  @override
  State<AccountOptionWidget> createState() => _AccountOptionWidgetState();
}

class _AccountOptionWidgetState extends State<AccountOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  final GetStorage storage = GetStorage();
  bool isInside = false;
  bool isViewNotification = false;
  bool isHoveredReadMore = false;
  bool isHovered = false;
  bool isHoveredDeleteAccount = false;

  @override
  void initState() {
    super.initState();
    isViewNotification = storage.read('is_view_notification') ?? false;
  }

  void _saveSetting(String key, bool value) {
    storage.write(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      scrollController: _scrollController,
      isInsidePersonalizedOption: isInside,
      onHoverChange: (bool isHovered) {
        setState(() {
          isInside = isHovered;
        });
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).account, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                const SizedBox(height: 25),
                Text(S.of(context).privacy, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
                Text(S.of(context).controlYourPhone, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic, height: 2)),
                const SizedBox(height: 10),
                Text(S.of(context).lastSeenTimeOnlineStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                Text(S.of(context).myContacts, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 2)),
                const SizedBox(height: 10),
                Text(S.of(context).profilePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                Text(S.of(context).myContacts, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 2)),
                const SizedBox(height: 10),
                Text(S.of(context).intelligence, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                Text(S.of(context).myContacts, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 2)),
                const SizedBox(height: 10),
                Text(S.of(context).addingGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                Text(S.of(context).myContacts, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 2)),
                const SizedBox(height: 10),
                Text(S.of(context).readingReports, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                Text(S.of(context).off, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, height: 2)),
                Text(S.of(context).readReceiptsCannotDisabled, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),

                const SizedBox(height: 20),
                Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),

                Text(S.of(context).blockedContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
                const SizedBox(height: 10),
                Text(S.of(context).controlYourPhone, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    HeroIcon(HeroIcons.devicePhoneMobile, size: 20),
                    const SizedBox(width: 8),
                    Text(S.of(context).noBlockedContacts, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                  ],
                ),

                const SizedBox(height: 15),
                Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),

                const SizedBox(height: 15),
                Text(S.of(context).security, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
                const SizedBox(height: 10),
                Text(S.of(context).chatsCallsConfidential, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),
                Text(S.of(context).encryptionKeepsYourMessages, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                const SizedBox(height: 15),
                Column(
                  children: [
                    _buildInfoRow(SvgPicture.asset(ChatifyVectors.text, width: 15, height: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), S.of(context).textVoiceMessages),
                    _buildInfoRow(SvgPicture.asset(ChatifyVectors.calls, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), S.of(context).audioVideoCalls),
                    _buildInfoRow(Icon(FluentIcons.attach_12_regular, size: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), S.of(context).photosVideosDocuments),
                    _buildInfoRow(SvgPicture.asset(ChatifyVectors.locationPin, width: 19, height: 19, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), S.of(context).locationSharing),
                    _buildInfoRow(SvgPicture.asset(ChatifyVectors.status, width: 19, height: 19, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), S.of(context).statusUpdate),
                  ],
                ),
                const SizedBox(height: 5),
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveredReadMore = true),
                  onExit: (_) => setState(() => isHoveredReadMore = false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      UrlUtils.launchURL(AppLinks.security);
                    },
                    child: Text(
                      S.of(context).readMore,
                      style: TextStyle(
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        fontSize: ChatifySizes.fontSizeSm,
                        fontWeight: FontWeight.w300,
                        decoration: isHoveredReadMore ? TextDecoration.none : TextDecoration.underline,
                        decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(S.of(context).securityNotifyComputer, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CustomSwitch(
                      value: isViewNotification,
                      onChanged: (bool value) {
                        setState(() {
                          isViewNotification = value;
                        });
                        _saveSetting('is_view_notification', isViewNotification);
                      },
                      activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                    SizedBox(width: 12),
                    Text(isViewNotification ? S.of(context).on : S.of(context).off, style: TextStyle(fontWeight: FontWeight.w300)),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
                    children: [
                      TextSpan(text: S.of(context).receiveNotifyPhoneSecurityCode, style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black)),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => isHovered  = true),
                          onExit: (_) => setState(() => isHovered  = false),
                          child: GestureDetector(
                            onTap: () async {
                              UrlUtils.launchURL(AppLinks.helpCenter);
                            },
                            child: Text(
                              S.of(context).readMore,
                              style: TextStyle(
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                fontWeight: FontWeight.w400,
                                fontSize: ChatifySizes.fontSizeLm,
                                decoration: isHovered  ? TextDecoration.none : TextDecoration.underline,
                                decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                const SizedBox(height: 10),
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveredDeleteAccount = true),
                  onExit: (_) => setState(() => isHoveredDeleteAccount = false),
                  child: InkWell(
                    onTap: () async {
                      UrlUtils.launchURL(AppLinks.helpEncryption);
                    },
                    splashColor: ChatifyColors.transparent,
                    highlightColor: ChatifyColors.transparent,
                    child: Container(
                      color: isHoveredDeleteAccount ? context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey : ChatifyColors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        S.of(context).howDeleteYourAccount,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(Widget icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300))),
        ],
      ),
    );
  }
}
