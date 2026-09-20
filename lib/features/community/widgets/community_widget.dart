import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../screens/community_info_screen.dart';
import '../screens/community_screen.dart';
import '../screens/general_chat_screen.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:chatify/routes/custom_page_route.dart';

class CommunityWidgets extends StatefulWidget {
  final UserModel user;
  final bool Function(DateTime) isValidDate;
  final bool showAllButton;
  final bool isInteractive;
  final bool showGroupsSection;
  final CommunityModel community;
  final bool hideAdsPreview;
  final bool hideAdsDate;
  final bool showGeneralCloseIcon;
  final String? generalSubtitle;

  const CommunityWidgets({
    super.key,
    required this.user,
    required this.isValidDate,
    this.showAllButton = false,
    this.isInteractive = true,
    this.showGroupsSection = false,
    required this.community,
    this.hideAdsPreview = false,
    this.hideAdsDate = false,
    this.showGeneralCloseIcon = false,
    this.generalSubtitle,
  });

  @override
  State<CommunityWidgets> createState() => _CommunityWidgetsState();
}

class _CommunityWidgetsState extends State<CommunityWidgets> {
  bool _showEventManagement = true;

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

  String get _generalSubtitle {
    if (widget.generalSubtitle != null) {
      return widget.generalSubtitle!;
    }

    return widget.community.creatorId == APIs.auth.currentUser?.uid ? 'Добро пожаловать в группу "Общая"' : 'Вы';
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isInteractive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return SizeTransition(sizeFactor: animation, alignment: Alignment.topCenter, child: FadeTransition(opacity: animation, child: child));
            },
            child: _showEventManagement
              ? _buildEventManagement(
                  context,
                  subtitle:
                  'Создавайте мероприятия и управляйте ими внутри вашего сообщества. ',
                  actionText: 'Подробнее',
                  onActionTap: () {},
                  onClose: () {
                    setState(() {
                      _showEventManagement = false;
                    });
                  },
                )
              : const SizedBox.shrink(),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                APIs.community = widget.community;

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
                      decoration: BoxDecoration(color: ChatifyColors.switcherPrimary, borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Padding(padding: const EdgeInsets.only(top: 2), child: SvgPicture.asset(ChatifyVectors.megaphone, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.buttonPrimaryLight, BlendMode.srcIn)))),
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
            Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 2), child: Text(S.of(context).groupsYouMember, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
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
                width: double.infinity,
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
    return Flexible(
      child: SizedBox(
        height: 45,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).announcements, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                  if (!widget.hideAdsPreview)
                    Text(
                      S.of(context).welcomeToCommunity,
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textWidthBasis: TextWidthBasis.parent,
                    ),
                ],
              ),
            ),
            if (!widget.hideAdsDate)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  getCommunityCreationDate(context: context, creationDate: widget.community.createdAt),
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneral(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).generalCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                Text(
                  _generalSubtitle,
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (widget.showGeneralCloseIcon)
            const Padding(padding: EdgeInsets.only(left: 8, top: 8), child: Icon(Icons.close_rounded, size: 24))
          else
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

  Widget _buildEventManagement(
    BuildContext context, {
    required String subtitle,
    required String actionText,
    required VoidCallback onActionTap,
    required VoidCallback onClose,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.buttonDisabled, width: 1)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.calendar_month_outlined, size: 30, color: ChatifyColors.borderSecondary),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                      children: [
                        TextSpan(text: subtitle),
                        TextSpan(text: actionText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colorsController.getColor(colorsController.selectedColorScheme.value)), recognizer: TapGestureRecognizer()..onTap = onActionTap),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close_rounded, size: 22, color: ChatifyColors.borderSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
