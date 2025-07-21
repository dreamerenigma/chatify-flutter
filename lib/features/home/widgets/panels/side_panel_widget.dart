import 'package:chatify/features/bot/models/support_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../bot/widgets/widget/support_chat_widget.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/widget/chat_widget.dart';
import '../../../community/models/community_model.dart';
import '../../../community/widgets/widget/community_widget.dart';
import '../../../group/models/group_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../group/widgets/widget/group_chat_widget.dart';
import '../../../newsletter/widgets/widget/newsletter_widget.dart';
import '../../../newsletter/models/newsletter.dart';
import '../widgets/archive_widget.dart';
import '../widgets/calls_widget.dart';
import '../widgets/chats_widget.dart';
import '../widgets/favorite_widget.dart';
import '../widgets/status_widget.dart';
import '../widgets/calls_screen_widget.dart';
import '../widgets/main_screen_widget.dart';
import '../widgets/status_screen_widget.dart';

class SidePanelWidget extends StatefulWidget {
  final double sidePanelWidth;
  final double minSidePanelWidth;
  final double maxSidePanelWidth;
  final ValueChanged<double> onWidthChanged;
  final bool isClicked;
  final bool isHovered ;
  final List<GroupModel> groups;
  final List<NewsletterModel> newsletters;
  final List<CommunityModel> communities;
  final List<UserModel> users;
  final List<SupportAppModel> supports;
  final bool isSearching;
  final List<UserModel> searchList;
  final int selectedIndex;
  final UserModel user;

  const SidePanelWidget({
    super.key,
    required this.sidePanelWidth,
    required this.minSidePanelWidth,
    required this.maxSidePanelWidth,
    required this.onWidthChanged,
    required this.isClicked,
    required this.isHovered,
    required this.groups,
    required this.newsletters,
    required this.communities,
    required this.users,
    required this.supports,
    required this.isSearching,
    required this.searchList,
    required this.selectedIndex,
    required this.user,
  });

  @override
  State<SidePanelWidget> createState() => _SidePanelWidgetState();
}

class _SidePanelWidgetState extends State<SidePanelWidget> {
  final userController = Get.find<UserController>();
  GroupModel? selectedGroup;
  NewsletterModel? selectedNewsletter;
  CommunityModel? selectedCommunity;
  UserModel? selectedUser;
  SupportAppModel? selectedSupport;
  double newSidePanelWidth = 0;
  bool isHovered = false;
  bool isClicked = false;
  bool showCurrentCall = false;
  bool isCalling = false;

  @override
  void initState() {
    super.initState();
    newSidePanelWidth = widget.sidePanelWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth >= 600;
        bool hideSidePanel = (selectedUser != null && constraints.maxWidth < 600);

        return Stack(
          children: [
            Row(
              children: [
                if (!hideSidePanel)
                Flexible(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                      border: Border(
                        top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey),
                        bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey),
                        left: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey),
                        right: BorderSide.none,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (widget.selectedIndex == 0)
                          ChatsWidget(
                            user: widget.user,
                            groups: widget.groups,
                            newsletters: widget.newsletters,
                            communities: widget.communities,
                            users: widget.users,
                            supports: widget.supports,
                            isSearching: widget.isSearching,
                            searchList: widget.searchList,
                            selectedUser: selectedUser,
                            onGroupSelected: (group) {
                              setState(() {
                                selectedGroup = group;
                                selectedNewsletter = null;
                                selectedCommunity = null;
                                selectedUser = null;
                                selectedSupport = null;
                              });
                            },
                            onNewsletterSelected: (newsletter) {
                              setState(() {
                                selectedNewsletter = newsletter;
                                selectedGroup = null;
                                selectedCommunity = null;
                                selectedUser = null;
                                selectedSupport = null;
                              });
                            },
                            onCommunitySelected: (community) {
                              setState(() {
                                selectedCommunity = community;
                                selectedUser = null;
                                selectedGroup = null;
                                selectedNewsletter = null;
                                selectedSupport = null;
                              });
                            },
                            onUserSelected: (chatUser) {
                              setState(() {
                                selectedUser = chatUser;
                                selectedGroup = null;
                                selectedNewsletter = null;
                                selectedCommunity = null;
                                selectedSupport = null;
                              });
                            },
                            onSupportSelected: (support) {
                              setState(() {
                                selectedSupport = support;
                                selectedGroup = null;
                                selectedNewsletter = null;
                                selectedCommunity = null;
                                selectedUser = null;
                              });
                            },
                          )
                        else if (widget.selectedIndex == 1)
                          CallsWidget(
                            groupName: '',
                            groupImage: '',
                            showCurrentCall: showCurrentCall,
                            onStartCall: () {
                              setState(() => showCurrentCall = true);
                            },
                          )
                        else if (widget.selectedIndex == 2)
                          StatusWidget()
                        else if (widget.selectedIndex == 3)
                          FavoriteWidget()
                        else if (widget.selectedIndex == 4)
                          ArchiveWidget(isSearching: widget.isSearching, searchList: widget.searchList, users: widget.users, archivedUsers: [], user: widget.user)
                        else
                          SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                if (isWideScreen) ...[
                  Container(
                    width: constraints.maxWidth - newSidePanelWidth,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
                      border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey, width: 1)),
                    ),
                    child: _buildCenteredContent(),
                  ),
                ] else if (selectedUser != null) ...[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
                        border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey, width: 1)),
                      ),
                      child: _buildCenteredContent(),
                    ),
                  ),
                ],
              ],
            ),
            if (isWideScreen)
            Positioned(
              left: newSidePanelWidth,
              top: 0,
              bottom: 0,
              width: 10,
              child: MouseRegion(
                cursor: isHovered || isClicked ? SystemMouseCursors.resizeLeftRight : SystemMouseCursors.basic,
                onEnter: (_) {
                  if (!isClicked) setState(() => isHovered = true);
                },
                onExit: (_) {
                  if (!isClicked) setState(() => isHovered = false);
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (_) => setState(() => isClicked = true),
                  onPanEnd: (_) => setState(() => isClicked = false),
                  onPanCancel: () => setState(() => isClicked = false),
                  onPanUpdate: (details) {
                    if (isClicked) {
                      setState(() {
                        newSidePanelWidth += details.delta.dx;
                        newSidePanelWidth = newSidePanelWidth.clamp(widget.minSidePanelWidth, widget.maxSidePanelWidth);
                        widget.onWidthChanged(newSidePanelWidth);
                      });
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isHovered || isClicked ? 7 : 1,
                      height: double.infinity,
                      color: isClicked ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : isHovered
                        ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt())
                        : (context.isDarkMode ? ChatifyColors.cardColor : ChatifyColors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCenteredContent() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;
    Widget content;

    switch (widget.selectedIndex) {
      case 0:
        if (selectedGroup != null) {
          content = GroupChatWidget(sidePanelWidth: newSidePanelWidth, group: selectedGroup!);
        } else if (selectedNewsletter != null) {
          content = NewsletterWidget(sidePanelWidth: newSidePanelWidth, newsletter: selectedNewsletter!, newsletters: widget.newsletters.map((n) => n.creatorName).toSet().toList(), user: widget.user);
        } else if (selectedCommunity != null) {
          content = CommunityWidget(sidePanelWidth: newSidePanelWidth, community: selectedCommunity!, user: widget.user);
        } else if (selectedUser != null) {
          content = ChatWidget(sidePanelWidth: isSmallScreen ? screenWidth : newSidePanelWidth, user: selectedUser!);
        } else if (selectedSupport != null) {
          content = SupportChatWidget(sidePanelWidth: isSmallScreen ? screenWidth : newSidePanelWidth, support: selectedSupport!);
        } else {
          content = MainScreenWidget(sidePanelWidth: newSidePanelWidth);
        }
        break;
      case 1:
        content = CallsScreenWidget(
          sidePanelWidth: newSidePanelWidth,
          isCalling: isCalling,
          onStartCall: () {
            setState(() => showCurrentCall = true);
          },
          onCallingChanged: (value) {
            setState(() => isCalling = value);
          },
        );
        break;
      case 2:
        content = StatusScreenWidget(sidePanelWidth: newSidePanelWidth);
        break;
      case 3:
        content = MainScreenWidget(sidePanelWidth: newSidePanelWidth);
        break;
      case 4:
        content = MainScreenWidget(sidePanelWidth: newSidePanelWidth);
        break;
      default:
        content = SizedBox.shrink();
    }

    return isSmallScreen ? Expanded(child: content) : content;
  }
}
