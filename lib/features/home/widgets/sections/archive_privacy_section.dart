import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/archive/archive_screen.dart';
import '../infos/private_messages_protected_notice.dart';

class ArchivePrivacySection extends StatelessWidget {
  const ArchivePrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey;

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
                  Text(S.of(context).inArchive, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: color)),
                  const Spacer(),
                  Text('3', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: color)),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
          PrivateMessagesProtectedNotice(),
        ],
      ),
    );
  }
}
