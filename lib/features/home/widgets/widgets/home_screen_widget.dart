import 'package:chatify/features/home/widgets/panels/side_panel_widget.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/chat_list_type.dart';
import '../../../../core/enums/selection_type.dart';
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
import '../../../calls/screens/add_favorite_screen.dart';
import '../../../calls/screens/calls_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/screens/communities_screen.dart';
import '../../../group/models/group_model.dart';
import '../../../personalization/controllers/seasons_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/dialogs/new_list_bottom_dialog.dart';
import '../../../status/screens/status_screen.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../../newsletter/models/newsletter_model.dart';
import '../../controllers/chat_lists_controller.dart';
import '../../models/list_item_data.dart';
import '../../screens/home_select_user_screen.dart';
import '../dialogs/contexts/edit_tab_context_menu.dart';
import '../lists/main_home_content_list.dart';
import '../navs/side_nav_bar.dart';
import '../sections/archive_privacy_section.dart';
import '../sections/chat_info_section.dart';
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
  final Set<String> selectedChats;
  final Set<String> selectedNewsletterIds;
  final Set<String> selectedCommunityIds;
  final SelectionType selectionType;
  final Function(int) onPageChanged;
  final Function(int) onItemTapped;
  final Function(GroupModel) onGroupSelected;
  final Function(UserModel) onUserSelected;
  final ValueChanged<Set<String>>? onPinnedChatsChanged;
  final ValueChanged<Set<String>>? onMutedChatsChanged;
  final ValueChanged<NewsletterModel> onNewsletterSelected;
  final ValueChanged<CommunityModel> onCommunitySelected;

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
    required this.selectedChats,
    required this.selectedNewsletterIds,
    required this.selectedCommunityIds,
    required this.selectionType,
    required this.onPageChanged,
    required this.onItemTapped,
    required this.onGroupSelected,
    required this.onUserSelected,
    required this.onNewsletterSelected,
    required this.onCommunitySelected,
    this.onPinnedChatsChanged,
    this.onMutedChatsChanged,
  });

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> with TickerProviderStateMixin {
  final ChatListsController listsController = ChatListsController.instance;
  final ScrollController _scrollController = ScrollController();
  final GetStorage storage = GetStorage();
  final dialogManager = DialogManager();
  late TabController _tabController;
  double sidePanelWidth = 350.0;
  double minSidePanelWidth = 350.0;
  double maxSidePanelWidth = 700.0;
  bool isClicked = false;
  bool isHovered = false;
  bool isMenuExpanded = false;
  bool isCalling = false;
  bool showTabBar = true;
  bool showPasskeyCard = true;

  static const String _accessKeyHiddenUntilKey = 'access_key_hidden_until';

  String capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() + text.substring(1);
  }

  String getTabTitle(ChatListType type) {
    switch (type) {
      case ChatListType.all:
        return S.of(context).all;
      case ChatListType.unread:
        return S.of(context).unread;
      case ChatListType.favorite:
        return S.of(context).favorite;
      case ChatListType.groups:
        return capitalize(S.of(context).groups);
      case ChatListType.custom:
        return '';
      case ChatListType.archived:
        return 'Архив';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      double screenWidth = MediaQuery.of(context).size.width;
      await Future.delayed(Duration(milliseconds: 300));
      adjustSidePanelSize(screenWidth);
      await _checkAndShowDialog();
    });
    _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: listsController.lists.length + 2, vsync: this);
    _tabController.index = 0;
    _tabController.addListener(_onTabChanged);
    _loadAccessKeyVisibility();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _loadAccessKeyVisibility() {
    final hiddenUntil = storage.read<int>(_accessKeyHiddenUntilKey);

    if (hiddenUntil == null) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      showPasskeyCard = now >= hiddenUntil;
    });
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
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && showTabBar) {
      setState(() {
        showTabBar = false;
      });
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !showTabBar) {
      setState(() {
        showTabBar = true;
      });
    }
  }

  Future<void> _checkAndShowDialog() async {
    final now = DateTime.now();
    final lastShownStr = GetStorage().read<String>('last_confirmation_dialog_shown');
    final shouldNotShowAgain = GetStorage().read<bool>('should_not_show_rating_dialog') ?? false;

    if (shouldNotShowAgain) return;

    if (lastShownStr != null) {
      final lastShown = DateTime.tryParse(lastShownStr);

      if (lastShown != null && now.difference(lastShown).inDays < 30) return;
    }

    dialogManager.showMonthlyRatingDialog(context);

    GetStorage().write('last_confirmation_dialog_shown', now.toIso8601String());
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
                                      Expanded(
                                        child: NestedScrollView(
                                          controller: _scrollController,
                                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                                            return [
                                              SliverToBoxAdapter(child: SizedBox(height: 6)),
                                              SliverToBoxAdapter(child: _buildAccessKey()),
                                              SliverToBoxAdapter(child: _buildCategoryMessages()),
                                            ];
                                          },
                                          body: Obx(() => TabBarView(
                                            controller: _tabController,
                                            physics: const NeverScrollableScrollPhysics(),
                                            children: [
                                              ScrollConfiguration(
                                                behavior: NoGlowScrollBehavior(),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      if (!showTabBar && showPasskeyCard)
                                                        const SizedBox(height: 6),
                                                      MainHomeContentList(
                                                        groups: widget.groups,
                                                        newsletters: widget.newsletters,
                                                        communities: widget.communities,
                                                        users: widget.users,
                                                        supports: widget.supports,
                                                        infosApp: widget.infosApp,
                                                        isSearching: widget.isSearching,
                                                        isTabsVisible: showTabBar,
                                                        isAccessKeyVisible: showPasskeyCard,
                                                        searchList: widget.searchList,
                                                        onUserSelected: widget.onUserSelected,
                                                        selectedUserIds: widget.selectedChats,
                                                        onPinnedChatsChanged: widget.onPinnedChatsChanged,
                                                        onMutedChatsChanged: widget.onMutedChatsChanged,
                                                        isSelectionMode: widget.selectionType != SelectionType.none,
                                                        selectedNewsletterIds: widget.selectedNewsletterIds,
                                                        onNewsletterSelected: widget.onNewsletterSelected,
                                                        selectionType: widget.selectionType,
                                                        selectedCommunityIds: widget.selectedCommunityIds,
                                                        onCommunitySelected: widget.onCommunitySelected,
                                                      ),
                                                      StreamBuilder<int>(
                                                        stream: APIs.getArchivedUsersCount(widget.user.id),
                                                        builder: (context, snapshot) {
                                                          final count = snapshot.data ?? 0;

                                                          if (count == 0) {
                                                            return const SizedBox.shrink();
                                                          }

                                                          return ArchivePrivacySection(user: widget.user);
                                                        },
                                                      ),
                                                      ChatInfoSection(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              for (final item in listsController.lists)
                                                _buildListContent(item),
                                              Container(),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  StatusScreen(user: userController.currentUser),
                                  CommunitiesScreen(user: userController.currentUser),
                                  CallsScreen(user: userController.currentUser),
                                ],
                              ),
                            ),
                            StatusScreen(user: userController.currentUser),
                            CommunitiesScreen(user: userController.currentUser),
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
                      selectedUserIds: widget.selectedChats,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListContent(ListItemData item) {
    switch (item.type) {
      case ChatListType.unread:
        return _buildUnreadContent();
      case ChatListType.favorite:
        return _buildFavoriteContent();
      case ChatListType.groups:
        return _buildGroupsContent();
      case ChatListType.custom:
      case ChatListType.all:
        return const SizedBox.shrink();
      case ChatListType.archived:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUnreadContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ChatifyVectors.circleCheck, width: 70, height: 70),
            SizedBox(height: 25),
            Text(S.of(context).noUnreadChats, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
            SizedBox(height: 20),
            Text('На этом пока всё.', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm)),
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
    );
  }

  Widget _buildFavoriteContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(ChatifyVectors.addFavorite, width: 120, height: 120),
          const SizedBox(height: 15),
          Text(S.of(context).topUpYourFavorites, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(S.of(context).viewFavoritesChatsAndCalls, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 25),
          PressableText(
            text: S.of(context).addUsersOrGroups,
            style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w400),
            onTap: () {
              Navigator.push(context, createPageRoute(AddFavoriteScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(ChatifyVectors.createGroup, width: 200, height: 200),
          const SizedBox(height: 5),
          Text('Создайте группу', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text('Достигайте целей вместе с людьми из вашего окружения.', style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w400, height: 1.2), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 25),
          PressableText(
            text: 'Создайте группу',
            style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w400),
            onTap: () {
              Navigator.push(context, createPageRoute(HomeSelectUserScreen(isFavoritesMode: true)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryMessages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerColor: ChatifyColors.transparent,
            indicatorColor: ChatifyColors.transparent,
            labelColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            splashBorderRadius: BorderRadius.circular(30),
            unselectedLabelColor: ChatifyColors.grey,
            tabAlignment: TabAlignment.start,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
            tabs: [
              _buildCustomTab(0),

              for (int index = 0; index < listsController.lists.length; index++)
                _buildCustomTab(index + 1),

              _buildCustomTab(listsController.lists.length + 1),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildCustomTab(int index) {
    final lists = listsController.lists;

    if (index == 0) {
      return _buildTab(text: getTabTitle(ChatListType.all), index: index, isAddTab: false, isFavorite: false, canEdit: false);
    }

    final listIndex = index - 1;

    if (listIndex == lists.length) {
      return _buildTab(text: '', index: index, isAddTab: true, isFavorite: false, canEdit: false);
    }

    final item = lists[listIndex];

    return _buildTab(text: item.type == ChatListType.custom ? item.title : getTabTitle(item.type), index: index, isAddTab: false, isFavorite: item.type == ChatListType.favorite, canEdit: true);
  }

  Widget _buildTab({required String text, required int index, required bool isAddTab, required bool isFavorite, required bool canEdit}) {
    final isSelected = _tabController.index == index;
    final primaryColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: primaryColor.withAlpha((0.1 * 255).toInt()),
          highlightColor: primaryColor.withAlpha((0.2 * 255).toInt()),
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            if (isAddTab) {
              showNewListBottomSheetDialog(context);
            } else {
              _tabController.index = index;
            }
          },
          onLongPress: () {
            if (!canEdit) {
              return;
            }

            showEditTabContextMenu(context, index - 1, text, listsController, isFavorite: isFavorite);
          },
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: isSelected ? primaryColor.withAlpha((0.1 * 255).toInt(),) : (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey), width: 1,),
            ),
            child: Center(
              child: isAddTab
                ? Icon(Icons.add, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 20)
                : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: isSelected ? context.isDarkMode ? ChatifyColors.white : ChatifyColors.black : ChatifyColors.darkGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessKey() {
    if (!showPasskeyCard) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: ChatifyColors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey, width: 1),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Не рискуйте потерять доступ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Убедитесь, что вы сможете выполнять вход ''на случай, если будут проблемы с SMS.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.4, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: ChatifyColors.black,
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      side: BorderSide.none,
                      elevation: 2,
                      shadowColor: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
                    ).copyWith(
                      mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                    ),
                    child: Text(S.of(context).createAccessKey, style: TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -11,
            right: -11,
            child: GestureDetector(
              onTap: () {
                final hiddenUntil = DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;

                storage.write(_accessKeyHiddenUntilKey, hiddenUntil);

                setState(() {
                  showPasskeyCard = false;
                });
              },
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Icon(Icons.close, size: 24, color: context.isDarkMode ? ChatifyColors.textSecondary : ChatifyColors.darkGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
