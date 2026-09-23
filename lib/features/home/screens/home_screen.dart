import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/newsletter/models/newsletter_model.dart';
import 'package:chatify/features/status/widgets/images/camera_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../api/apis.dart';
import '../../../api/community_api.dart';
import '../../../api/group_api.dart';
import '../../../api/newsletter_api.dart';
import '../../../core/enums/chat_list_type.dart';
import '../../../core/enums/selection_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../bot/models/info_app_model.dart';
import '../../chat/models/user_model.dart';
import '../../community/models/community_model.dart';
import '../../group/models/group_model.dart';
import '../../personalization/controllers/user_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/bars/nav_bars/bottom_nav.dart';
import '../widgets/app_bars/home_app_bar_widget.dart';
import '../widgets/app_bars/selection_app_bar.dart';
import '../widgets/dialogs/delete_chat_dialog.dart';
import '../widgets/dialogs/no_sound_dialog.dart';
import '../widgets/items/home_item.dart';
import '../widgets/widgets/home_screen_widget.dart';
import 'home_select_user_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final List<UserModel> searchList = [];
  final Set<String> selectedChats = <String>{};
  final Set<String> pinnedChats = <String>{};
  final Set<String> mutedChats = <String>{};
  final UserController userController = Get.find<UserController>();
  final PageController _pageController = PageController();
  final Set<String> selectedNewsletterIds = {};
  final Set<String> selectedCommunityIds = {};
  final Set<String> selectedGroupIds = {};
  final Map<String, int> userLastMessageTimes = {};
  late bool isHomeScreen;
  bool isSearching = false;
  bool isToolbarVisible = true;
  bool isLoading = true;
  bool isRequestingPermissions = true;
  int selectedIndex = 0;
  int selectedChatsCount = 0;
  List<GroupModel> groups = [];
  List<CommunityModel> communities = [];
  List<NewsletterModel> newsletters = [];
  List<UserModel> users = [];
  List<SupportAppModel> supports = [];
  List<InfoAppModel> infosApp = [];
  List<HomeItem> homeItems = [];
  ChatListType chatListType = ChatListType.all;
  SelectionType selectionType = SelectionType.none;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _myUsersSubscription;

  bool get isSelecting => selectionType != SelectionType.none;
  bool get isEmpty => users.isEmpty && groups.isEmpty && communities.isEmpty;

  @override
  void initState() {
    super.initState();
    isHomeScreen = selectedIndex == 0;
    WidgetsBinding.instance.addObserver(this);
    APIs.getSelfInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_pageController.hasClients) {
        _pageController.animateToPage(selectedIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }

      await _initializePermissions();

      if (!mounted) return;

      setState(() {
        isRequestingPermissions = false;
      });
    });
    _loadUserInfo();
    _fetchGroups();
    _fetchCommunities();
    _fetchNewsletters();
    _fetchSupportChat();
    _fetchInfoChats();
    _listenToMyUsers();
  }

  @override
  void dispose() {
    _myUsersSubscription?.cancel();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool? newGroupCreated = ModalRoute.of(context)?.settings.arguments as bool?;

    if (newGroupCreated == true) {
      _fetchGroups();
    }
    _fetchCommunities();
    _fetchNewsletters();
    _fetchSupportChat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (APIs.auth.currentUser == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        APIs.updateActiveStatus(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        APIs.updateActiveStatus(false);
        break;
      case AppLifecycleState.hidden:
        APIs.updateActiveStatus(false);
        break;
    }
  }

  Future<void> _initializePermissions() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    await Permission.microphone.request();
    await Permission.contacts.request();
    await Permission.notification.request();
    await Permission.camera.request();
    await Permission.photos.request();
  }

  Future<void> _loadUserInfo() async {
    await APIs.getSelfInfo();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleArchiveSelectedChats() async {
    if (selectedChats.isEmpty) return;

    try {
      for (final userId in selectedChats) {
        await APIs.setChatArchived(userId: userId, archived: true);
      }

      clearSelection();
    } catch (e) {
      log('Error archiving chats: $e');
    }
  }

  Future<void> _handleUnarchiveSelectedChats() async {
    if (selectedChats.isEmpty) return;

    try {
      for (final userId in selectedChats) {
        await APIs.setChatArchived(userId: userId, archived: false);
      }

      clearSelection();
    } catch (e) {
      log('Error unarchiving chats: $e');
    }
  }

  Future<void> _handlePinSelectedChats() async {
    if (selectedChats.isEmpty) return;

    final bool allPinned = selectedChats.every((userId) => pinnedChats.contains(userId));

    try {
      for (final userId in selectedChats) {
        await APIs.setChatPinned(userId: userId, pinned: !allPinned);
      }

      clearSelection();
    } catch (e) {
      log('Error pinning chats: $e');
    }
  }

  void _fetchGroups() async {
    List<GroupModel> fetchedGroups = await GroupApi.getGroups();
    setState(() {
      groups = fetchedGroups;
      _rebuildHomeItems();
    });
  }

  void _fetchCommunities() async {
    List<CommunityModel> fetchedCommunities = await CommunityApi.getCommunity();
    setState(() {
      communities = fetchedCommunities;
      _rebuildHomeItems();
    });
  }

  void _fetchNewsletters() async {
    List<NewsletterModel> fetchedNewsletters = await NewsletterApi.getNewsletter();
    setState(() {
      newsletters = fetchedNewsletters;
      _rebuildHomeItems();
    });
  }

  void _fetchSupportChat() async {
    List<SupportAppModel> fetchedSupports = await APIs.getSupportChat();
    setState(() {
      supports = fetchedSupports;
      _rebuildHomeItems();
    });
  }

  Future<void> _fetchInfoChats() async {
    List<InfoAppModel> fetchInfoChats = await APIs.getInfoChat();
    setState(() {
      infosApp = fetchInfoChats;
      _rebuildHomeItems();
    });
  }

  void _listenToMyUsers() {
    _myUsersSubscription = APIs.getMyUsersId().listen((snapshot) {
      final userIds = snapshot.docs.map((doc) => doc.id).toList();
      userLastMessageTimes.clear();

      final newPinnedChats = <String>{};
      final newMutedChats = <String>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final lastMessageTime = int.tryParse(data['lastMessageTime']?.toString() ?? '') ?? 0;

        userLastMessageTimes[doc.id] = lastMessageTime;

        if (data['pinned'] == true) {
          newPinnedChats.add(doc.id);
        }

        if (data['muted'] == true) {
          newMutedChats.add(doc.id);
        }
      }

      if (userIds.isEmpty) {
        if (mounted) {
          setState(() {
            users = [];
            _rebuildHomeItems();
          });
        }
        return;
      }

      APIs.getAllUsers(userIds).listen((usersSnapshot) {
        final loadedUsers = usersSnapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

        if (!mounted) return;

        setState(() {
          users = loadedUsers;
          _rebuildHomeItems();
        });
      });
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (_pageController.hasClients) {
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void clearSelection() {
    log('clearSelection BEFORE: '
        'selectedGroupIds=$selectedGroupIds, '
        'selectionType=$selectionType');


    setState(() {
      selectedChats.clear();
      selectedNewsletterIds.clear();
      selectedCommunityIds.clear();
      selectedGroupIds.clear();
      selectionType = SelectionType.none;
    });
  }

  void _handleDeleteSelectedChats() {
    if (selectedChats.isEmpty) return;

    final selectedUsers = users.where((user) => selectedChats.contains(user.id)).toList();

    if (selectedUsers.isEmpty) return;

    final allFromCurrentUser = selectedUsers.every((user) => user.id == APIs.user.uid);

    if (allFromCurrentUser) {
      showDeleteChatDialog(context, selectedUsers, APIs.me);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).unableDeleteUsersChats)));
    }
  }

  void onChatSelection(UserModel user) {
    setState(() {
      if (selectionType == SelectionType.none) {
        selectionType = SelectionType.chats;
      }

      if (selectionType != SelectionType.chats) {
        return;
      }

      if (selectedChats.contains(user.id)) {
        selectedChats.remove(user.id);
      } else {
        selectedChats.add(user.id);
      }

      if (selectedChats.isEmpty) {
        selectionType = SelectionType.none;
      }
    });
  }

  void onNewsletterSelection(NewsletterModel newsletter) {
    setState(() {
      if (selectionType == SelectionType.none) {
        selectionType = SelectionType.newsletters;
      }

      if (selectionType != SelectionType.newsletters) {
        return;
      }

      if (selectedNewsletterIds.contains(newsletter.id)) {
        selectedNewsletterIds.remove(newsletter.id);
      } else {
        selectedNewsletterIds.add(newsletter.id);
      }

      if (selectedNewsletterIds.isEmpty) {
        selectionType = SelectionType.none;
      }
    });
  }

  void onCommunitySelection(CommunityModel community) {
    setState(() {
      if (selectionType == SelectionType.none) {
        selectionType = SelectionType.communities;
      }

      if (selectionType != SelectionType.communities) {
        return;
      }

      if (selectedCommunityIds.contains(community.id)) {
        selectedCommunityIds.remove(community.id);
      } else {
        selectedCommunityIds.add(community.id);
      }

      if (selectedCommunityIds.isEmpty) {
        selectionType = SelectionType.none;
      }
    });
  }

  void onGroupSelection(GroupModel group) {
    setState(() {
      if (selectionType == SelectionType.none) {
        selectionType = SelectionType.groups;
      }

      if (selectionType != SelectionType.groups) {
        return;
      }

      if (selectedGroupIds.contains(group.id)) {
        selectedGroupIds.remove(group.id);
      } else {
        selectedGroupIds.add(group.id);
      }

      if (selectedGroupIds.isEmpty) {
        selectionType = SelectionType.none;
      }
    });
  }

  void _rebuildHomeItems() {
    final items = <HomeItem>[];

    for (final user in users) {
      items.add(ChatHomeItem(user: user, activityTime: userLastMessageTimes[user.id] ?? 0));
    }

    for (final group in groups) {
      items.add(GroupHomeItem(group: group, activityTime: group.lastMessageTimestamp));
    }

    for (final community in communities) {
      items.add(CommunityHomeItem(community: community, activityTime: 0));
    }

    for (final newsletter in newsletters) {
      items.add(NewsletterHomeItem(newsletter: newsletter, activityTime: 0));
    }

    for (final support in supports) {
      items.add(SupportHomeItem(support: support, activityTime: 0));
    }

    for (final info in infosApp) {
      items.add(InfoAppHomeItem(info: info, activityTime: 0));
    }

    items.sort((a, b) => b.activityTime.compareTo(a.activityTime));

    homeItems = items;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMuted = selectedChats.isNotEmpty && selectedChats.every((id) => mutedChats.contains(id));
    isHomeScreen = selectedIndex == 0;

    return GestureDetector(
      onTap: () {
        if (isSearching) {
          setState(() {
            isSearching = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: isWebOrWindows ? context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()) : null,
        appBar: defaultTargetPlatform == TargetPlatform.windows
          ? null
          : selectionType == SelectionType.groups
            ? SelectionAppBar(
                selectedChatsCount: selectedGroupIds.length,
                onClearSelection: clearSelection,
                onDelete: () {},
                onPin: () {},
                onMute: () {},
                onArchive: () {},
                isNewsletterMode: false,
              )
          : selectionType == SelectionType.newsletters
            ? SelectionAppBar(
                selectedChatsCount: selectedNewsletterIds.length,
                onClearSelection: clearSelection,
                onDelete: () {},
                onMute: () {},
                onArchive: () {},
                isNewsletterMode: true,
              )
            : selectionType == SelectionType.communities
              ? SelectionAppBar(
                  selectedChatsCount: selectedCommunityIds.length,
                  onClearSelection: clearSelection,
                  onDelete: () {},
                  onMute: () {},
                  onArchive: () {},
                  isCommunityMode: true,
                )
            : selectionType == SelectionType.chats
              ? SelectionAppBar(
                  selectedChatsCount: selectedChats.length,
                  onClearSelection: clearSelection,
                  onDelete: _handleDeleteSelectedChats,
                  onPin: _handlePinSelectedChats,
                  isNewsletterMode: false,
                  onMute: () async {
                    if (selectedChats.isEmpty) return;

                    if (isMuted) {
                      try {
                        for (final userId in selectedChats) {
                          await APIs.setChatMuted(userId: userId, muted: false);
                        }

                        clearSelection();
                      } catch (e) {
                        log('Error unmuting chats: $e');
                      }

                      return;
                    }

                    final initialDuration = await APIs.getChatMutedDuration(selectedChats.first);

                    if (!context.mounted) return;

                    showNoSoundDialog(
                      context,
                      initialDuration,
                      (duration) async {
                        try {
                          for (final userId in selectedChats) {
                            await APIs.setChatMuted(userId: userId, muted: true, duration: duration);
                          }

                          clearSelection();
                        } catch (e) {
                          log('Error muting chats: $e');
                        }
                      },
                    );
                  },
                  onArchive: chatListType == ChatListType.archived ? _handleUnarchiveSelectedChats : _handleArchiveSelectedChats,
                  isPinned: selectedChats.isNotEmpty && selectedChats.every((id) => pinnedChats.contains(id)),
                  isMuted: selectedChats.isNotEmpty && selectedChats.every((id) => mutedChats.contains(id)),
                )
            : selectedIndex == 0
              ? HomeAppBarWidget(
                isSearching: isSearching,
                users: users,
                searchList: searchList,
                onSearch: (val) {
                  searchList.clear();
                  for (var i in users) {
                    if (i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())) {
                      searchList.add(i);
                    }
                  }
                  setState(() {
                    searchList;
                  });
                },
                onToggleSearch: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                onCameraPressed: () {
                  Navigator.push(context, createPageRoute(CameraScreen(chatTarget: widget.user)));
                },
                hintText: S.of(context).search,
              )
            : null,
        floatingActionButton: defaultTargetPlatform == TargetPlatform.windows
          ? null
          : selectedIndex == 0
            ? isEmpty
              ? FloatingActionButton.extended(
                  heroTag: 'home',
                  onPressed: () {
                    Navigator.push(context, createPageRoute(const HomeSelectUserScreen()));
                  },
                  elevation: 2,
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value,),
                  foregroundColor: ChatifyColors.white,
                  icon: SvgPicture.asset(ChatifyVectors.chatsAdd, width: 26, height: 26, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                  label: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Отправить сообщение', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.black, fontWeight: FontWeight.w400)),
                  ),
                )
              : FloatingActionButton(
                  heroTag: 'home',
                  onPressed: () {
                    Navigator.push(context, createPageRoute(const HomeSelectUserScreen()));
                  },
                  elevation: 2,
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  foregroundColor: ChatifyColors.white,
                  child: SvgPicture.asset(ChatifyVectors.chatsAdd, width: 26, height: 26, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                )
            : FloatingActionButton(
                heroTag: 'home',
                onPressed: () {
                  Navigator.push(context, createPageRoute(const HomeSelectUserScreen()));
                },
                elevation: 2,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                child: SvgPicture.asset(ChatifyVectors.chatsAdd, width: 26, height: 26, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
            ),
        body: HomeScreenWidget(
          selectedIndex: selectedIndex,
          pageController: _pageController,
          isHomeScreen: isHomeScreen,
          isSearching: isSearching,
          groups: groups,
          users: users,
          newsletters: newsletters,
          communities: communities,
          searchList: searchList,
          supports: supports,
          infosApp: infosApp,
          selectedChats: selectedChats,
          onPageChanged: _onPageChanged,
          onItemTapped: onItemTapped,
          onUserSelected: onChatSelection,
          onGroupSelected: onGroupSelection,
          onNewsletterSelected: onNewsletterSelection,
          onCommunitySelected: onCommunitySelection,
          user: widget.user,
          selectionType: selectionType,
          selectedNewsletterIds: selectedNewsletterIds,
          selectedCommunityIds: selectedCommunityIds,
          selectedGroupIds: selectedGroupIds,
          pinnedChats: pinnedChats,
          mutedChats: mutedChats,
        ),
        bottomNavigationBar: defaultTargetPlatform != TargetPlatform.windows ? BottomNav(selectedIndex: selectedIndex, onItemTapped: onItemTapped) : null,
      ),
    );
  }
}
