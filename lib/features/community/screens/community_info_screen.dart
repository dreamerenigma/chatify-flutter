import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../models/community_model.dart';
import 'package:chatify/features/community/screens/community_data_screen.dart';
import 'package:chatify/features/community/screens/settings_community_screen.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/buttons/animated_add_group_button.dart';
import '../widgets/community_widget.dart';
import '../widgets/dialogs/invite_participants_bottom_dialog.dart';
import '../widgets/media/community_network_image.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TooltipTheme(
                data: TooltipThemeData(
                  decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                  child: PopupMenuButton<int>(
                    tooltip: S.of(context).more,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-8, 0),
                    menuPadding: const EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(minWidth: 0, maxWidth: 230),
                    icon: const Icon(Icons.more_vert),
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                        }

                        return ChatifyColors.transparent;
                      }),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: S.of(context).communityData,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, createPageRoute(CommunityDataScreen(community: widget.community, user: APIs.me)));
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: S.of(context).inviteParticipants,
                          onTap: () {
                            Navigator.pop(context);
                            showInviteParticipantsBottomSheetDialog(context, widget.fileToSend);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: S.of(context).communitySettings,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, createPageRoute(const SettingsCommunityScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CommunityNetworkImage(imagePath: widget.community.image, width: 60, height: 60, isWindows: isWindows, borderRadius: BorderRadius.circular(20), angle: 0),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.community.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 8),
                          Text('Сообщество · 2 группы', style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Stack(
                children: [
                  CommunityWidgets(isValidDate: (date) => true, showAllButton: false, isInteractive: true, showGroupsSection: true, community: widget.community, user: APIs.me),
                  Align(alignment: Alignment.center, child: _buildTextCommunity()),
                  _buttonAddGroup(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCommunity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        S.of(context).groupsAddedCommunityDisplayed,
        textAlign: TextAlign.center,
        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.softGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buttonAddGroup(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05), child: AnimatedAddGroupButton(community: widget.community)),
    );
  }
}
