import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
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
import '../notifications/notifications_screen.dart';
import '../privacy/privacy_blocked_app_screen.dart';

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

      Dialogs.hideProgressBar();

      Navigator.pushReplacement(context, createPageRoute(const LoginScreen()));
    } catch (e) {
      if (!mounted) return;

      Dialogs.hideProgressBar();

      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).errorLogout,
        icon: const HeroIcon(HeroIcons.exclamationTriangle),
        iconColor: ChatifyColors.error,
        position: SnackBarPositionType.bottom,
        offset: 20,
      );

      Dialogs.showSnackbar(context, S.of(context).errorDuringLogout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoutMessage = 'Вы выйдете из аккаунта ${widget.user.phoneNumber} на этом устройстве. ''Через 14 дн. будет выполнен выход из аккаунта на связанных устройствах (2).';

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
              'Прежде чем выйти, ознакомьтесь с доступными для вашего аккаунта вариантами.',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4),
            ),
          ),
          _buildSettingsMenuTile(
            icon: Icons.person_add_alt,
            iconColor: ChatifyColors.darkGrey,
            iconSize: 23,
            title: S.of(context).addAccount,
            titleColor: ChatifyColors.grey,
            onTap: () => showAddUserBottomSheet(context, widget.user.image, widget.user.name, widget.user.phoneNumber),
          ),
          _buildSettingsMenuTile(
            icon: Icons.lock_outline_rounded,
            iconColor: ChatifyColors.darkGrey,
            iconSize: 23,
            title: 'Заблокировать приложение',
            titleColor: ChatifyColors.grey,
            onTap: () {
              Navigator.push(context, createPageRoute(const PrivacyBlockedAppScreen()));
            },
          ),
          _buildSettingsMenuTile(
            icon: Icons.notifications_none_rounded,
            iconColor: ChatifyColors.darkGrey,
            title: 'Управление уведомлениями',
            iconSize: 25,
            titleColor: ChatifyColors.grey,
            onTap: () {
              Navigator.push(context, createPageRoute(const NotificationsScreen()));
            },
          ),
          _buildSettingsMenuTile(
            icon: Icons.folder_outlined,
            iconColor: ChatifyColors.darkGrey,
            iconSize: 24,
            title: 'Необходимо освободить место в хранилище',
            titleColor: ChatifyColors.grey,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: SvgPicture.asset(ChatifyVectors.upload, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            iconColor: ChatifyColors.darkGrey,
            title: 'Создать резервную копию чатов',
            titleColor: ChatifyColors.grey,
            onTap: () {},
          ),
          _buildSettingsMenuTile(
            icon: SvgPicture.asset(ChatifyVectors.exit, width: 28, height: 28, colorFilter: ColorFilter.mode(ChatifyColors.danger, BlendMode.srcIn)),
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
                logoutTitle: S.of(context).logoutQuestion,
                logoutMessage: logoutMessage,
                cancelText: S.of(context).cancel,
                confirmText: S.of(context).logout,
                colorScheme: Theme.of(context).colorScheme,
              );
            },
            subtitleWidget: Text.rich(
              TextSpan(
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: 'Ваши учетные данные будут сохранены на этом устройстве. ',
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Подробнее',
                        style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
    Widget? subtitleWidget,
  }) {
    return SettingsMenuTile(
      icon: icon,
      title: title,
      subTitle: subTitle,
      subtitleWidget: subtitleWidget,
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
