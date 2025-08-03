import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/buttons/custom_bottom_buttons.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_links.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/urls/url_utils.dart';
import '../../../../home/controllers/dialog_controller.dart';
import '../light_dialog.dart';

class InfoChatSupportAppOverlay {
  late OverlayEntry overlayEntry;
  final BuildContext context;

  InfoChatSupportAppOverlay(this.context);

  void show() {
    final overlay = Overlay.of(context);
    final dialogController = Get.find<DialogController>();

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        dialogController.openWindowsDialog();

        return Material(
          color: ChatifyColors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: close,
                behavior: HitTestBehavior.opaque,
                child: Container(color: ChatifyColors.black.withAlpha((0.3 * 256).toInt())),
              ),
              Center(
                child: Container(
                  width: 480,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.buttonDarkGrey : ChatifyColors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 32, right: 32, top: 24),
                              child: Text(S.of(context).appAiSupportChatInfo, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 26, right: 38, top: 16, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    context,
                                    ChatifyVectors.handFavorite,
                                    S.of(context).getHelpFaster,
                                    S.of(context).appSupportTeamAiQuestions,
                                  ),
                                  SizedBox(height: 12),
                                  _buildInfoRow(
                                    context,
                                    ChatifyVectors.questionAi,
                                    S.of(context).findOutChatsUseAi,
                                    '',
                                    insertAiIcon: true,
                                  ),
                                  SizedBox(height: 12),
                                  _buildInfoRow(
                                    context,
                                    ChatifyVectors.question,
                                    S.of(context).moreInfoVisitHelpCenter,
                                    S.of(context).visitHelpCenterFindAnswers
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomBottomButtons(
                        confirmText: S.of(context).readMore,
                        cancelText: S.of(context).cancel,
                        onConfirm: () => UrlUtils.launchURL(AppLinks.supportAI),
                        overlayEntry: overlayEntry,
                        dialogController: dialogController,
                        primaryColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        showConfirmButton: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
  }

  void close() {
    overlayEntry.remove();
  }
}

Widget _buildInfoRow(BuildContext context, String icon, String title, String subtitle, {bool insertAiIcon = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 22),
        child: SvgPicture.asset(icon, color: ChatifyColors.primary, width: 20, height: 20),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500, color: Get.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
            SizedBox(height: 4),
            insertAiIcon
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: Get.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.darkGrey),
                    children: [
                      TextSpan(text: S.of(context).aiGeneratedMessagesMarkedSymbol),
                      WidgetSpan(alignment: PlaceholderAlignment.middle, child: SvgPicture.asset(ChatifyVectors.ai, width: 16, height: 16, color: Get.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                      TextSpan(text: S.of(context).feedbackAiGeneratedMessagesAppQuality),
                    ],
                  ),
                )
              : Text(subtitle, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: Get.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.darkGrey),),
          ],
        ),
      ),
    ],
  );
}
