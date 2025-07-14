import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/personalization/screens/account/access_keys_screen.dart';
import 'package:chatify/features/personalization/screens/account/email_address_screen.dart';
import 'package:chatify/features/personalization/screens/lists/lists_screen.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/dialogs/add_user_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../data_storage/data_storage_screen.dart';
import '../favorite/favorite_screen.dart';
import '../help/help_screen.dart';
import '../invite_friend/invite_friend_screen.dart';
import '../notifications/notifications_screen.dart';
import '../privacy/privacy_screen.dart';
import '../profile/profile_screen.dart';
import '../account/account_screen.dart';
import '../chats/chats_screen.dart';
import '../qr_code/qr_code_screen.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel user;

  const SettingsScreen({super.key, required this.user});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();
  final TextEditingController searchController = TextEditingController();
  final LanguageController languageController = Get.put(LanguageController());
  FocusNode searchFocusNode = FocusNode();
  bool isSearching = false;
  bool showFirst = true;

  List<String> settingsOptions = [
    'Account',
    'Privacy',
    'Lists',
    'Favorite',
    'Chats',
    'Notifications',
    'Data storage',
    'Application language',
    'Help',
    'Invite friend',
  ];
  List<String> filteredSettingsOptions = [];

  @override
  void initState() {
    super.initState();
    filteredSettingsOptions.addAll(settingsOptions);
    _loadState();
  }

  void onSearchChanged(String query) {
    setState(() {
      filteredSettingsOptions = settingsOptions.where((option) => option.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (isSearching) {
        searchFocusNode.requestFocus();
      } else {
        filteredSettingsOptions.clear();
        filteredSettingsOptions.addAll(settingsOptions);
        searchController.clear();
      }
    });
  }

  Future<void> _loadState() async {
    bool emailConfirmVisible = box.read('email_confirm_visible') ?? true;
    setState(() {
      showFirst = emailConfirmVisible;
    });
  }

  Future<void> _hideFirstShowSecond() async {
    await box.write('email_confirm_visible', false);
    setState(() {
      showFirst = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          title: isSearching
              ? TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            child: TextField(
              focusNode: searchFocusNode,
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              controller: searchController,
              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
              decoration: InputDecoration(
                hintText: S.of(context).settingsSearch,
                hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            ),
          )
          : Text(S.of(context).settings, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          actions: [
            IconButton(
              icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
              onPressed: toggleSearch,
            ),
          ],
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.dragged)) {
                    return ChatifyColors.darkerGrey;
                  }
                  return ChatifyColors.darkerGrey;
                },
              ),
            ),
            child: Scrollbar(
              thickness: 4,
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1 * 255).toInt()),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    ...[
                      if (showFirst)
                        _buildEmailConfirm(
                          context,
                          title: 'Подтвердите по электронной почте',
                          subtitle: 'Используйте электронную почту для входа в аккаунт или его восстановление. ',
                          actionText: 'Добавить электронный адрес',
                          onActionTap: () async {
                            await Navigator.push(context, createPageRoute(EmailAddressScreen()));
                            _hideFirstShowSecond();
                          },
                          onClose: _hideFirstShowSecond,
                        )
                      else
                        _buildEmailConfirm(
                          context,
                          title: 'Защитите свой аккаунт',
                          subtitle: 'Войдите с помощью функции распознавания лица, отпечатка пальца или с помощью функции блокировки экрана. ',
                          actionText: 'Создать ключ доступа',
                          onActionTap: () async {
                            await Navigator.push(context, createPageRoute(AccessKeysScreen()));
                            _hideFirstShowSecond();
                          },
                          onClose: () {},
                        ),
                    ],
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(ProfileScreen(user: widget.user)));
                      },
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 8, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .05),
                              child: CachedNetworkImage(
                                width: DeviceUtils.getScreenHeight(context) * .08,
                                height: DeviceUtils.getScreenHeight(context) * .08,
                                imageUrl: widget.user.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .08, height: DeviceUtils.getScreenHeight(context) * .08),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.user.name, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                                  const SizedBox(height: 4),
                                  Text(widget.user.status, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Obx(() {
                                  return IconButton(
                                    onPressed: () {
                                      Dialogs.showCustomDialog(context: context, message: 'Пожалуйста, подождите', duration: const Duration(seconds: 1));
                                      Future.delayed(const Duration(seconds: 2), () {
                                        Navigator.pop(context);
                                        Navigator.push(context, createPageRoute(QrCodeScreen(user: widget.user)));
                                      });
                                    },
                                    icon: Icon(Icons.qr_code, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                  );
                                }),
                                Obx(() {
                                  return IconButton(
                                    onPressed: () {
                                      showAddUserBottomSheet(context, widget.user.image, widget.user.name, widget.user.phoneNumber);
                                    },
                                    icon: Icon(Icons.add_circle_outline_rounded, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      itemCount: filteredSettingsOptions.length,
                      itemBuilder: (context, index) {
                        String option = filteredSettingsOptions[index];
                        return Obx(() {
                          Color iconColor = colorsController.getColor(colorsController.selectedColorScheme.value);

                          switch (option) {
                            case 'Account':
                              return SettingsMenuTile(
                                icon: Icons.key_outlined,
                                title: S.of(context).account,
                                subTitle: S.of(context).subtitleAccount,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(AccountScreen(user: APIs.me)));
                                },
                              );
                            case 'Privacy':
                              return SettingsMenuTile(
                                icon: Icons.lock,
                                title: S.of(context).privacy,
                                subTitle: S.of(context).subtitlePrivacy,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const PrivacyScreen()));
                                },
                              );
                            case 'Lists':
                              return SettingsMenuTile(
                                icon: PhosphorIcons.user_list_fill,
                                title: S.of(context).lists,
                                subTitle: S.of(context).subtitleLists,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const ListsScreen()));
                                },
                              );
                            case 'Favorite':
                              return SettingsMenuTile(
                                icon: Icons.favorite,
                                title: S.of(context).favorite,
                                subTitle: S.of(context).subtitleFavorite,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const FavoriteScreen()));
                                },
                              );
                            case 'Chats':
                              return SettingsMenuTile(
                                icon: Icons.chat_rounded,
                                title: S.of(context).chats,
                                subTitle: S.of(context).subtitleChats,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const ChatsScreen()));
                                },
                              );
                            case 'Notifications':
                              return SettingsMenuTile(
                                icon: Icons.notifications,
                                title: S.of(context).notifications,
                                subTitle: S.of(context).subtitleNotifications,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const NotificationsScreen()));
                                },
                              );
                            case 'Data storage':
                              return SettingsMenuTile(
                                icon: Icons.storage,
                                title: S.of(context).dataStorage,
                                subTitle: S.of(context).subtitleDataStorage,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const DataStorageScreen()));
                                },
                              );
                            case 'Application language':
                              return SettingsMenuTile(
                                icon: Icons.language,
                                title: S.of(context).applicationLanguage,
                                subTitle: languageController.getSelectedLanguageSubtitle(context),
                                iconColor: iconColor,
                                onTap: () => languageController.selectLanguage(context),
                              );
                            case 'Help':
                              return SettingsMenuTile(
                                icon: Icons.help,
                                title: S.of(context).help,
                                subTitle: S.of(context).subtitleHelp,
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const HelpScreen()));
                                },
                              );
                            case 'Invite friend':
                              return SettingsMenuTile(
                                icon: Icons.group_rounded,
                                title: S.of(context).inviteFriend,
                                subTitle: '',
                                iconColor: iconColor,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(const InviteFriendScreen()));
                                },
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailConfirm(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onActionTap,
    required VoidCallback onClose,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.only(left: 2, right: 8, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(FluentIcons.shield_task_16_regular, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 48),
            SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold, height: 1.2),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.2, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                      children: [
                        TextSpan(text: subtitle),
                        TextSpan(
                          text: actionText,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          recognizer: TapGestureRecognizer()..onTap = onActionTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close, color: ChatifyColors.grey, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
