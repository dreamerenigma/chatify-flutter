import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/controllers/colors_controller.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/archive_screen.dart';
import '../dialogs/chats_calls_privacy_sheet_dialog.dart';

class ArchivePrivacySection extends StatelessWidget {
  const ArchivePrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey;

    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, createPageRoute(ArchiveScreen()));
            },
            splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
            child: Padding(
              padding: const EdgeInsets.only(left: 36, right: 22, top: 14, bottom: 14),
              child: Row(
                children: [
                  Icon(Icons.archive_outlined, size: 24, color: color),
                  const SizedBox(width: 22),
                  Text('В архиве', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: color)),
                  const Spacer(),
                  Text('3', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: color)),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1, color: isDark ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
          Padding(
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
                            child: Padding(padding: const EdgeInsets.only(right: 12), child: Icon(Icons.lock_outline, color: color, size: 14)),
                          ),
                          TextSpan(text: S.of(context).yourPrivateMessagesProtected, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: color)),
                          TextSpan(
                            text: S.of(context).encryption,
                            style: TextStyle(
                              fontSize: ChatifySizes.fontSizeLm,
                              fontWeight: FontWeight.bold,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
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
          ),
        ],
      ),
    );
  }
}
