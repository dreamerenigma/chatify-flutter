import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/chats_calls_privacy_sheet_dialog.dart';

class PrivateMessagesProtectedNotice extends StatelessWidget {
  const PrivateMessagesProtectedNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
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
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Icons.lock_outline, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, size: 14),
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).yourPrivateMessagesProtected,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                    ),
                    TextSpan(
                      text: S.of(context).endToEndEncryption,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.bold, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        showChatsCallsPrivacyBottomSheet(
                          context,
                          headerText: S.of(context).yourChatsCallsConfidential,
                          titleText: S.of(context).yourPrivateMessagesAndCalls,
                        );
                      },
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
