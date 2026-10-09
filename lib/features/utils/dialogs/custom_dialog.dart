import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../api/apis.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

void showCustomDialog(BuildContext parentContext, UserModel user, {VoidCallback? onUnblocked}) {
  final rootNavigator = Navigator.of(parentContext, rootNavigator: true);

  showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        content: Text(
          'Разблокируйте пользователя ${user.name} ${user.surname}, чтобы добавить в группу.',
          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
        ),
        actionsPadding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
          ),
          TextButton(
            onPressed: () async {
              rootNavigator.pop();

              Dialogs.showProgressBarDialog(parentContext, title: S.of(parentContext).submittingComplaint, message: S.of(parentContext).pleaseWait);

              try {
                await APIs.unBlockUser(user);

                onUnblocked?.call();

                if (rootNavigator.mounted && rootNavigator.canPop()) {
                  rootNavigator.pop();
                }

                if (parentContext.mounted) {
                  CustomIconSnackBar.showAnimatedSnackBar(
                    parentContext,
                    'Контакт ${user.name} ${user.surname} разблокирован',
                    icon: const Icon(BootstrapIcons.check_circle),
                    iconColor: ChatifyColors.success,
                    position: SnackBarPositionType.bottom,
                    offset: 20,
                  );
                }
              } catch (e, st) {
                log('BLOCK DIALOG: ERROR = $e');
                log('BLOCK DIALOG: STACK = $st');
                if (rootNavigator.mounted && rootNavigator.canPop()) {
                  rootNavigator.pop();
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              'Разблокировать',
              style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      );
    },
  );
}
