import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../calls/screens/calls_screen.dart';
import '../../chat/models/user_model.dart';
import '../../community/screens/community_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/app_bars/home_app_bar.dart';
import '../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../controllers/expanded_controller.dart';
import '../widgets/buttons/status_fab.dart';
import '../widgets/dialogs/add_status_bottom_dialog.dart';
import 'confidentiality_status_screen.dart';

class StatusScreen extends StatefulWidget {
  final UserModel user;

  const StatusScreen({super.key, required this.user});

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  List<UserModel> list = [];
  int selectedIndex = 1;
  final List<UserModel> searchList = [];
  bool isSearching = false;
  final expandController = Get.put(ExpandController());
  final box = GetStorage();
  final isExpanded = false.obs;
  final RxList<String> viewedUserIds = <String>[].obs;

  void markStatusAsViewed(String userId) {
    if (!viewedUserIds.contains(userId)) {
      viewedUserIds.add(userId);
    }
  }

  String formatStatusDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays == 1) {
      return 'Вчера, ${_formatTime(date)}';
    } else {
      return '${date.day}.${date.month}.${date.year}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
          popupMenuButton: PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, createPageRoute(const ConfidentialityStatusScreen()));
              } else if (value == 2) {
                Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.only(left: 20, right: 16, top: 8, bottom: 8),
                child: Text(S.of(context).confidentialityStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
              PopupMenuItem(
                value: 2,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Text(S.of(context).settings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        floatingActionButton: selectedIndex == 1 ? const StatusFAB() : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                showAddStatusBottomDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .5),
                          child: CachedNetworkImage(
                            width: DeviceUtils.getScreenHeight(context) * .062,
                            height: DeviceUtils.getScreenHeight(context) * .062,
                            imageUrl: widget.user.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey),
                            errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .062, height: DeviceUtils.getScreenHeight(context) * .062),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -3,
                          right: -5,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                              ),
                              child: const Icon(Icons.add, color: ChatifyColors.white, size: 19),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).addStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                          Text(
                            S.of(context).addNewStatus,
                            style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.5),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => viewedUserIds.isNotEmpty ? _buildViewedStatus() : const SizedBox.shrink()),
            if (!expandController.isExpanded.value) const SizedBox(height: 8),
            const Divider(height: 0, thickness: 1),
            const SizedBox(height: 16),
            _buildEncryptionText(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewedStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                expandController.isExpanded.value = !expandController.isExpanded.value;
              });
            },
            child: Row(
              children: [
                Text(
                  S.of(context).viewed,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
                const Spacer(),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: expandController.isExpanded.value ? 0.5 : 0.0,
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                ),
              ],
            ),
          ),
        ),
        expandController.isExpanded.value
      ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, width: 2.2),
                  ),
                  child: Container(
                    width: DeviceUtils.getScreenHeight(context) * .07,
                    height: DeviceUtils.getScreenHeight(context) * .07,
                    decoration: BoxDecoration(
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(ChatifyImages.appLogoLight, width: 34, height: 34, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).appName,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(ChatifyVectors.starburst, width: 16, height: 16, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              SvgPicture.asset(ChatifyVectors.checkmark, width: 10, height: 10, color: ChatifyColors.white),
                            ],
                          ),
                          const Positioned(
                            top: 3,
                            right: 3,
                            child: Icon(BootstrapIcons.check, size: 13, color: ChatifyColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Сегодня, 14:56',
                    style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.5),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildEncryptionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        child: Icon(Icons.lock_outline, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, size: 14),
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: S.of(context).statusUpdatesEncryption,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).encryption,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        showChatsCallsPrivacyBottomSheet(
                          context,
                          headerText: S.of(context).yourStatusAndChatsPrivate,
                          titleText: S.of(context).statusUpdatesAndPrivateMessages,
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
    );
  }
}
