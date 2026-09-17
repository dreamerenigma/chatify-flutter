import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../community/models/community_model.dart';
import '../../community/widgets/community_widget.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';

class AddGroupScreen extends StatefulWidget {
  final CommunityModel community;

  const AddGroupScreen({
    super.key,
    required this.community,
  });

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? Colors.white.withAlpha((0.1 * 255).toInt()) : Colors.black.withAlpha((0.1 * 255).toInt());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: ChatifyColors.white, boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 0, blurRadius: 0.5, offset: const Offset(0, 0.5))]),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).managingGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                Text('2 из 101', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                      child: const Icon(Icons.group_outlined, color: ChatifyColors.black),
                    ),
                    const SizedBox(width: 18),
                    Text(S.of(context).newGroup, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: ChatifyColors.black),
                    ),
                    const SizedBox(width: 18),
                    Text(S.of(context).addNounGroup, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                children: [
                  TextSpan(text: S.of(context).membersCanProposeExistingGroups.replaceFirst('настройки сообщества', '')),
                  TextSpan(
                    text: ' ${S.of(context).openCommunitySettings}',
                    style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w600, height: 1.4),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, bottom: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Text(S.of(context).groupsInCommunity, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          ),
          Expanded(
            child: CommunityWidgets(
              isValidDate: (date) => true,
              showAllButton: false,
              isInteractive: false,
              community: widget.community,
              hideAdsPreview: true,
              hideAdsDate: true,
              showGeneralCloseIcon: true,
              user: APIs.me,
              generalSubtitle: widget.community.creatorId == APIs.auth.currentUser?.uid ? 'Вы' : widget.community.creatorName,
            ),
          ),
        ],
      ),
    );
  }
}
