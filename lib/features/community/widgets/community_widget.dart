import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../screens/community_info_screen.dart';
import '../screens/community_screen.dart';
import '../screens/general_chat_screen.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:chatify/routes/custom_page_route.dart';

class CommunityWidgets extends StatefulWidget {
  final bool Function(DateTime) isValidDate;
  final bool showAllButton;
  final bool isInteractive;
  final bool showGroupsSection;
  final CommunityModel community;

  const CommunityWidgets({
    super.key,
    required this.isValidDate,
    this.showAllButton = false,
    this.isInteractive = true,
    this.showGroupsSection = false,
    required this.community,
  });

  @override
  State<CommunityWidgets> createState() => _CommunityWidgetsState();
}

class _CommunityWidgetsState extends State<CommunityWidgets> {
  static String getCommunityCreationDate({required BuildContext context, required DateTime creationDate}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(creationDate.year, creationDate.month, creationDate.day);
    final difference = today.difference(date).inDays;

    if (difference == 0) {
      return 'Сегодня';
    }

    if (difference == 1) {
      return 'Вчера';
    }

    if (creationDate.year == now.year) {
      return DateFormat('d MMM', Localizations.localeOf(context).toString()).format(creationDate);
    }

    return DateFormat('dd.MM.yyyy', Localizations.localeOf(context).toString()).format(creationDate);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isInteractive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                Navigator.push(context, createPageRoute(CommunityScreen(user: APIs.me)));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Padding(padding: const EdgeInsets.only(top: 2), child: SvgPicture.asset(ChatifyVectors.megaphone, width: 24, height: 24, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)))),
                    ),
                    const SizedBox(width: 16),
                    _buildAds(context),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showGroupsSection) ...[
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
            Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8), child: Text(S.of(context).groupsYouMember, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
          ],
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                Navigator.push(context, createPageRoute(const GeneralChatScreen()));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: ChatifyColors.buttonDisabled, borderRadius: BorderRadius.circular(30)),
                      child: Center(child: SvgPicture.asset(ChatifyVectors.communityMessage, width: 24, height: 24)),
                    ),
                    const SizedBox(width: 16),
                    _buildGeneral(context),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showAllButton) _buildAll(context),
        ],
      ),
    );
  }

  Widget _buildAds(BuildContext context) {
    final createdAt = widget.community.createdAt;

    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).announcements, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  S.of(context).welcomeToCommunity,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textWidthBasis: TextWidthBasis.parent,
                ),
              ],
            ),
          ),
          Text(
            getCommunityCreationDate(context: context, creationDate: createdAt),
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneral(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).generalCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(S.of(context).newCommunityMembersAddedAuto, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              getCommunityCreationDate(context: context, creationDate: widget.community.createdAt),
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAll(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          Navigator.push(context, createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: widget.isValidDate, fileToSend: '')));
        },
        child: Container(
          padding: const EdgeInsets.only(left: 28, top: 16, bottom: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ChatifyColors.darkGrey),
              const SizedBox(width: 30),
              Text(S.of(context).all, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
