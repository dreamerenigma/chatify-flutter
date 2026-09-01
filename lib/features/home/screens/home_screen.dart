import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/newsletter/models/newsletter_model.dart';
import 'package:chatify/features/status/widgets/images/camera_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
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
  final UserController userController = Get.find<UserController>();
  final PageController _pageController = PageController();
  late bool isHomeScreen;
  bool isSearching = false;
  bool isToolbarVisible = true;
  bool isLoading = true;
  int selectedIndex = 0;
  int selectedChatsCount = 0;
  List<GroupModel> groups = [];
  List<CommunityModel> communities = [];
  List<NewsletterModel> newsletters = [];
  List<UserModel> users = [];
  List<SupportAppModel> supports = [];
  List<InfoAppModel> infosApp = [];

  bool get isSelecting => selectedChats.isNotEmpty;

  @override
  void initState() {
    super.initState();
    isHomeScreen = selectedIndex == 0;
    WidgetsBinding.instance.addObserver(this);
    APIs.getSelfInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(selectedIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
    _loadUserInfo();
    _fetchGroups();
    _fetchCommunities();
    _fetchNewsletters();
    _fetchSupportChat();
  }

  @override
  void dispose() {
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

  Future<void> _loadUserInfo() async {
    await APIs.getSelfInfo();
    setState(() {
      isLoading = false;
    });
  }

  void _fetchGroups() async {
    List<GroupModel> fetchedGroups = await APIs.getGroups();
    setState(() {
      groups = fetchedGroups;
    });
  }

  void _fetchCommunities() async {
    List<CommunityModel> fetchedCommunities = await APIs.getCommunity();
    setState(() {
      communities = fetchedCommunities;
    });
  }

  void _fetchNewsletters() async {
    List<NewsletterModel> fetchedNewsletters = await APIs.getNewsletter();
    setState(() {
      newsletters = fetchedNewsletters;
    });
  }

  void _fetchSupportChat() async {
    List<SupportAppModel> fetchedSupports = await APIs.getSupportChat();
    setState(() {
      supports = fetchedSupports;
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

  void _clearSelection() {
    setState(() {
      selectedChats.clear();
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

  void _toggleChatSelection(UserModel user) {
    setState(() {
      if (selectedChats.contains(user.id)) {
        selectedChats.remove(user.id);
      } else {
        selectedChats.add(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          : isSelecting
            ? SelectionAppBar(
                selectedChatsCount: selectedChats.length,
                onClearSelection: _clearSelection,
                onDelete: _handleDeleteSelectedChats,
                onPin: () {},
                onMute: () {},
                onArchive: () {},
                onAddToFavorites: () {},
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
                  Navigator.push(context, createPageRoute(const CameraScreen()));
                },
                hintText: S.of(context).search,
              )
            : null,
        floatingActionButton: defaultTargetPlatform == TargetPlatform.windows ? null : selectedIndex == 0
          ? Padding(padding: const EdgeInsets.only(bottom: 5),
              child: FloatingActionButton(
                heroTag: 'home',
                onPressed: () async {
                  Navigator.push(context, createPageRoute(const HomeSelectUserScreen()));
                },
                elevation: 2,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                child: SvgPicture.asset(ChatifyVectors.chatsAdd, width: 26, height: 26, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
              ),
            )
          : null,
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
          onGroupSelected: (group) {},
          onUserSelected: (user) {
            _toggleChatSelection(user);
          },
          user: widget.user,
        ),
        bottomNavigationBar: defaultTargetPlatform != TargetPlatform.windows ? BottomNav(selectedIndex: selectedIndex, onItemTapped: onItemTapped) : null,
      ),
    );
  }
}
