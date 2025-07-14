import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/urls/url_utils.dart';
import '../../../../home/controllers/dialog_controller.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../info/encryption_info_block.dart';

void showChatsCallsPrivacyOverlay(BuildContext context) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: 550,
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
                            EncryptionInfoBlock(),
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey, width: 0.5)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        overlayEntry.remove();
                                        dialogController.closeWindowsDialog();
                                        UrlUtils.launchURL('https://chatify.ru/security?lg=ru&lc=RU&eea=0');
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                                        foregroundColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1),
                                        elevation: 1,
                                        shadowColor: ChatifyColors.black,
                                        splashFactory: NoSplash.splashFactory,
                                      ).copyWith(
                                        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        child: Text('Подробнее', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Future.delayed(Duration(milliseconds: 100), () {
                                          overlayEntry.remove();
                                          dialogController.closeWindowsDialog();
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        foregroundColor: ChatifyColors.black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 1,
                                        shadowColor: ChatifyColors.black,
                                        splashFactory: NoSplash.splashFactory,
                                      ).copyWith(
                                        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        child: Text('ОК', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
}
