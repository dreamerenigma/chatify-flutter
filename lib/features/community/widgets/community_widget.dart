import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/helper/date_util.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../screens/community_info_screen.dart';
import '../screens/general_chat_screen.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:chatify/features/home/screens/home_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';

class CommunityWidgets extends StatefulWidget {
  final DateTime? createdAt;
  final bool Function(DateTime) isValidDate;
  final bool showAllButton;
  final bool isInteractive;
  final bool showGroupsSection;
  final CommunityModel community;

  const CommunityWidgets({
    super.key,
    required this.createdAt,
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
              onTap: () {
                Navigator.push(context, createPageRoute(HomeScreen(user: APIs.me)));
              },
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
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
                      child: Center(child: Padding(padding: const EdgeInsets.only(top: 2), child: SvgPicture.asset(ChatifyVectors.megaphone, color: ChatifyColors.white, width: 24, height: 24))),
                    ),
                    const SizedBox(width: 16),
                    _buildAds(context),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showGroupsSection) ...[
            const Divider(height: 0, thickness: 1),
            Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8), child: Text(S.of(context).groupsYouMember)),
          ],
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(const GeneralChatScreen()));
              },
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(30)),
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
                Text(S.of(context).welcomeToCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeSm), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false, textWidthBasis: TextWidthBasis.parent),
              ],
            ),
          ),
          Text(
            widget.createdAt != null ? (widget.isValidDate(widget.createdAt!) ? DateUtil.getCommunityCreationDate(context: context, creationDate: widget.createdAt!) : 'Invalid Date') : 'Нет даты',
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontFamily: 'Roboto'),
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
                Text(
                  S.of(context).newCommunityMembersAddedAuto,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              widget.createdAt != null ? (widget.isValidDate(widget.createdAt!) ? DateUtil.getCommunityCreationDate(context: context, creationDate: widget.createdAt!) : S.of(context).invalidDate) : S.of(context).noDate,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontFamily: 'Roboto'),
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
        onTap: () {
          Navigator.push(context, createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: widget.isValidDate, fileToSend: '')));
        },
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Container(
          padding: const EdgeInsets.only(left: 28, top: 16, bottom: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ChatifyColors.darkGrey),
              const SizedBox(width: 30),
              Text(S.of(context).all, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ],
          ),
        ),
      ),
    );
  }
}
