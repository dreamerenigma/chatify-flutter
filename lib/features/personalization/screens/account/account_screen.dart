import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:radix_icons/radix_icons.dart';
import 'package:chatify/features/personalization/screens/account/request_account_information_screen.dart';
import 'package:chatify/features/personalization/screens/account/two_step_verification_screen.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
import '../../../chat/models/user_model.dart';
import '../../widgets/dialogs/add_user_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/logout_dialog.dart';
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
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text(S.of(context).account, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
            iconTheme: IconThemeData(
              color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            ),
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
                  icon: PhosphorIcons.shield_checkered_fill,
                  title: S.of(context).securityNotices,
                  onTap: () => Navigator.push(
                    context,
                    createPageRoute(const NotificationsSecurityScreen()),
                  ),
                ),
                _buildSettingsMenuTile(
                  icon: Icons.key_outlined,
                  title: S.of(context).accessKeys,
                  onTap: () => Navigator.push(
                    context,
                    createPageRoute(const AccessKeysScreen()),
                  ),
                ),
                _buildSettingsMenuTile(
                  icon: Icons.email_outlined,
                  title: S.of(context).emailAddress,
                  onTap: () => Navigator.push(
                    context,
                    createPageRoute(const EmailAddressScreen()),
                  ),
                ),
                _buildSettingsMenuTile(
                  svgIconPath: ChatifyVectors.pinCode,
                  title: 'Two-step verification',
                  onTap: () {
                    Navigator.push(
                      context,
                      createPageRoute(const TwoStepVerificationScreen()),
                    );
                  },
                ),
                _buildSettingsMenuTile(
                  icon: FluentIcons.phone_eraser_20_regular,
                  title: S.of(context).changeNumber,
                  onTap: () => Navigator.push(
                    context,
                    createPageRoute(const EditPhoneScreen()),
                  ),
                ),
                _buildSettingsMenuTile(
                  icon: MonoIcons.document,
                  title: S.of(context).requestAccountInfo,
                  onTap: () => Navigator.push(
                    context,
                    createPageRoute(const RequestAccountInformationScreen()),
                  ),
                ),
                _buildSettingsMenuTile(
                  icon: Icons.person_add_alt,
                  title: S.of(context).addAccount,
                  onTap: () => showAddUserBottomSheet(
                    context,
                    widget.user.image,
                    widget.user.name,
                    widget.user.phoneNumber,
                  ),
                ),
                _buildSettingsMenuTile(
                  icon: MonoIcons.delete,
                  title: S.of(context).deleteAccount,
                  onTap: () => Get.to(() => const DeleteAccountScreen()),
                ),
                _buildSettingsMenuTile(
                  icon: RadixIcons.Exit,
                  title: 'Выйти',
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
                          log('Error during logout: $e');
                          Dialogs.hideProgressBar(context);
                          CustomIconSnackBar.showAnimatedSnackBar(context, 'Ошибка при выходе из системы. Попробуйте еще раз.', icon: const HeroIcon(HeroIcons.exclamationTriangle), iconColor: ChatifyColors.error);
                          Dialogs.showSnackbar(context, 'Error during logout. Please try again.');
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

  Widget _buildSettingsMenuTile({
    IconData? icon,
    String? svgIconPath,
    required String title,
    required VoidCallback onTap,
    String subTitle = '',
  }) {
    return SettingsMenuTile(
      icon: svgIconPath ?? icon,
      title: title,
      subTitle: subTitle,
      titleFontSize: ChatifySizes.fontSizeSm,
      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      onTap: onTap,
    );
  }
}
