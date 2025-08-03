import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/community_model.dart';
import 'package:chatify/features/community/screens/community_data_screen.dart';
import 'package:chatify/features/community/screens/settings_community_screen.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../group/screens/add_group_screen.dart';
import '../widgets/community_widget.dart';
import '../widgets/dialogs/invite_participants_bottom_dialog.dart';

class CommunityInfoScreen extends StatefulWidget {
  final CommunityModel community;
  final DateTime? createdAt;
  final bool Function(DateTime) isValidDate;
  final String fileToSend;

  const CommunityInfoScreen({
    super.key,
    required this.community,
    this.createdAt,
    required this.isValidDate,
    required this.fileToSend,
  });

  @override
  State<CommunityInfoScreen> createState() => _CommunityInfoScreenState();
}

class _CommunityInfoScreenState extends State<CommunityInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.community.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Icon(Icons.groups, color: ChatifyColors.white, size: 30)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Icon(Icons.groups, color: ChatifyColors.white, size: 30)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.community.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Сообщество · 2 группы', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _popupMenu(context),
          Positioned.fill(
            top: 180,
            child: Column(
              children: [
                Expanded(
                  child: CommunityWidgets(createdAt: widget.createdAt, isValidDate: widget.isValidDate, showAllButton: false, showGroupsSection: true, community: widget.community),
                ),
              ],
            ),
          ),
          _textCommunity(),
          _buttonAddGroup(context),
        ],
      ),
    );
  }

  Widget _popupMenu(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, createPageRoute(CommunityDataScreen(community: widget.community)));
              } else if (value == 2) {
                showBottomSheetDialogNewGroups(context, widget.fileToSend);
              } else if (value == 3) {
                Navigator.push(context, createPageRoute(const SettingsCommunityScreen()));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.all(16.0),
                child: Text(S.of(context).communityData, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 2,
                padding: const EdgeInsets.all(16.0),
                child: Text(S.of(context).inviteParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 3,
                padding: const EdgeInsets.all(16.0),
                child: Text(S.of(context).communitySettings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
    );
  }

  Widget _textCommunity() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          S.of(context).groupsAddedCommunityDisplayed,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buttonAddGroup(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: SizedBox(
          height: 45,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, createPageRoute(const AddGroupScreen()));
            },
            icon: const Icon(Icons.add, size: 18, color: ChatifyColors.white),
            label: Text(S.of(context).addGroup, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            style: ElevatedButton.styleFrom(
              elevation: 1,
              side: BorderSide.none,
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
