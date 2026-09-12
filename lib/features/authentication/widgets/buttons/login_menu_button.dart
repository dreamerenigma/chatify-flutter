import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../personalization/screens/help/support/support_screen.dart';
import '../../screens/login_screen.dart';

class LoginMenuButton extends StatefulWidget {
  final BuildContext parentContext;

  const LoginMenuButton({
  super.key,
  required this.parentContext,
  });

  @override
  State<LoginMenuButton> createState() => _LoginMenuButtonState();
}

class _LoginMenuButtonState extends State<LoginMenuButton> {
  Future<void> showDialogsSequentially(BuildContext context) async {
    await Dialogs.showCustomDialog(context: context, message: S.of(context).settingsSearch, duration: const Duration(seconds: 1));
    await Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey menuKey = GlobalKey();

    return Positioned(
      top: isWebOrWindows ? 0 : (isMobile ? 30 : 10),
      right: !kIsWeb && Platform.isWindows ? 5 : 0,
      child: CustomTooltip(
        message: S.of(context).login,
        horizontalOffset: -35,
        verticalOffset: 0,
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            key: menuKey,
            onTap: () async {
              final RenderBox renderBox = menuKey.currentContext?.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);

              showMenu(
                context: context,
                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                position: RelativeRect.fromLTRB(position.dx, isWebOrWindows ? position.dy : position.dy + renderBox.size.height, position.dx + renderBox.size.width, 0),
                items: [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).help,
                      onTap: () => Navigator.pop(context, 1),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).login,
                      onTap: () => Navigator.pop(context, 2),
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ).then((value) async {
                if (value == 1) {
                  await showDialogsSequentially(context);
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const SupportScreen(title: 'Поддержка'),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ));
                } else if (value == 2) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ));
                }
              });
            },
            mouseCursor: SystemMouseCursors.basic,
            splashFactory: NoSplash.splashFactory,
            borderRadius: BorderRadius.circular(8),
            splashColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}
