import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/newsletter/models/newsletter.dart';
import 'package:chatify/features/status/widgets/images/camera_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../../utils/popups/dialogs.dart';
import '../../chat/models/user_model.dart';
import '../../community/models/community_model.dart';
import '../../group/models/group_model.dart';
import '../../personalization/controllers/user_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/bottom_nav.dart';
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

class HomeScreenState extends State<HomeScreen> {
  final List<UserModel> searchList = [];
  bool isSearching = false;
  int selectedIndex = 0;
  int selectedChatsCount = 0;
  DateTime? _lastBackPressTime;
  final int _exitTimeout = 2;
  List<GroupModel> groups = [];
  List<CommunityModel> communities = [];
  List<NewsletterModel> newsletters = [];
  List<UserModel> users = [];
  List<SupportAppModel> supports = [];
  Set<int> selectedChats = <int>{};
  bool isSelecting = false;
  bool isToolbarVisible = true;
  bool isLoading = true;
  final UserController userController = Get.find<UserController>();
  final PageController _pageController = PageController();
  late bool isHomeScreen;

  @override
  void initState() {
    super.initState();
    isHomeScreen = selectedIndex == 0;
    APIs.getSelfInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          selectedIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
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

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenDismissed = _lastBackPressTime == null || now.difference(_lastBackPressTime!) > Duration(seconds: _exitTimeout);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenDismissed) {
      _lastBackPressTime = now;

      Dialogs.showSnackbar(context, S.of(context).pressAgainExit);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _clearSelection() {
    setState(() {
      selectedChats.clear();
      isSelecting = false;
    });
  }

  void _handleDeleteSelectedChats() {
    if (selectedChats.isNotEmpty) {
      bool allFromCurrentUser = selectedChats.every((index) => users[index].id == APIs.user.uid);

      if (allFromCurrentUser) {
        final selectedUsers = selectedChats.map((index) => users[index]).toList();
        showDeleteChatDialog(context, selectedUsers, selectedChats.toList(), APIs.me);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).unableDeleteUsersChats)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isHomeScreen = selectedIndex == 0;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
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
              ? SelectionAppBar(selectedChatsCount: selectedChatsCount, onClearSelection: _clearSelection, onHandleDeleteSelectedChats: _handleDeleteSelectedChats)
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
                  hintText: S.of(context).nameEmail,
                )
              : null,
          floatingActionButton: defaultTargetPlatform == TargetPlatform.windows ? null : selectedIndex == 0
              ? Padding(padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              heroTag: 'home',
              onPressed: () async {
                Navigator.push(context, createPageRoute(const HomeSelectUserScreen()));
              },
              elevation: 2,
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              foregroundColor: ChatifyColors.white,
              child: SvgPicture.asset(ChatifyVectors.chatsAdd, color: ChatifyColors.white, width: 28, height: 28),
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
            onPageChanged: _onPageChanged,
            onItemTapped: onItemTapped,
            onGroupSelected: (group) {},
            onUserSelected: (chatUser) {},
            user: widget.user,
          ),
          bottomNavigationBar: defaultTargetPlatform != TargetPlatform.windows ? BottomNav(selectedIndex: selectedIndex, onItemTapped: onItemTapped) : null,
        ),
      ),
    );
  }
}
