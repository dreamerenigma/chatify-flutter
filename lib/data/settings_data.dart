import 'package:chatify/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../api/apis.dart';
import '../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../features/personalization/controllers/language_controller.dart';
import '../features/personalization/screens/account/account_screen.dart';
import '../features/personalization/screens/chats/chats_screen.dart';
import '../features/personalization/screens/data_storage/data_storage_screen.dart';
import '../features/personalization/screens/favorite/favorite_screen.dart';
import '../features/personalization/screens/help/help_screen.dart';
import '../features/personalization/screens/invite_friend/invite_friend_screen.dart';
import '../features/personalization/screens/lists/lists_screen.dart';
import '../features/personalization/screens/notifications/notifications_screen.dart';
import '../features/personalization/screens/privacy/privacy_screen.dart';
import '../features/personalization/screens/settings/parental_controls_screen.dart';
import '../features/personalization/screens/special_features/special_features_screen.dart';
import '../features/personalization/widgets/dialogs/language_bottom_sheet_dialog.dart';
import '../generated/l10n/l10n.dart';
import '../routes/custom_page_route.dart';
import '../utils/constants/app_vectors.dart';

Map<String, Widget Function(BuildContext context, Color iconColor)> getSettingsOptions(LanguagesController languageController) {
  return {
    'Account': (context, iconColor) => SettingsMenuTile(
      icon: ChatifyVectors.key,
      title: S.of(context).account,
      subTitle: S.of(context).subtitleAccount,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(AccountScreen(user: APIs.me))),
    ),
    'Privacy': (context, iconColor) => SettingsMenuTile(
      icon: Icons.lock_outline_rounded,
      title: S.of(context).privacy,
      subTitle: S.of(context).subtitlePrivacy,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const PrivacyScreen())),
    ),
    'Lists': (context, iconColor) => SettingsMenuTile(
      icon: ChatifyVectors.userListOutline,
      title: S.of(context).lists,
      subTitle: S.of(context).subtitleLists,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const ListsScreen())),
    ),
    'Favorite': (context, iconColor) => SettingsMenuTile(
      icon: Icons.favorite_outline,
      title: S.of(context).favorite,
      subTitle: S.of(context).subtitleFavorite,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const FavoriteScreen())),
    ),
    'Chats': (context, iconColor) => SettingsMenuTile(
      icon: ChatifyVectors.messageOutline,
      title: S.of(context).chats,
      subTitle: S.of(context).subtitleChats,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const ChatsScreen())),
    ),
    'Notifications': (context, iconColor) => SettingsMenuTile(
      icon: Icons.notifications_none_rounded,
      title: S.of(context).notifications,
      subTitle: S.of(context).subtitleNotifications,
      iconColor: iconColor,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const NotificationsScreen())),
    ),
    'Data storage': (context, iconColor) => SettingsMenuTile(
      icon: Icons.storage,
      title: S.of(context).dataStorage,
      subTitle: S.of(context).subtitleDataStorage,
      titleFontSize: 15,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const DataStorageScreen())),
    ),
    'Parental controls': (context, iconColor) => SettingsMenuTile(
      icon: ChatifyVectors.familyShield,
      title: 'Родительский контроль',
      subTitle: 'Настройки для вашей семьи',
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const ParentalControlsScreen())),
    ),
    'Application language': (context, iconColor) => SettingsMenuTile(
      icon: Icons.language,
      title: S.of(context).applicationLanguage,
      subTitle: languageController.getSelectedLanguageSubtitle(context),
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => showLanguageBottomSheetDialog(context, languageController),
    ),
    'Special features': (context, iconColor) => SettingsMenuTile(
      icon: ChatifyVectors.specialFeatures,
      title: S.of(context).specialFeatures,
      subTitle: S.of(context).subtitleSpecialFeatures,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const SpecialFeaturesScreen())),
    ),
    'Help': (context, iconColor) => SettingsMenuTile(
      icon: Icons.help_outline_rounded,
      title: S.of(context).help,
      subTitle: S.of(context).subtitleHelp,
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const HelpScreen())),
    ),
    'Invite friend': (context, iconColor) => SettingsMenuTile(
      icon: Icons.group_outlined,
      title: S.of(context).inviteFriend,
      subTitle: 'Пригласите друзей присоединиться к Chatify',
      iconColor: iconColor,
      iconSize: 24,
      backgroundColor: ChatifyColors.transparent,
      noRoundedCorners: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () => Navigator.push(context, createPageRoute(const InviteFriendScreen())),
    ),
  };
}
