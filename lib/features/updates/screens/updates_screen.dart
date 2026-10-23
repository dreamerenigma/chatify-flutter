import 'dart:async';
import 'dart:developer';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/apis.dart';
import '../../../data/channels_data.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_keys.dart';
import '../../calls/screens/calls_screen.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../channel/models/channel_model.dart';
import '../../channel/widgets/cards/channel_card.dart';
import '../../channel/widgets/dialogs/create_channel_bottom_sheet_dialog.dart';
import '../../chat/models/user_model.dart';
import '../../chat/models/user_status_model.dart';
import '../../community/screens/communities_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/bars/app_bars/home_app_bar.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/buttons/custom_scale_button.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../controllers/expanded_controller.dart';
import '../widgets/buttons/status_fab.dart';
import '../widgets/dialogs/add_status_bottom_dialog.dart';
import '../widgets/widgets/status_header_widget.dart';
import '../widgets/widgets/viewed_status_widget.dart';
import 'status_privacy_screen.dart';

class UpdatesScreen extends StatefulWidget {
  final UserModel user;

  const UpdatesScreen({
    super.key,
    required this.user,
  });

  @override
  UpdatesScreenState createState() => UpdatesScreenState();
}

class UpdatesScreenState extends State<UpdatesScreen> {
  final List<UserModel> searchList = [];
  final expandController = Get.put(ExpandController());
  final box = GetStorage();
  final isExpanded = false.obs;
  final RxList<String> viewedUserIds = <String>[].obs;
  bool isSearching = false;
  bool isLoadingStatus = true;
  bool hasViewedLatestStatus = false;
  bool isLatestStatusesExpanded = true;
  bool isRecommendedExpanded = true;
  int selectedIndex = 2;
  String? _statusImageUrl;
  String? _profileImageUrl;
  List<UserModel> list = [];
  List<ChannelModel> allChannels = channels;
  List<ChannelModel> subscribedChannels = [];
  List<ChannelModel> recommendedChannels = [];
  UserStatusModel? userStatus;
  Timer? _statusExpirationTimer;
  Timer? _statusTimeUpdateTimer;

  @override
  void initState() {
    super.initState();
    _loadStatusImage();
    _loadLatestStatusesExpanded();
    _updateRecommendedChannels();
  }

  @override
  void dispose() {
    _statusExpirationTimer?.cancel();
    _statusTimeUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLatestStatusesExpanded() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      isLatestStatusesExpanded = prefs.getBool(AppKeys.latestStatusesExpandedKey) ?? true;
    });
  }

  Future<void> _loadStatusImage() async {
    try {
      String? profileImageUrl;

      if (widget.user.image.trim().isNotEmpty) {
        final result = await APIs.mediaService.getUrl(widget.user.image);

        profileImageUrl = result;
      }

      final status = await APIs.getUserStatus(widget.user.id);

      if (status == null || status.type != 'image') {
        if (!mounted) return;

        setState(() {
          userStatus = null;
          _statusImageUrl = null;
          _profileImageUrl = profileImageUrl;
        });

        return;
      }

      final imageUrl = await APIs.mediaService.getUrl(status.mediaPath);

      if (!mounted) return;

      setState(() {
        userStatus = status;
        _statusImageUrl = imageUrl;
        _profileImageUrl = profileImageUrl;
      });

      _startStatusTimers(status);
    } catch (e) {
      log('Ошибка загрузки изображения статуса: $e');
    } finally {
      if (!mounted) return;

      setState(() {
        isLoadingStatus = false;
      });
    }
  }

  void _startStatusTimers(UserStatusModel status) {
    _statusExpirationTimer?.cancel();
    _statusTimeUpdateTimer?.cancel();

    final remaining = status.expiresAt.difference(DateTime.now());

    if (remaining.isNegative || remaining == Duration.zero) {
      _removeExpiredStatus();
      return;
    }

    _statusExpirationTimer = Timer(
      remaining,
      _removeExpiredStatus,
    );

    _statusTimeUpdateTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (!mounted || userStatus == null) return;

        setState(() {});
      },
    );
  }

  void markStatusAsViewed(String userId) {
    if (!viewedUserIds.contains(userId)) {
      viewedUserIds.add(userId);
    }
  }

  void _removeExpiredStatus() {
    _statusExpirationTimer?.cancel();
    _statusTimeUpdateTimer?.cancel();

    if (!mounted) return;

    setState(() {
      userStatus = null;
      _statusImageUrl = null;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(context, createPageRoute(HomeScreen(user: widget.user)));
        break;
      case 1:
        break;
      case 2:
        Navigator.push(context, createPageRoute(CommunitiesScreen(user: widget.user)));
        break;
      case 3:
        Navigator.push(context, createPageRoute(CallsScreen(user: widget.user)));
        break;
      default:
        break;
    }
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
    box.write('isExpanded', isExpanded.value);
  }

  void _updateRecommendedChannels() {
    final subscribedIds = subscribedChannels.map((channel) => channel.id).toSet();

    recommendedChannels = allChannels.where((channel) => !subscribedIds.contains(channel.id)).toList()..sort((a, b) => b.subscribersCount.compareTo(a.subscribersCount));
  }

  @override
  Widget build(BuildContext context) {
    final subscribedIds = <String>{'channel_001', 'channel_002', 'channel_003', 'channel_004'};
    final subscribedChannels = allChannels.where((channel) => subscribedIds.contains(channel.id)).toList();
    final recommendedChannels = allChannels.where((channel) => !subscribedIds.contains(channel.id)).toList()..sort((a, b) => b.subscribersCount.compareTo(a.subscribersCount));

    return GestureDetector(
      onTap: () {
        if (isSearching) {
          setState(() {
            isSearching = false;
          });
        }
      },
      child: Scaffold(
        appBar: HomeAppBar(
          isSearching: isSearching,
          onSearch: (val) {
            searchList.clear();
            for (var i in list) {
              if (i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())) {
                searchList.add(i);
              }
              setState(() {
                searchList;
              });
            }
          },
          onToggleSearch: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          showHomeIcon: false,
          hintText: S.of(context).settingsSearch,
          title: Text('Актуальное'),
          popupMenuButton: TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: S.of(context).more,
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 320),
                icon: const Icon(Icons.more_vert_rounded, size: 25),
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
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
                      text: S.of(context).confidentialityStatus,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(const StatusPrivacyScreen()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Создать канал',
                      onTap: () {
                        Navigator.pop(context);
                        showCreateChannelBottomSheet(context, widget.user);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).settings,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(SettingsScreen(user: widget.user)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: selectedIndex == 2 ? StatusFAB(user: widget.user) : null,
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 8),
                  child: Text('Статус', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                ),
                StatusHeaderWidget(user: widget.user, userStatus: userStatus, statusImageUrl: _statusImageUrl, profileImageUrl: _profileImageUrl, onAddStatus: () => showAddStatusBottomDialog(context, widget.user)),
                Obx(() => viewedUserIds.isNotEmpty ? ViewedStatusWidget(expandController: expandController, colorsController: colorsController) : const SizedBox.shrink()),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 5, top: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Каналы', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                          Spacer(),
                          if (subscribedChannels.isNotEmpty) ...[
                            Text(
                              'Смотреть',
                              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_right_rounded, size: 25, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          ],
                        ],
                      ),
                      if (!subscribedChannels.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Будьте в курсе тем, которые вам интересны. Ниже вы найдете каналы, на которые можно подписаться.',
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                        itemCount: subscribedChannels.length,
                        itemBuilder: (context, index) {
                          final channel = subscribedChannels[index];

                          return ChannelCard(channel: channel, onTap: () {});
                        },
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Рекомендуемые каналы',
                                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isRecommendedExpanded = !isRecommendedExpanded;
                                      });
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: ChatifyColors.darkGrey.withAlpha(20),
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(25), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 2))],
                                      ),
                                      alignment: Alignment.center,
                                      child: AnimatedRotation(
                                        turns: isRecommendedExpanded ? 0 : 0.5,
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        child: const Icon(Icons.keyboard_arrow_up_rounded, size: 23, color: ChatifyColors.darkGrey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              child: isRecommendedExpanded
                                ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recommendedChannels.length,
                                  itemBuilder: (context, index) {
                                    final channel = recommendedChannels[index];

                                    return ChannelCard(channel: channel, isSubscribed: false, onTap: () {}, onSubscribe: () {});
                                  },
                                )
                                : const SizedBox(width: double.infinity),
                            ),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomScaleButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(ChatifyVectors.apps, width: 17, height: 17, colorFilter: ColorFilter.mode( colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)),
                            label: Text(
                              'Показать больше',
                              style: TextStyle(
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                fontSize: ChatifySizes.fontSizeMd,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.darkGrey),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomScaleButton(
                            onPressed: () {
                              showCreateChannelBottomSheet(context, widget.user);
                            },
                            icon: Icon(Icons.add_rounded, size: 20, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            label: Text(
                              'Создать канал',
                              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            ),
                            style: OutlinedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.darkGrey),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 150),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
