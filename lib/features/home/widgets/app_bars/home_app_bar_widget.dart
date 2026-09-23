import 'package:chatify/features/community/screens/new_community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../personalization/controllers/seasons_controller.dart';
import '../../../personalization/screens/favorite/favorite_message_screen.dart';
import '../../../group/screens/new_group_screen.dart';
import '../../../personalization/screens/settings/settings_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../newsletter/screens/new_newsletter_screen.dart';
import '../../screens/related_devices_screen.dart';
import 'home_app_bar.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final List<UserModel> users;
  final List<UserModel> searchList;
  final Function(String) onSearch;
  final VoidCallback onToggleSearch;
  final VoidCallback onCameraPressed;
  final String hintText;

  const HomeAppBarWidget({
    super.key,
    required this.isSearching,
    required this.users,
    required this.searchList,
    required this.onSearch,
    required this.onToggleSearch,
    required this.onCameraPressed,
    required this.hintText,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: HomeAppBar(
        showHomeIcon: true,
        isSearching: isSearching,
        onSearch: onSearch,
        onToggleSearch: onToggleSearch,
        onCameraPressed: onCameraPressed,
        hintText: hintText,
        title: Obx(() {
          final seasonIcon = SeasonsController.instance.getSeasonalIcon();
          final currentSeason = SeasonsController.instance.selectedSeason.value;

          double getTopOffsetForSeason(String season) {
            switch (season) {
              case 'winter':
                return 0;
              case 'spring':
                return 6;
              case 'summer':
                return 6;
              case 'autumn':
                return 7;
              default:
                return 0;
            }
          }

          double getLeftOffsetForSeason(String season) {
            switch (season) {
              case 'winter':
                return -8;
              case 'spring':
                return 77;
              case 'summer':
                return 78;
              case 'autumn':
                return 78;
              default:
                return 75;
            }
          }

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  S.of(context).appName,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.bold, fontSize: ChatifySizes.fontSizeMg),
                ),
              ),
              if (seasonIcon.isNotEmpty)
              Positioned(
                top: getTopOffsetForSeason(currentSeason),
                left: getLeftOffsetForSeason(currentSeason),
                child: SvgPicture.asset(seasonIcon, height: 24, width: 24),
              ),
            ],
          );
        }),
        popupMenuButton: TooltipTheme(
          data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
          child: Theme(
            data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
            child: PopupMenuButton<int>(
              tooltip: S.of(context).more,
              position: PopupMenuPosition.under,
              offset: const Offset(-8, 0),
              menuPadding: EdgeInsets.symmetric(vertical: 4),
              constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
              icon: const Icon(Icons.more_vert),
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
              color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).newGroup,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(NewGroupScreen(selectedUsers: users)));
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).newCommunity,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(NewCommunityScreen(onCommunitySelected: (CommunityModel value) {})));
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).newNewsletters,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(const NewNewsletterScreen(selectedUsers: [])));
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).appRelatedDevices,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(const RelatedDevicesScreen()));
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 5,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).favorites,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(const FavoriteMessageScreen()));
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).readAll,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 7,
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
    );
  }
}
