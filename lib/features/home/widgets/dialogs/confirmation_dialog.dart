import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/buttons/custom_bottom_buttons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../controllers/dialog_controller.dart' show DialogController;

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  String? title,
  String? description,
  String? confirmText,
  String? cancelText,
  String? middleButtonText,
  VoidCallback? middleButtonAction,
  bool confirmButton = false,
  bool reverseButtons = false,
  bool showTopTitleDuplicate = false,
  double? width,
  Widget? additionalWidget,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
  Color? cancelTextColor,
  double? cancelButtonWidth,
}) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  final completer = Completer<bool>();
  late OverlayEntry overlayEntry;
  final String finalConfirmText = confirmText ?? S.of(context).yes;
  final String finalCancelText = cancelText ?? S.of(context).no;

  overlayEntry = OverlayEntry(
    builder: (context) {
      dialogController.openWindowsDialog();

      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry.remove();
                dialogController.closeWindowsDialog();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: ChatifyColors.black.withAlpha((0.5 * 255).toInt())),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Material(
              color: ChatifyColors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: width ?? 465,
                  decoration: BoxDecoration(
                    border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            if (showTopTitleDuplicate && title != null) ...[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey, width: 0.5)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Text(
                                  title,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                ),
                              ),
                            ],
                            Container(
                              padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: description != null ? 26 : 22),
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title != null) Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                                  SizedBox(height: description != null ? 10 : 0),
                                  if (description != null) Text(description, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
                                  if (additionalWidget != null) ...[
                                    SizedBox(height: 10),
                                    additionalWidget,
                                  ],
                                ],
                              ),
                            ),
                            Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.buttonGrey),
                            CustomBottomButtons(
                              onConfirm: onConfirm,
                              onClose: () => completer.complete(true),
                              onCancel: () => completer.complete(false),
                              confirmText: finalConfirmText,
                              cancelText: finalCancelText,
                              overlayEntry: overlayEntry,
                              dialogController: dialogController,
                              primaryColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              showConfirmButton: confirmButton,
                              confirmButtonColor: confirmButtonColor ?? ChatifyColors.softNight,
                              cancelButtonColor: cancelButtonColor ?? ChatifyColors.softNight,
                              cancelTextColor: cancelTextColor,
                              reverseButtons: reverseButtons,
                              middleButtonText: middleButtonText,
                              middleButtonAction: middleButtonAction,
                              cancelButtonWidth: cancelButtonWidth,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  return completer.future;
}
