import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/screens/favorite/favorite_message_screen.dart';
import '../../../group/screens/new_group_screen.dart';
import '../../../personalization/screens/settings/settings_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/new_newsletter_screen.dart';
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
        title: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Chatify',
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  fontWeight: FontWeight.bold,
                  fontSize: ChatifySizes.fontSizeMg,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: -8,
              child: SvgPicture.asset(ChatifyVectors.christmas, height: 24, width: 24),
            ),
          ],
        ),
        popupMenuButton: PopupMenuButton<int>(
          color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
          position: PopupMenuPosition.under,
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 1) {
              Navigator.push(context, createPageRoute(const NewGroupScreen()));
            } else if (value == 2) {
              Navigator.push(context, createPageRoute(const NewNewsletterScreen(selectedUsers: [])));
            } else if (value == 3) {
              Navigator.push(context, createPageRoute(const FavoriteMessageScreen()));
            } else if (value == 4) {
              Navigator.push(context, createPageRoute(const RelatedDevicesScreen()));
            } else if (value == 5) {

            } else if (value == 6) {
              Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
              child: Text(S.of(context).newGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
            PopupMenuItem(
              value: 2,
              padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
              child: Text(S.of(context).newNewsletters, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
            PopupMenuItem(
              value: 3,
              padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
              child: Text(S.of(context).favoriteMessages, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
            PopupMenuItem(
              value: 4,
              padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
              child: Text('Связанные устройства', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
            PopupMenuItem(
              value: 5,
              padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
              child: Text('Прочитать все', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
            PopupMenuItem(
              value: 6,
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(S.of(context).settings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
