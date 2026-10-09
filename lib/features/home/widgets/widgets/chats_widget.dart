import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/enums/chat_list_type.dart';
import '../../../../core/enums/tooltip_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../bot/models/info_app_model.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/widgets/lists/community_list.dart';
import '../../../group/models/group_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../personalization/widgets/dialogs/new_list_bottom_dialog.dart';
import '../../../personalization/widgets/lists/group_list.dart';
import '../../../newsletter/models/newsletter_model.dart';
import '../../controllers/chat_lists_controller.dart';
import '../dialogs/contexts/edit_tab_context_menu.dart';
import '../dialogs/filter_chats_dialog.dart';
import '../dialogs/new_chat_dialog.dart';
import '../inputs/search_text_input.dart';
import '../lists/infos_app_list.dart';
import '../lists/newsletter_list.dart';
import '../lists/support_list.dart';
import '../lists/user_list.dart';

class ChatsWidget extends StatefulWidget {
  final UserModel user;
  final List<GroupModel> groups;
  final List<NewsletterModel> newsletters;
  final List<CommunityModel> communities;
  final List<UserModel> users;
  final bool isSearching;
  final List<UserModel> searchList;
  final List<SupportAppModel> supports;
  final List<InfoAppModel> infosApp;
  final ValueChanged<NewsletterModel> onNewsletterSelected;
  final ValueChanged<CommunityModel> onCommunitySelected;
  final UserModel? selectedUser;
  final Set<String> selectedUserIds;
  final Set<String> pinnedChats;
  final Set<String> mutedChats;
  final CommunityModel? selectedCommunity;
  final Function(UserModel) onUserSelected;
  final Function(SupportAppModel) onSupportSelected;
  final Function(InfoAppModel) onInfoAppSelected;
  final Function(GroupModel) onGroupSelected;

  const ChatsWidget({
    super.key,
    required this.user,
    required this.groups,
    required this.newsletters,
    required this.communities,
    required this.users,
    required this.isSearching,
    required this.searchList,
    required this.supports,
    required this.infosApp,
    required this.onGroupSelected,
    required this.onNewsletterSelected,
    required this.onCommunitySelected,
    required this.selectedUserIds,
    required this.pinnedChats,
    required this.mutedChats,
    required this.onUserSelected,
    required this.onSupportSelected,
    required this.onInfoAppSelected,
    required this.selectedUser,
    this.selectedCommunity,
  });

  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> with TickerProviderStateMixin {
  final ChatListsController listsController = ChatListsController.instance;
  final TextEditingController chatsController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _newChatIconKey = GlobalKey();
  final GlobalKey _newFilterChatsIconKey = GlobalKey();
  late TabController _tabController;
  late String selectedFilterTitle;
  bool _isNewChatDialogOpen = false;
  bool _isFilterDialogOpen = false;
  String selectedFilter = '';
  GroupModel? selectedGroup;
  NewsletterModel? selectedNewsletter;
  CommunityModel? selectedCommunity;
  UserModel? selectedUser;
  SupportAppModel? selectedSupport;
  InfoAppModel? selectedInfoApp;

  String _getHintTextForSelectedFilter() {
    if (selectedFilterTitle == S.of(context).unread) {
      return S.of(context).searchUnreadChats;
    } else if (selectedFilterTitle == S.of(context).favorite) {
      return S.of(context).searchFavoriteChats;
    } else if (selectedFilterTitle == S.of(context).contacts) {
      return S.of(context).search;
    } else if (selectedFilterTitle == S.of(context).areNotContacts) {
      return S.of(context).search;
    } else if (selectedFilterTitle == '${S.of(context).groups[0].toUpperCase()}${S.of(context).groups.substring(1)}') {
      return S.of(context).searchGroupsChats;
    } else if (selectedFilterTitle == S.of(context).drafts) {
      return S.of(context).search;
    } else {
      return S.of(context).searchNewChat;
    }
  }

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
    selectedCommunity = widget.selectedCommunity;
    selectedUser = widget.selectedUser;
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
    _tabController = TabController(length: listsController.lists.length + 2, vsync: this);
    _tabController.index = 0;
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedFilterTitle = S.of(context).chats;
  }

  @override
  void dispose() {
    chatsController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final currentUser = userController.currentUser;
    final filteredGroups = widget.groups.where((group) => group.creatorName == currentUser.id).toList();
    final filteredNewsletters = widget.newsletters.where((newsletter) => newsletter.creatorName == currentUser.id).toList();
    final filteredCommunities = widget.communities.where((community) => community.creatorName == currentUser.id).toList();
    final filteredUsers = widget.users.where((user) => user.id == currentUser.id).toList();
    final filteredSupports = widget.supports.where((support) => support.id == currentUser.id).toList();
    final hoverBackgroundColor = context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
              child: Row(
                children: [
                  if (selectedFilterTitle != S.of(context).chats)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilterTitle = S.of(context).chats;
                        });
                      },
                      child: Icon(Icons.arrow_back, size: 18),
                    ),
                  if (selectedFilterTitle != S.of(context).chats)
                    SizedBox(width: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final offsetAnimation = Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

                      return SlideTransition(position: offsetAnimation, child: FadeTransition(opacity: animation, child: child));
                    },
                    child: Text(selectedFilterTitle, key: ValueKey<String>(selectedFilterTitle), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ),
                ],
              ),
            ),
            if (selectedFilterTitle == S.of(context).chats)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 12, top: 16, bottom: 8),
              child: Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      tooltipTheme: TooltipThemeData(
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()), spreadRadius: 1, blurRadius: 8, offset: Offset(0, 4))],
                        ),
                        textStyle: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                      ),
                    ),
                    child: CustomTooltip(
                      message: S.of(context).newChatNewGroup,
                      verticalOffset: -40,
                      horizontalOffset: -85,
                      position: TooltipPositionType.bottom,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          key: _newChatIconKey,
                          mouseCursor: SystemMouseCursors.basic,
                          splashFactory: NoSplash.splashFactory,
                          borderRadius: BorderRadius.circular(8),
                          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                          onTap: () async {
                            final RenderBox renderBox = _newChatIconKey.currentContext?.findRenderObject() as RenderBox;
                            final position = renderBox.localToGlobal(Offset.zero);

                            setState(() => _isNewChatDialogOpen = true);

                            await showNewChatDialog(context, position, widget.user);

                            setState(() => _isNewChatDialogOpen = false);
                          },
                          child: Container(
                            decoration: BoxDecoration(color: _isNewChatDialogOpen ? hoverBackgroundColor : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
                            child: Padding(padding: EdgeInsets.all(12), child: SvgPicture.asset(ChatifyVectors.chatsAdd, width: 22, height: 22, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  CustomTooltip(
                    message: S.of(context).chatFilter,
                    horizontalOffset: -45,
                    verticalOffset: -40,
                    position: TooltipPositionType.bottom,
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        key: _newFilterChatsIconKey,
                        mouseCursor: SystemMouseCursors.basic,
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(8.0),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                        onTap: () async {
                          final RenderBox renderBox = _newFilterChatsIconKey.currentContext?.findRenderObject() as RenderBox;
                          final position = renderBox.localToGlobal(Offset.zero);

                          setState(() => _isFilterDialogOpen = true);

                          await showFilterChatsDialog(
                            context: context,
                            position: position,
                            onFilterSelected: (String selected) {
                              setState(() {
                                selectedFilterTitle = selected;
                              });
                            },
                          );

                          setState(() => _isFilterDialogOpen = false);
                        },
                        child: Container(
                          decoration: BoxDecoration(color: _isFilterDialogOpen ? hoverBackgroundColor : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(ChatifyVectors.filter, width: 16, height: 16, colorFilter: ColorFilter.mode( context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SearchTextInput(
          hintText: _getHintTextForSelectedFilter(),
          controller: chatsController,
          focusNode: _focusNode,
          wrapInScrollView: false,
          padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 8),
          prefixIconConstraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        ),
        SizedBox(height: 5),
        _buildCategoryMessages(),
        SizedBox(height: 15),
        Expanded(
          child: ScrollbarTheme(
            data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
            child: Padding(
              padding: const EdgeInsets.only(right: 1),
              child: Scrollbar(
                thickness: 4,
                thumbVisibility: false,
                controller: _scrollController,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Visibility(
                        visible: widget.groups.isNotEmpty,
                        replacement: const SizedBox.shrink(),
                        child: Obx(() {
                          final userController = Get.find<UserController>();
                          final currentUserName = userController.currentUser.name;

                          return GroupList(
                            groups: widget.groups,
                            currentUser: currentUserName,
                            users: {},
                            onGroupSelected: (group) {
                              setState(() {
                                selectedGroup = group;
                                selectedNewsletter = null;
                                selectedCommunity = null;
                                selectedUser = null;
                                selectedSupport = null;
                              });
                              widget.onGroupSelected(group);
                            },
                          );
                        }),
                      ),
                      Visibility(
                        visible: widget.newsletters.isNotEmpty,
                        replacement: const SizedBox.shrink(),
                        child: NewsletterList(
                          newsletters: widget.newsletters,
                          onNewsletterSelected: (newsletter) {
                            setState(() {
                              selectedNewsletter = newsletter;
                              selectedGroup = null;
                              selectedCommunity = null;
                              selectedUser = null;
                              selectedSupport = null;
                            });
                            widget.onNewsletterSelected(newsletter);
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.communities.isNotEmpty,
                        replacement: const SizedBox.shrink(),
                        child: CommunityList(
                          communities: widget.communities,
                          isHomeScreen: true,
                          onCommunitySelected: (community) {
                            setState(() {
                              selectedCommunity = community;
                              selectedGroup = null;
                              selectedNewsletter = null;
                              selectedUser = null;
                              selectedSupport = null;
                            });
                            widget.onCommunitySelected(community);
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.users.isNotEmpty,
                        replacement: const SizedBox.shrink(),
                        child: UserList(
                          isSearching: widget.isSearching,
                          searchList: widget.searchList,
                          list: widget.users,
                          isSharing: false,
                          selectedUserIds: widget.selectedUserIds,
                          pinnedChats: widget.pinnedChats,
                          mutedChats: widget.mutedChats,
                          onUserSelected: (user) {
                            setState(() {
                              selectedUser = user;
                              selectedGroup = null;
                              selectedNewsletter = null;
                              selectedCommunity = null;
                              selectedSupport = null;
                            });
                            widget.onUserSelected(user);
                          },
                          onSelectionModeChanged: (bool selecting) {},
                        ),
                      ),
                      Visibility(
                        visible: widget.supports.isNotEmpty,
                        child: SupportList(
                          supports: widget.supports,
                          selectedSupport: selectedSupport,
                          onSupportSelected: (support) {
                            setState(() {
                              selectedSupport = support;
                              selectedGroup = null;
                              selectedCommunity = null;
                              selectedNewsletter = null;
                              selectedUser = null;
                            });
                            widget.onSupportSelected(support);
                          },
                        ),
                      ),
                      if (widget.infosApp.isNotEmpty && widget.supports.isNotEmpty)
                        InfosAppList(
                          infosApp: widget.infosApp,
                          support: widget.supports.first,
                          selectedInfoApp: selectedInfoApp,
                          onInfoAppSelected: (infoApp) {
                            setState(() {
                              selectedInfoApp = infoApp;
                              selectedGroup = null;
                              selectedCommunity = null;
                              selectedNewsletter = null;
                              selectedUser = null;
                            });
                            widget.onInfoAppSelected(infoApp);
                          },
                        ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryMessages() {
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          overlayColor: WidgetStateProperty.all(ChatifyColors.transparent),
          tabs: [
            _buildCustomTab(0),
            for (int index = 0; index < listsController.lists.length; index++)
              _buildCustomTab(index + 1),
            _buildCustomTab(listsController.lists.length + 1),
          ],
        )),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(30),
          mouseCursor: SystemMouseCursors.basic,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
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
}
