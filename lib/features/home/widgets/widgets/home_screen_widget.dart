import 'package:chatify/features/home/widgets/panels/side_panel_widget.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/services/dialogs/dialog_manager.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/theme/seasons/effects/leaf_effect.dart';
import '../../../../utils/theme/seasons/effects/rain_effect.dart';
import '../../../../utils/theme/seasons/effects/snow_effect.dart';
import '../../../bot/models/info_app_model.dart';
import '../../../bot/models/support_model.dart';
import '../../../calls/screens/calls_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/screens/community_screen.dart';
import '../../../group/models/group_model.dart';
import '../../../personalization/controllers/seasons_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/screens/favorite/add_favorite_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/dialogs/new_list_bottom_dialog.dart';
import '../../../status/screens/status_screen.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../../newsletter/models/newsletter_model.dart';
import '../dialogs/contexts/edit_tab_context_menu.dart';
import '../lists/main_home_content_list.dart';
import '../navs/side_nav_bar.dart';
import '../sections/archive_privacy_section.dart';
import '../texts/pressable_text.dart';

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
  final List<InfoAppModel> infosApp;
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
    required this.infosApp,
    required this.onPageChanged,
    required this.onItemTapped,
    required this.onGroupSelected,
    required this.onUserSelected,
  });

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> with SingleTickerProviderStateMixin {
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
  late TabController _tabController;

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;
      adjustSidePanelSize(screenWidth);
      dialogManager.showMonthlyRatingDialog(context);
    });
    _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 0;
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  void toggleMenu() {
    setState(() {
      isMenuExpanded = !isMenuExpanded;
    });
  }

  void adjustSidePanelSize(double screenWidth) {
    if (screenWidth < 600) {
      setState(() {
        sidePanelWidth = 250.0;
        minSidePanelWidth = 250.0;
        maxSidePanelWidth = screenWidth * 0.4;
      });
    } else if (screenWidth < 750) {
      setState(() {
        sidePanelWidth = screenWidth * 0.25;
        minSidePanelWidth = 270.0;
        maxSidePanelWidth = screenWidth * 0.35;
      });
    } else if (screenWidth < 1200) {
      setState(() {
        sidePanelWidth = screenWidth * 0.35;
        minSidePanelWidth = 270.0;
        maxSidePanelWidth = screenWidth * 0.45;
      });
    } else {
      setState(() {
        sidePanelWidth = screenWidth * 0.2;
        minSidePanelWidth = 270.0;
        maxSidePanelWidth = screenWidth * 0.3;
      });
    }
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
    adjustSidePanelSize(screenWidth);

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
                          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                          child: IndexedStack(
                            index: widget.selectedIndex,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildCategoryMessages(),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _tabController,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            MainHomeContentList(
                                              groups: widget.groups,
                                              newsletters: widget.newsletters,
                                              communities: widget.communities,
                                              users: widget.users,
                                              supports: widget.supports,
                                              infosApp: widget.infosApp,
                                              isSearching: widget.isSearching,
                                              searchList: widget.searchList,
                                              onUserSelected: widget.onUserSelected,
                                            ),
                                            ArchivePrivacySection(),
                                          ],
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(S.of(context).noUnreadChats, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm)),
                                              SizedBox(height: 20),
                                              PressableText(
                                                text: S.of(context).viewAllChats,
                                                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w400),
                                                onTap: () {
                                                  _tabController.animateTo(0);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(ChatifyVectors.addFavorite, width: 100, height: 100),
                                              const SizedBox(height: 20),
                                              Text(S.of(context).topUpYourFavorites, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                                child: Text(S.of(context).viewFavoritesChatsAndCalls, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                              ),
                                              const SizedBox(height: 10),
                                              PressableText(
                                                text: S.of(context).addUsersOrGroups,
                                                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w400),
                                                onTap: () {
                                                  Navigator.push(context, createPageRoute(const AddFavoriteScreen()));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(child: Text(capitalize(S.of(context).groups))),
                                        Container(),
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
                    infosApp: widget.infosApp,
                    isSearching: widget.isSearching,
                    searchList: widget.searchList,
                    selectedIndex: widget.selectedIndex,
                    user: widget.user,
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerColor: ChatifyColors.transparent,
            indicatorColor: ChatifyColors.transparent,
            labelColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            splashBorderRadius: BorderRadius.circular(30),
            unselectedLabelColor: ChatifyColors.grey,
            tabAlignment: TabAlignment.center,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
            tabs: [
              _buildCustomTab(S.of(context).all, 0),
              _buildCustomTab(S.of(context).unread, 1),
              _buildCustomTab(S.of(context).favorite, 2),
              _buildCustomTab(capitalize(S.of(context).groups), 3),
              _buildCustomTab('+', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTab(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
      child: InkWell(
        onTap: () {
          if (index == 4) {
            showNewListBottomSheet(context);
          } else {
            _tabController.index = index;
          }
        },
        onLongPress: () {
          if (index != 4) {
            showEditTabContextMenu(context);
          }
        },
        splashColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
        highlightColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: _tabController.index == index ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _tabController.index == index ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Tab(
            child: _tabController.index == index && index == 4
                ? Icon(
              Icons.add,
              color: _tabController.index == index ? context.isDarkMode ? ChatifyColors.white : ChatifyColors.black : ChatifyColors.steelGrey,
              size: 20,
            )
                : Text(
              text,
              style: TextStyle(
                fontSize: index == 4 ? ChatifySizes.fontSizeMg : ChatifySizes.fontSizeSm,
                fontWeight: FontWeight.w400,
                color: _tabController.index == index ? context.isDarkMode ? ChatifyColors.white : ChatifyColors.black : ChatifyColors.darkGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
