import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

Future<void> showCustomDialog(
  BuildContext parentContext, {
  required String title,
  required String subtitle,
  required String confirmText,
  required Future<void> Function() onConfirm,
  String? successMessage,
  VoidCallback? onSuccess,
  String? cancelText,
}) async {
  final rootNavigator = Navigator.of(parentContext, rootNavigator: true);

  await showDialog<void>(
    context: parentContext,
    builder: (BuildContext context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            title: Text(
              title,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
            ),
            content: Text(subtitle, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
            actionsPadding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
            titlePadding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 3),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  cancelText ?? S.of(context).cancel,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                ),
              ),
              TextButton(
                onPressed: isLoading ? null : () async {
                  setDialogState(() => isLoading = true);

                  Navigator.of(context).pop();

                  Dialogs.showProgressBarDialog(parentContext, title: S.of(parentContext).submittingComplaint, message: S.of(parentContext).pleaseWait);

                  try {
                    await onConfirm();

                    if (rootNavigator.mounted && rootNavigator.canPop()) {
                      rootNavigator.pop();
                    }

                    onSuccess?.call();

                    if (successMessage != null && parentContext.mounted) {
                      CustomIconSnackBar.showAnimatedSnackBar(
                        parentContext,
                        successMessage,
                        icon: const Icon(BootstrapIcons.check_circle),
                        iconColor: ChatifyColors.success,
                        position: SnackBarPositionType.bottom,
                        offset: 20,
                      );
                    }
                  } catch (e, st) {
                    log('CUSTOM DIALOG: ERROR = $e');
                    log('CUSTOM DIALOG: STACK = $st');

                    if (rootNavigator.mounted && rootNavigator.canPop()) {
                      rootNavigator.pop();
                    }
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value,),
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  confirmText,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
