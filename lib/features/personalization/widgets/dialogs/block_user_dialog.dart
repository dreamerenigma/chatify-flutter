import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../home/widgets/checkboxes/custom_checkbox.dart';
import 'light_dialog.dart';

void showBlockUserDialog(BuildContext parentContext, UserModel user, {VoidCallback? onBlocked}) {
  final rootNavigator = Navigator.of(parentContext, rootNavigator: true);
  final RxList<bool> selectedOptions = <bool>[false].obs;

  showDialog(
    context: parentContext,
    useRootNavigator: true,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Theme.of(parentContext).brightness == Brightness.dark ? ChatifyColors.blackGrey : ChatifyColors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: const Icon(Icons.not_interested, size: 32, color: ChatifyColors.buttonLightGrey),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(child: Text('Заблокировать контакт ${user.name}${user.surname.isNotEmpty ? ' ${user.surname}' : ''}?', textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400))),
                  const SizedBox(height: 12),
                  Text('Этот пользователь не сможет отправлять вам сообщения или звонить. Он не узнает, что вы его заблокировали или отправили на него жалобу.', style: TextStyle(color: ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm, height: 1.4)),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCheckbox(
                        index: 0,
                        selectedOptions: selectedOptions,
                        onChanged: (value) {},
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Пожаловаться в Chatify',
                          style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
                        children: [
                          const TextSpan(text: 'Последние 5 сообщений из этого чата будут пересланы в Chatify. '),
                          TextSpan(text: S.of(parentContext).readMore, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w500, decoration: TextDecoration.none),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(parentContext);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          ),
                          child: Text(S.of(parentContext).cancel, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                        ),
                      ),
                      SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: TextButton(
                          onPressed: () async {
                            rootNavigator.pop();

                            Dialogs.showProgressBarDialog(parentContext, title: S.of(parentContext).submittingComplaint, message: S.of(parentContext).pleaseWait);

                            try {
                              await APIs.blockUser(user);

                              onBlocked?.call();

                              if (rootNavigator.mounted && rootNavigator.canPop()) {
                                rootNavigator.pop();
                              }

                              if (parentContext.mounted) {
                                CustomIconSnackBar.showAnimatedSnackBar(
                                  parentContext,
                                  'Контакт ${user.name} ${user.surname} заблокирован',
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
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          ),
                          child: Text('Заблокировать', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
