import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_links.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/popups/progress_overlay.dart';
import '../../../../../utils/urls/url_utils.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../controllers/dialog_controller.dart';

class ContactingSupportOverlay {
  late OverlayEntry _overlayEntry;
  final bool showStartChatButton;
  final BuildContext context;
  final TextEditingController controller = TextEditingController();

  ContactingSupportOverlay(this.context, {this.showStartChatButton = true});

  void show() {
    final overlay = Overlay.of(context);
    final dialogController = Get.find<DialogController>();
    final ValueNotifier<bool> isHovering = ValueNotifier(false);
    bool hasCreatedSupportChat = false;

    _overlayEntry = OverlayEntry(
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
                  width: 500,
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
                      const SizedBox(height: 50),
                      Center(child: SvgPicture.asset(ChatifyVectors.contactSupport, width: 60, height: 60)),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(S.of(context).contactingOfficialAppSupport, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem(ChatifyVectors.shieldCheck, S.of(context).protectChatsApp, spacing: 12),
                      _buildInfoItem(ChatifyVectors.questionAi, S.of(context).answersGeneratedAi, spacing: 12),
                      _buildInfoItem(ChatifyVectors.review, S.of(context).leaveReviewHelpImprove, spacing: 7),
                      const SizedBox(height: 16),
                      Divider(height: 1, thickness: 0, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                ),
                            children: [
                              TextSpan(
                                text: S.of(context).answersAiGeneratedSecureTechnology,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300, height: 1.2),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: isHovering,
                                  builder: (context, hovering, _) {
                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      onEnter: (_) => isHovering.value = true,
                                      onExit: (_) => isHovering.value = false,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          S.of(context).readMore,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                            decoration: hovering ? TextDecoration.none : TextDecoration.underline,
                                            decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                          border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey, width: 0.5)),
                        ),
                        child: showStartChatButton
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      ProgressOverlay(context).show();
                                      final userId = FirebaseAuth.instance.currentUser?.uid;
                                      if (userId != null && !hasCreatedSupportChat) {
                                        await APIs.createSupportChat(userId);
                                        hasCreatedSupportChat = true;
                                      }

                                      _overlayEntry.remove();
                                      dialogController.closeWindowsDialog();
                                    },
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      foregroundColor: ChatifyColors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 1,
                                      shadowColor: ChatifyColors.black,
                                    ).copyWith(
                                      mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text(S.of(context).startChat, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildCancelButton(dialogController),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      UrlUtils.launchURL(AppLinks.helpCenter);
                                      _overlayEntry.remove();
                                      dialogController.closeWindowsDialog();
                                    },
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      foregroundColor: ChatifyColors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 1,
                                      shadowColor: ChatifyColors.black,
                                    ).copyWith(
                                      mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text(S.of(context).readMore, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: _buildCancelButton(dialogController)),
                              ],
                            ),
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

    overlay.insert(_overlayEntry);
  }

  void close() {
    _overlayEntry.remove();
  }

  Widget _buildCancelButton(DialogController dialogController) {
    return TextButton(
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          _overlayEntry.remove();
          dialogController.closeWindowsDialog();
        });
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
        foregroundColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1),
        elevation: 1,
        shadowColor: ChatifyColors.black,
      ).copyWith(
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
      ),
    );
  }
}

Widget _buildInfoItem(String iconPath, String text, {double spacing = 12}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      children: [
        SvgPicture.asset(iconPath),
        SizedBox(width: spacing),
        Expanded(child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm))),
      ],
    ),
  );
}
