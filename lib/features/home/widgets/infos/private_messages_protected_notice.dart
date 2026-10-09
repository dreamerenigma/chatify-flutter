import 'package:chatify/utils/platforms/platform_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/chats_calls_privacy_dialog.dart';
import '../dialogs/chats_calls_privacy_sheet_dialog.dart';

class PrivateMessagesProtectedNotice extends StatelessWidget {
  final double? fontSize;
  final double? iconSize;
  final String? additionalText;

  const PrivateMessagesProtectedNotice({
    super.key,
    this.fontSize,
    this.iconSize,
    this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    final textFontSize = fontSize ?? ChatifySizes.fontSizeLm;
    final lockIconSize = iconSize ?? 14;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(Icons.lock_outline, size: lockIconSize, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).yourPrivateMessagesProtected,
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: textFontSize, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                    TextSpan(
                      text: S.of(context).endToEndEncryption,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: textFontSize, fontWeight: FontWeight.bold, height: 1.5),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        if (isWindows) {
                          showChatsCallsPrivacyDialog(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
                        } else {
                          showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
                        }
                      },
                    ),
                    if (additionalText != null)
                      TextSpan(
                        text: ' $additionalText',
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: textFontSize, fontWeight: FontWeight.w400, height: 1.5),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
