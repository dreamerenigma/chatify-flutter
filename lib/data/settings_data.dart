import 'package:flutter/material.dart';
import '../api/apis.dart';
import '../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../features/personalization/controllers/language_controller.dart';
import '../features/personalization/screens/account/account_screen.dart';
import '../features/personalization/screens/chats/chats_screen.dart';
import '../features/personalization/screens/data_storage/data_storage_screen.dart';
import '../features/personalization/screens/favorite/favorite_screen.dart';
import '../features/personalization/screens/help/help_screen.dart';
import '../features/personalization/screens/help/support/screens/support_screen.dart';
import '../features/personalization/screens/invite_friend/invite_friend_screen.dart';
import '../features/personalization/screens/lists/lists_screen.dart';
import '../features/personalization/screens/notifications/notifications_screen.dart';
import '../features/personalization/screens/privacy/privacy_screen.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../features/personalization/screens/special_features/special_features_screen.dart';
import '../generated/l10n/l10n.dart';
import '../routes/custom_page_route.dart';
import '../utils/constants/app_vectors.dart';

Map<String, Widget Function(BuildContext context, Color iconColor)> getSettingsOptions(LanguageController languageController) {
  return {
    'Account': (context, iconColor) => SettingsMenuTile(
      icon: Icons.key_outlined,
      title: S.of(context).account,
      subTitle: S.of(context).subtitleAccount,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(AccountScreen(user: APIs.me))),
    ),
    'Privacy': (context, iconColor) => SettingsMenuTile(
      icon: Icons.lock,
      title: S.of(context).privacy,
      subTitle: S.of(context).subtitlePrivacy,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const PrivacyScreen())),
    ),
    'Lists': (context, iconColor) => SettingsMenuTile(
      icon: PhosphorIcons.user_list_fill,
      title: S.of(context).lists,
      subTitle: S.of(context).subtitleLists,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const ListsScreen())),
    ),
    'Favorite': (context, iconColor) => SettingsMenuTile(
      icon: Icons.favorite,
      title: S.of(context).favorite,
      subTitle: S.of(context).subtitleFavorite,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const FavoriteScreen())),
    ),
    'Chats': (context, iconColor) => SettingsMenuTile(
      icon: Icons.chat_rounded,
      title: S.of(context).chats,
      subTitle: S.of(context).subtitleChats,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const ChatsScreen())),
    ),
    'Notifications': (context, iconColor) => SettingsMenuTile(
      icon: Icons.notifications,
      title: S.of(context).notifications,
      subTitle: S.of(context).subtitleNotifications,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const NotificationsScreen())),
    ),
    'Data storage': (context, iconColor) => SettingsMenuTile(
      icon: Icons.storage,
      title: S.of(context).dataStorage,
      subTitle: S.of(context).subtitleDataStorage,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const DataStorageScreen())),
    ),
    'Application language': (context, iconColor) => SettingsMenuTile(
      icon: Icons.language,
      title: S.of(context).applicationLanguage,
      subTitle: languageController.getSelectedLanguageSubtitle(context),
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => languageController.selectLanguage(context),
    ),
    'Special features': (context, iconColor) => SettingsMenuTile(
      icon: ChatifyVectors.specialFeatures,
      title: S.of(context).specialFeatures,
      subTitle: S.of(context).subtitleSpecialFeatures,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const SpecialFeaturesScreen())),
    ),
    'Help': (context, iconColor) => SettingsMenuTile(
      icon: Icons.help,
      title: S.of(context).help,
      subTitle: S.of(context).subtitleHelp,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const HelpScreen())),
    ),
    'Report a bug': (context, iconColor) => SettingsMenuTile(
      icon: Icons.bug_report,
      title: S.of(context).reportBug,
      subTitle: S.of(context).subtitleReportBug,
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const SupportScreen(
        title: 'Сообщить об ошибке',
        showText: false,
        showReadMoreText: true,
        showCompactButtonOnly: true,
      ))),
    ),
    'Invite friend': (context, iconColor) => SettingsMenuTile(
      icon: Icons.group_rounded,
      title: S.of(context).inviteFriend,
      subTitle: '',
      iconColor: iconColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
      onTap: () => Navigator.push(context, createPageRoute(const InviteFriendScreen())),
    ),
  };
}
