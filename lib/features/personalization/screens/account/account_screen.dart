import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatify/features/personalization/screens/account/request_account_information_screen.dart';
import 'package:chatify/features/personalization/screens/account/two_step_verification_screen.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../authentication/screens/login_screen.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/dialogs/add_user_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/logout_dialog.dart';
import '../profile/username_screen.dart';
import 'access_keys_screen.dart';
import 'delete_account_screen.dart';
import 'edit_phone_screen.dart';
import 'email_address_screen.dart';
import 'notifications_security_screen.dart';

class AccountScreen extends StatefulWidget {
  final UserModel user;

  const AccountScreen({super.key, required this.user});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).account, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TooltipTheme(
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
                          icon: SvgPicture.asset(ChatifyVectors.documentOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                          text: 'Запрос информации аккаунта',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          icon: const Icon(FluentIcons.delete_24_regular, size: 24, color: ChatifyColors.danger),
                          text: 'Удалить аккаунт',
                          color: ChatifyColors.danger,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingsMenuTile(
                  icon: Icons.person_add_alt,
                  title: S.of(context).addAccount,
                  onTap: () => showAddUserBottomSheet(context, widget.user.image, widget.user.name, widget.user.phoneNumber),
                ),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 5, bottom: 0),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 20, top: 16, bottom: 14),
                  child: Text('Вход и безопасность', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
                _buildSettingsMenuTile(
                  icon: Icons.key_outlined,
                  title: S.of(context).accessKeys,
                  onTap: () => Navigator.push(context, createPageRoute(const AccessKeysScreen())),
                ),
                _buildSettingsMenuTile(
                  icon: Icons.email_outlined,
                  title: S.of(context).emailAddress,
                  onTap: () => Navigator.push(context, createPageRoute(const EmailAddressScreen())),
                ),
                _buildSettingsMenuTile(
                  icon: ChatifyVectors.shieldCheckeredFilled,
                  title: S.of(context).securityNotices,
                  onTap: () => Navigator.push(context, createPageRoute(const NotificationsSecurityScreen())),
                ),
                _buildSettingsMenuTile(
                  icon: ChatifyVectors.pinCode,
                  title: S.of(context).twoStepVerification,
                  onTap: () {
                    Navigator.push(context, createPageRoute(const TwoStepVerificationScreen()));
                  },
                ),
                _buildSettingsMenuTile(
                  icon: MonoIcons.document,
                  title: S.of(context).requestAccountInfo,
                  onTap: () => Navigator.push(context, createPageRoute(const RequestAccountInformationScreen())),
                ),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 0),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 20, top: 16, bottom: 14),
                  child: Text('Ваш аккаунт', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
                _buildSettingsMenuTile(
                  icon: Icons.alternate_email_rounded,
                  title: S.of(context).username,
                  onTap: () => Navigator.push(context, createPageRoute(const UsernameScreen())),
                ),
                _buildSettingsMenuTile(
                  icon: FluentIcons.phone_eraser_20_regular,
                  title: S.of(context).changeNumber,
                  onTap: () => Navigator.push(context, createPageRoute(const EditPhoneScreen())),
                ),
                _buildSettingsMenuTile(
                  icon: MonoIcons.delete,
                  title: S.of(context).deleteAccount,
                  onTap: () => Get.to(() => const DeleteAccountScreen()),
                ),
                _buildSettingsMenuTile(
                  icon: ChatifyVectors.exit,
                  iconColor: ChatifyColors.danger,
                  title: S.of(context).logout,
                  titleColor: ChatifyColors.danger,
                  onTap: () async {
                    await LogoutDialog.showLogoutDialog(
                      context,
                      onConfirm: () async {
                        Navigator.pop(context);
                        Dialogs.showProgressBar(context);
                        final googleSignIn = GoogleSignIn.instance;

                        try {
                          await APIs.updateActiveStatus(false);
                          await APIs.auth.signOut();
                          await googleSignIn.signOut();
                          APIs.auth = FirebaseAuth.instance;

                          Dialogs.hideProgressBar(context);

                          Navigator.pushReplacement(context, createPageRoute(const LoginScreen()));
                        } catch (e) {
                          Dialogs.hideProgressBar(context);
                          CustomIconSnackBar.showAnimatedSnackBar(context, S.of(context).errorLogout, icon: const HeroIcon(HeroIcons.exclamationTriangle), iconColor: ChatifyColors.error);
                          Dialogs.showSnackbar(context, S.of(context).errorDuringLogout);
                        }
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      logoutTitle: S.of(context).logout,
                      logoutMessage: S.of(context).sureLogoutAccount,
                      cancelText: S.of(context).cancel,
                      confirmText: S.of(context).sure,
                      colorScheme: Theme.of(context).colorScheme,
                      isDarkMode: context.isDarkMode
                    );
                  },
                ),
                const SizedBox(height: ChatifySizes.spaceBtwItems),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuTile({dynamic icon, required String title, required VoidCallback onTap, String subTitle = '', Color? iconColor, Color? titleColor}) {
    return SettingsMenuTile(
      icon: icon,
      title: title,
      subTitle: subTitle,
      titleFontSize: ChatifySizes.fontSizeSm,
      titleColor: titleColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      iconColor: iconColor ?? colorsController.getColor(colorsController.selectedColorScheme.value),
      onTap: onTap,
    );
  }
}
