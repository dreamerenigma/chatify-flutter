import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../authentication/screens/login_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../widgets/dialogs/add_user_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/logout_dialog.dart';

class LogoutScreen extends StatefulWidget {
  final UserModel user;

  const LogoutScreen({
    super.key,
    required this.user,
  });

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  Future<void> _logout() async {
    Dialogs.showProgressBar(context);

    final googleSignIn = GoogleSignIn.instance;

    try {
      await APIs.updateActiveStatus(false);
      await APIs.auth.signOut();
      await googleSignIn.signOut();

      APIs.auth = FirebaseAuth.instance;

      if (!mounted) return;

      Dialogs.hideProgressBar(context);

      Navigator.pushReplacement(context, createPageRoute(const LoginScreen()));
    } catch (e) {
      if (!mounted) return;

      Dialogs.hideProgressBar(context);

      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).errorLogout,
        icon: const HeroIcon(HeroIcons.exclamationTriangle),
        iconColor: ChatifyColors.error,
      );

      Dialogs.showSnackbar(context, S.of(context).errorDuringLogout);
    }
  }

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
            title: Text(S.of(context).logout, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 6),
            child: Text(
              'Прежде чем выйти, ознакомьтесь с доступными дял вашего аккаунта вариантами.',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.3),
            ),
          ),
          _buildSettingsMenuTile(
            icon: Icons.person_add_alt,
            iconColor: ChatifyColors.darkGrey,
            title: S.of(context).addAccount,
            titleColor: ChatifyColors.grey,
            onTap: () => showAddUserBottomSheet(context, widget.user.image, widget.user.name, widget.user.phoneNumber),
          ),
          _buildSettingsMenuTile(
            icon: Icons.lock_outline_rounded,
            iconColor: ChatifyColors.darkGrey,
            title: 'Заблокировать приложение',
            titleColor: ChatifyColors.grey,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: Icons.notifications_none_rounded,
            iconColor: ChatifyColors.darkGrey,
            title: 'Управление уведомлениями',
            titleColor: ChatifyColors.grey,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: Icons.folder_outlined,
            iconColor: ChatifyColors.darkGrey,
            title: 'Необходимо освободить место в хранилище',
            titleColor: ChatifyColors.danger,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: Icons.folder_outlined,
            iconColor: ChatifyColors.darkGrey,
            title: 'Создать резервную копию чата',
            titleColor: ChatifyColors.danger,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: Icons.folder_outlined,
            iconColor: ChatifyColors.darkGrey,
            title: 'Необходимо освободить место в хранилище',
            titleColor: ChatifyColors.danger,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: SvgPicture.asset(ChatifyVectors.exit, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.danger, BlendMode.srcIn)),
            iconColor: ChatifyColors.danger,
            title: S.of(context).logout,
            titleColor: ChatifyColors.danger,
            onTap: () async {
              await LogoutDialog.showLogoutDialog(
                context,
                onConfirm: () async {
                  Navigator.pop(context);
                  await _logout();
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                logoutTitle: S.of(context).logout,
                logoutMessage: S.of(context).sureLogoutAccount,
                cancelText: S.of(context).cancel,
                confirmText: S.of(context).sure,
                colorScheme: Theme.of(context).colorScheme,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenuTile({
    dynamic icon,
    required String title,
    required VoidCallback onTap,
    String subTitle = '',
    Color? iconColor,
    Color? titleColor,
    double? iconSize,
  }) {
    return SettingsMenuTile(
      icon: icon,
      title: title,
      subTitle: subTitle,
      titleFontSize: ChatifySizes.fontSizeMd,
      titleColor: titleColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      iconColor: iconColor ?? colorsController.getColor(colorsController.selectedColorScheme.value),
      iconSize: iconSize,
      onTap: onTap,
      noRoundedCorners: true,
      backgroundColor: ChatifyColors.transparent,
    );
  }
}
