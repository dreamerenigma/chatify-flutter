import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class EncryptionInfoText extends StatelessWidget {
  final String firstText;
  final String linkText;
  final String? thirdText;

  const EncryptionInfoText({
    super.key,
    required this.firstText,
    required this.linkText,
    this.thirdText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(Icons.lock_outline, size: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: firstText, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: 13)),
                    TextSpan(
                      text: linkText,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w400),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).yourStatusAndChatsPrivate, titleText: S.of(context).statusUpdatesAndPrivateMessages);
                      },
                    ),
                    if (thirdText != null)
                      TextSpan(
                        text: thirdText,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: 13, fontWeight: FontWeight.w400),
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
