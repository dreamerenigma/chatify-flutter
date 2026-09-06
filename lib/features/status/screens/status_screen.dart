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
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../calls/screens/calls_screen.dart';
import '../../chat/models/user_model.dart';
import '../../chat/models/user_status_model.dart';
import '../../community/screens/community_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/app_bars/home_app_bar.dart';
import '../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../controllers/expanded_controller.dart';
import '../widgets/buttons/status_fab.dart';
import '../widgets/dialogs/add_status_bottom_dialog.dart';
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
  int selectedIndex = 1;
  List<UserModel> list = [];
  UserStatusModel? userStatus;

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                            errorWidget: (context, url, error) => Container(
                              width: DeviceUtils.getScreenHeight(context) * .062,
                              height: DeviceUtils.getScreenHeight(context) * .062,
                              color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                ChatifyVectors.person, width: 22, height: 22, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn),
                              ),
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
                              child: const Icon(Icons.add, color: ChatifyColors.black, size: 18),
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
                          Text(S.of(context).addStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w600)),
                          if (userStatus != null)
                            Row(
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.network(userStatus!.mediaUrl, width: 32, height: 32, fit: BoxFit.cover)),
                                const SizedBox(width: 8),
                                Text('Фото', style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey)),
                              ],
                            )
                          else
                            Text(
                              widget.user.status.isNotEmpty ? widget.user.status : S.of(context).addNewStatus,
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
            Obx(() => viewedUserIds.isNotEmpty ? ViewedStatusWidget(expandController: expandController, colorsController: colorsController) : const SizedBox.shrink()),
            if (!expandController.isExpanded.value) const SizedBox(height: 8),
            const Divider(height: 0, thickness: 1),
            const SizedBox(height: 16),
            _buildEncryptionText(),
          ],
        ),
      ),
    );
  }

  Widget _buildEncryptionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(Icons.lock_outline, size: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: S.of(context).statusUpdatesEncryption,
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: 13),
                    ),
                    TextSpan(
                      text: S.of(context).endToEndEncryption,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).yourStatusAndChatsPrivate, titleText: S.of(context).statusUpdatesAndPrivateMessages);
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
