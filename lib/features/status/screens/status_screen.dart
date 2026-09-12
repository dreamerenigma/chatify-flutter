import 'dart:async';
import 'dart:developer';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../calls/screens/calls_screen.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../chat/models/user_model.dart';
import '../../chat/models/user_status_model.dart';
import '../../community/screens/community_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/app_bars/home_app_bar.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../controllers/expanded_controller.dart';
import '../widgets/buttons/status_fab.dart';
import '../widgets/dialogs/add_status_bottom_dialog.dart';
import '../widgets/texts/encryption_info_text.dart';
import '../widgets/widgets/status_header_widget.dart';
import '../widgets/widgets/viewed_status_widget.dart';
import 'confidentiality_status_screen.dart';

class StatusScreen extends StatefulWidget {
  final UserModel user;

  const StatusScreen({super.key, required this.user});

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  final List<UserModel> searchList = [];
  final expandController = Get.put(ExpandController());
  final box = GetStorage();
  final isExpanded = false.obs;
  final RxList<String> viewedUserIds = <String>[].obs;
  bool isSearching = false;
  bool isLoadingStatus = true;
  int selectedIndex = 1;
  List<UserModel> list = [];
  UserStatusModel? userStatus;
  String? _statusImageUrl;
  Timer? _statusExpirationTimer;
  Timer? _statusTimeUpdateTimer;

  @override
  void initState() {
    super.initState();
    _loadStatusImage();
  }

  @override
  void dispose() {
    _statusExpirationTimer?.cancel();
    _statusTimeUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStatusImage() async {
    try {
      final status = await APIs.getUserStatus(widget.user.id);

      if (status == null || status.type != 'image') {
        if (!mounted) return;

        setState(() {
          userStatus = null;
          _statusImageUrl = null;
        });

        return;
      }

      log('STATUS mediaPath: ${status.mediaPath}');
      log('STATUS createdAt: ${status.createdAt}');
      log('STATUS expiresAt: ${status.expiresAt}');

      log('STATUS: начинаем получать URL');
      log('STATUS: mediaPath перед getUrl = ${status.mediaPath}');

      final imageUrl = await APIs.mediaService.getUrl(
        status.mediaPath,
      );

      log('STATUS: getUrl завершён');
      log('STATUS imageUrl: $imageUrl');

      if (!mounted) return;

      setState(() {
        userStatus = status;
        _statusImageUrl = imageUrl;
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
        Navigator.push(context, createPageRoute(CommunityScreen(user: APIs.me)));
        break;
      case 3:
        Navigator.push(context, createPageRoute(CallsScreen(user: APIs.me)));
        break;
      default:
        break;
    }
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
    box.write('isExpanded', isExpanded.value);
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(S.of(context).status),
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
                icon: const Icon(Icons.more_vert),
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
                        Navigator.push(context, createPageRoute(const ConfidentialityStatusScreen()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).settings,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: selectedIndex == 1 ? const StatusFAB() : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusHeaderWidget(user: widget.user, userStatus: userStatus, statusImageUrl: _statusImageUrl, onAddStatus: () => showAddStatusBottomDialog(context)),
            Obx(() => viewedUserIds.isNotEmpty ? ViewedStatusWidget(expandController: expandController, colorsController: colorsController) : const SizedBox.shrink()),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
            const SizedBox(height: 16),
            EncryptionInfoText(firstText: S.of(context).statusUpdatesEncryption, linkText: S.of(context).endToEndEncryption),
          ],
        ),
      ),
    );
  }
}
