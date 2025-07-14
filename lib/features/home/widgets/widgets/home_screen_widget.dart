import 'dart:developer';
import 'package:chatify/features/home/widgets/panels/side_panel_widget.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../../../core/services/dialogs/dialog_manager.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/theme/seasons/effects/leaf_effect.dart';
import '../../../../utils/theme/seasons/effects/rain_effect.dart';
import '../../../../utils/theme/seasons/effects/snow_effect.dart';
import '../../../bot/models/support_model.dart';
import '../../../calls/screens/calls_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/screens/community_screen.dart';
import '../../../community/widgets/lists/community_list.dart';
import '../../../group/models/group_model.dart';
import '../../../personalization/controllers/seasons_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/lists/group_list.dart';
import '../../../status/screens/status_screen.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../../newsletter/models/newsletter.dart';
import '../../screens/archive_screen.dart';
import '../dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../lists/newsletter_list.dart';
import '../lists/support_list.dart';
import '../lists/user_list.dart';
import '../navs/side_nav_bar.dart';

class HomeScreenWidget extends StatefulWidget {
  final int selectedIndex;
  final PageController pageController;
  final bool isHomeScreen;
  final bool isSearching;
  final UserModel user;
  final List<GroupModel> groups;
  final List<UserModel> users;
  final List<NewsletterModel> newsletters;
  final List<CommunityModel> communities;
  final List<UserModel> searchList;
  final List<SupportAppModel> supports;
  final Function(int) onPageChanged;
  final Function(int) onItemTapped;
  final Function(GroupModel) onGroupSelected;
  final Function(UserModel) onUserSelected;

  const HomeScreenWidget({
    super.key,
    required this.selectedIndex,
    required this.pageController,
    required this.isHomeScreen,
    required this.isSearching,
    required this.user,
    required this.groups,
    required this.users,
    required this.newsletters,
    required this.communities,
    required this.searchList,
    required this.supports,
    required this.onPageChanged,
    required this.onItemTapped,
    required this.onGroupSelected,
    required this.onUserSelected,
  });

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  double sidePanelWidth = 350.0;
  double minSidePanelWidth = 350.0;
  double maxSidePanelWidth = 700.0;
  bool isClicked = false;
  bool isHovered = false;
  bool isMenuExpanded = false;
  bool _showTabBar = true;
  bool isCalling = false;
  final ScrollController _scrollController = ScrollController();
  final dialogManager = DialogManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;
      log("Before adjusting sidePanelWidth, screen width: $screenWidth");
      adjustSidePanelSize(screenWidth);
      dialogManager.showMonthlyRatingDialog(context);
      log("After adjusting sidePanelWidth, sidePanelWidth: $sidePanelWidth");
    });
    _scrollController.addListener(_handleScroll);
  }

  void toggleMenu() {
    setState(() {
      isMenuExpanded = !isMenuExpanded;
    });
  }

  void adjustSidePanelSize(double screenWidth) {
    log("Before adjusting sidePanelWidth, screen width: $screenWidth");

    if (screenWidth < 600) {
      setState(() {
        sidePanelWidth = 250.0;
        minSidePanelWidth = 250.0;
        maxSidePanelWidth = screenWidth * 0.4;
        log("Updated sidePanelWidth: $sidePanelWidth, maxSidePanelWidth: $maxSidePanelWidth");
      });
    } else if (screenWidth < 750) {
      setState(() {
        log("Setting sidePanelWidth to: ${screenWidth * 0.25}");
        sidePanelWidth = screenWidth * 0.25;
        minSidePanelWidth = 270.0;
        maxSidePanelWidth = screenWidth * 0.35;
        log("Updated sidePanelWidth: $sidePanelWidth, maxSidePanelWidth: $maxSidePanelWidth");
      });
    } else if (screenWidth < 1200) {
      setState(() {
        sidePanelWidth = screenWidth * 0.35;
        minSidePanelWidth = 270.0;
        maxSidePanelWidth = screenWidth * 0.45;
        log("Updated sidePanelWidth: $sidePanelWidth, maxSidePanelWidth: $maxSidePanelWidth");
      });
    } else {
      setState(() {
        sidePanelWidth = screenWidth * 0.2;
        minSidePanelWidth = 270.0;
        maxSidePanelWidth = screenWidth * 0.3;
        log("Updated sidePanelWidth: $sidePanelWidth, maxSidePanelWidth: $maxSidePanelWidth");
      });
    }

    log("After adjusting sidePanelWidth, sidePanelWidth: $sidePanelWidth");
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _showTabBar) {
      setState(() {
        _showTabBar = false;
      });
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_showTabBar) {
      setState(() {
        _showTabBar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    double screenWidth = MediaQuery.of(context).size.width;
    log("Before adjusting sidePanelWidth, screen width: $screenWidth");
    adjustSidePanelSize(screenWidth);
    log("After adjusting sidePanelWidth, sidePanelWidth: $sidePanelWidth");

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            if (defaultTargetPlatform == TargetPlatform.windows)
            SideNavBar(
              selectedIndex: widget.selectedIndex,
              onItemTapped: widget.onItemTapped,
              isMenuExpanded: isMenuExpanded,
              toggleMenu: toggleMenu,
              user: widget.user,
              isCalling: isCalling,
            ),
            Expanded(
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child:  defaultTargetPlatform == TargetPlatform.windows
                      ? const SizedBox.shrink()
                      : PageView(
                      controller: widget.pageController,
                      onPageChanged: widget.onPageChanged,
                      children: <Widget>[
                        ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                              if (states.contains(WidgetState.dragged)) {
                                return ChatifyColors.darkerGrey;
                              }
                              return ChatifyColors.darkerGrey;
                            }),
                          ),
                          child: Scrollbar(
                            thickness: 4,
                            thumbVisibility: false,
                            child: IndexedStack(
                              index: widget.selectedIndex,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _buildCategoryMessages(),
                                    if (widget.groups.isEmpty) const SizedBox(height: 6),
                                    Visibility(
                                      visible: widget.groups.isNotEmpty,
                                      replacement: const SizedBox.shrink(),
                                      child: Obx(() {
                                        final userController = Get.find<UserController>();
                                        final currentUserName = userController.currentUser.name;
                                        return GroupList(groups: widget.groups, currentUser: currentUserName, onGroupSelected: (group) {});
                                      }),
                                    ),
                                    Visibility(
                                      visible: widget.newsletters.isNotEmpty,
                                      replacement: const SizedBox.shrink(),
                                      child: NewsletterList(newsletters: widget.newsletters, onNewsletterSelected: (newsletter) {}),
                                    ),
                                    Visibility(
                                      visible: widget.communities.isNotEmpty,
                                      replacement: const SizedBox.shrink(),
                                      child: CommunityList(communities: widget.communities, isHomeScreen: true, onCommunitySelected: (community) {}),
                                    ),
                                    Visibility(
                                      visible: widget.users.isEmpty,
                                      replacement: const SizedBox.shrink(),
                                      child: UserList(
                                        isSearching: widget.isSearching,
                                        searchList: widget.searchList,
                                        list: widget.users,
                                        isSharing: false,
                                        onUserSelected: widget.onUserSelected,
                                        onSelectionModeChanged: (bool selecting) {},
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.supports.isEmpty,
                                      child: SupportList(supports: widget.supports, onSupportSelected: (support) {}),
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(context, createPageRoute(ArchiveScreen()));
                                            },
                                            splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                            highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 36, right: 22, top: 14, bottom: 14),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.archive_outlined,
                                                    size: 24,
                                                    color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                                                  ),
                                                  const SizedBox(width: 22),
                                                  Text(
                                                    'В архиве',
                                                    style: TextStyle(
                                                      fontSize: ChatifySizes.fontSizeMd,
                                                      color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text('3', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 12),
                                                              child: Icon(
                                                                Icons.lock_outline,
                                                                color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                                                                size: 14,
                                                              ),
                                                            ),
                                                            alignment: PlaceholderAlignment.middle,
                                                          ),
                                                          TextSpan(
                                                            text: S.of(context).yourPrivateMessagesProtected,
                                                            style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                                                          ),
                                                          TextSpan(
                                                            text: S.of(context).encryption,
                                                            style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.bold, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                                            recognizer: TapGestureRecognizer()..onTap = () {
                                                              showChatsCallsPrivacyBottomSheet(
                                                                context,
                                                                headerText: S.of(context).yourChatsCallsConfidential,
                                                                titleText: S.of(context).yourPrivateMessagesAndCalls,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                StatusScreen(user: userController.currentUser),
                                CommunityScreen(user: userController.currentUser),
                                CallsScreen(user: userController.currentUser),
                              ],
                            ),
                          ),
                        ),
                        StatusScreen(user: userController.currentUser),
                        CommunityScreen(user: userController.currentUser),
                        CallsScreen(user: userController.currentUser),
                      ],
                    ),
                  ),
                  Positioned(
                    top: widget.isHomeScreen ? 0 : 85,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Obx(() {
                      final showSnow = SeasonsController.instance.showSnow.value;
                      final showLeaf = SeasonsController.instance.showLeaf.value;
                      final showRaindrop = SeasonsController.instance.showRaindrop.value;

                      if (showSnow) {
                        return const SnowEffect();
                      } else if (showLeaf) {
                        return const LeafEffect();
                      } else if (showRaindrop) {
                        return const RaindropEffect();
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ),
                  if (defaultTargetPlatform == TargetPlatform.windows)
                  SidePanelWidget(
                    sidePanelWidth: sidePanelWidth,
                    minSidePanelWidth: minSidePanelWidth,
                    maxSidePanelWidth: maxSidePanelWidth,
                    onWidthChanged: (newWidth) {
                      setState(() {
                        double screenWidth = MediaQuery.of(context).size.width;

                        if (screenWidth < 600) {
                          sidePanelWidth = screenWidth;
                        } else {
                          sidePanelWidth = newWidth.clamp(minSidePanelWidth, maxSidePanelWidth);
                        }
                      });
                    },
                    isClicked: isClicked,
                    isHovered: isHovered,
                    groups: widget.groups,
                    newsletters: widget.newsletters,
                    communities: widget.communities,
                    users: widget.users,
                    supports: widget.supports,
                    isSearching: widget.isSearching,
                    searchList: widget.searchList,
                    selectedIndex: widget.selectedIndex,
                    user: userController.currentUser,

                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryMessages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DefaultTabController(
        length: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: 'Все'),
                Tab(text: 'Личные'),
                Tab(text: 'Группы'),
                Tab(text: 'Каналы'),
                Tab(text: 'Боты'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  Center(child: Text('Все сообщения')),
                  Center(child: Text('Личные чаты')),
                  Center(child: Text('Групповые чаты')),
                  Center(child: Text('Каналы')),
                  Center(child: Text('Боты')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
