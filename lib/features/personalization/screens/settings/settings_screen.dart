import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/personalization/screens/account/access_keys_screen.dart';
import 'package:chatify/features/personalization/screens/account/email_address_screen.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../data/settings_data.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/dialogs/add_user_bottom_dialog.dart';
import '../../widgets/dialogs/center_accounts_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../profile/profile_screen.dart';
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
  bool showSecond = true;

  List<String> settingsOptions = [
    'Account',
    'Privacy',
    'Lists',
    'Favorite',
    'Chats',
    'Notifications',
    'Data storage',
    'Special features',
    'Application language',
    'Help',
    'Report a bug',
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
    bool secondBlockVisible = box.read('create_access_key') ?? true;

    setState(() {
      showFirst = emailConfirmVisible;
      showSecond = secondBlockVisible;
    });
  }

  Future<void> _hideFirstShowSecond() async {
    await box.write('email_confirm_visible', false);
    setState(() {
      showFirst = false;
      showSecond = true;
    });
  }

  Future<void> _hideSecond() async {
    await box.write('create_access_key', false);
    setState(() {
      showSecond = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsMap = getSettingsOptions(languageController);

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
            data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
            child: Scrollbar(
              thickness: 4,
              thumbVisibility: false,
              radius: Radius.circular(12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
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
                          title: S.of(context).confirmByEmail,
                          subtitle: S.of(context).useYourEmailSignInAccountRecover,
                          actionText: S.of(context).addEmailAddress,
                          onActionTap: () async {
                            await Navigator.push(context, createPageRoute(EmailAddressScreen()));
                            _hideFirstShowSecond();
                          },
                          onClose: _hideFirstShowSecond,
                        )
                      else if (showSecond)
                        _buildEmailConfirm(
                          context,
                          title: S.of(context).protectYourAccount,
                          subtitle: S.of(context).signInFaceRecognitionFingerprint,
                          actionText: S.of(context).createAccessKey,
                          onActionTap: () async {
                            await Navigator.push(context, createPageRoute(AccessKeysScreen()));
                            _hideSecond();
                          },
                          onClose: _hideSecond,
                        ),
                    ],
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(ProfileScreen(user: widget.user)));
                      },
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 6, top: 8, bottom: 8),
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
                                      Dialogs.showCustomDialog(context: context, message: S.of(context).pleaseWait, duration: const Duration(seconds: 1));
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
                        final optionKey = filteredSettingsOptions[index];
                        final widgetBuilder = settingsMap[optionKey];

                        if (widgetBuilder == null) return const SizedBox.shrink();

                        return Obx(() {
                          final updatedIconColor = colorsController.getColor(colorsController.selectedColorScheme.value);
                          return widgetBuilder(context, updatedIconColor);
                        });
                      },
                    ),
                    Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey),
                    _buildCenterAccounts(),
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
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
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

  Widget _buildCenterAccounts() {
    final backgroundColor = context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () {
              Dialogs.showCustomDialog(context: context, message: S.of(context).accountDownloadCenter, duration: const Duration(seconds: 1));

              Future.delayed(const Duration(seconds: 1), () {
                if (Navigator.canPop(context)) Navigator.pop(context);

                Future.microtask(() => showCenterAccountsBottomDialog(context));
              });
            },
            borderRadius: BorderRadius.circular(12),
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(ChatifyImages.logoIS, height: 18),
                  const SizedBox(height: 8),
                  Text(S.of(context).accountCenter, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(S.of(context).manageYourAccountsAppProducts, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: 13, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
